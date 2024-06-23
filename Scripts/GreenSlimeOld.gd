extends CharacterBody2D

@export var VariedSpeed : float = 0 # Varied Speed controlled by animator player
@export var acceleration = 7
@export var PursueDistance : int = 50 # Distance from target to stop at
@export var Target: Node2D
@export var MoveTowardsTarget : bool = false # Toggle to begin pathfinding
@export var DebugLabelVisible : bool = false # Label to tell which state enemy is in

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

# Navigation Elements
@onready var navigation_agent_2d = $Navigation/NavigationAgent2D
@onready var timer = $Navigation/Timer
@onready var debug_state = $Navigation/DebugState

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("Idle")
	animation_player.play("Idle")
	if DebugLabelVisible : 
		debug_state.visible = true
	debug_state.text = "Idle"
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# Examine distance that enemy is away from Target
	MoveTowardsTarget = !Target_Reached(Target)
	if !MoveTowardsTarget:
		if (timer.time_left > 0): timer.stop()
		return
	else:
		if (timer.time_left == 0): timer.start()
		debug_state.text = "Pursuing\n" + Target.name
	
	var direction = navigation_agent_2d.get_next_path_position() - self.global_position
	direction = direction.normalized()
	
	# Flip Sprite based on direction normal (negative = left, positive = right)
	if direction.x < 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	#print("Slimedirection = " + str(direction.x))
	#print("SlimeVariedSpeed = " + str(VariedSpeed))
	velocity = velocity.lerp(direction * VariedSpeed, acceleration * delta)
	animation_player.play("SlideMove")
	move_and_slide()

func _on_timer_timeout():
	navigation_agent_2d.target_position = Target.global_position

func SwapTargets(NewTarget : Node2D):
	Target = NewTarget
	navigation_agent_2d.target_position = Target.global_position
	timer.start()

func Target_Reached(Target : Node2D) -> bool:
	# Examine distance that enemy is away from Target
	var distance =  Target.global_position - global_position
	#print("SlimeDistance.length() = " + str(distance.length()))
	if distance.length() <= PursueDistance: 
		#print("GreenSlime(): Target reached!")
		return true
	else:
		return false
