extends CharacterBody2D

@export var Speed = 50
@export var acceleration = 7
@export var Target: Node2D
@export var MoveTowardsTarget : bool = false # Toggle to begin pathfinding
@export var DebugLabelVisible : bool = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var timer = $Timer
@onready var debug_state = $DebugState

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("Idle")
	animation_player.play("Idle")
	if DebugLabelVisible : debug_state.visible = true
	debug_state.text = "Idle"
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if !MoveTowardsTarget:
		if (timer.time_left > 0): timer.stop()
		return
	else:
		if (timer.time_left == 0): timer.start()
		debug_state.text = "Pursuing\n" + Target.name
	
	var direction = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * Speed, acceleration * delta)
	move_and_slide()

func _on_timer_timeout():
	navigation_agent_2d.target_position = Target.global_position
