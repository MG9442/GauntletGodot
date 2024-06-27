extends CharacterBody2D
class_name  GreenSlimeEnemy
# Enemy Script

# Responsible for:
# Movement, speed, accel, target
# Animation playing
# Raycast, Line of Sight detection
# Distance to a specific target

@export var VariedSpeed : float = 0 # Varied Speed controlled by animator player
@export var acceleration = 7
@export var DebugLabelVisible : bool = false # Label to tell which state enemy is in
@onready var debug_state = $Navigation/DebugState
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var enemy_pursue_state = $StateMachine/EnemyPursueState
@onready var ray_cast_2d = $Navigation/RayCast2D

var Player_in_range : Node2D # Player body entered Detection
var PlayerTarget : Node2D # Player in Range & LOS
var movement_target : Vector2 # Next Movement target
var movement_disabled : bool

# Debug testing
var TargetObject: Node2D # Used to track a player or object

# Called when the node enters the scene tree for the first time.
func _ready():
	if DebugLabelVisible : #Enable debug label if toggled
		debug_state.visible = true
	animation_player.play("Idle")
	debug_state.text = "Idle"
	
func _physics_process(delta):
	# Examine player in range and check LOS, set PlayerTarget
	SetActiveTarget()
	
	if movement_target == null:
		return
	
	var direction = movement_target - global_position
	direction = direction.normalized()
	
	# Flip Sprite based on direction normal (negative = left, positive = right)
	if direction.x < 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	if !movement_disabled: # Move towards unless disabled
		velocity = velocity.lerp(direction * VariedSpeed, acceleration * delta)
		animation_player.play("SlideMove")
		move_and_slide()

# Determine if Target position is within a specific distance
func Target_in_Range(TargetExamine : Vector2, PixelDistance : int) -> bool:
	# Examine distance that enemy is away from Target
	var distance =  TargetExamine - global_position
	#print("SlimeDistance.length() = " + str(distance.length()))
	if distance.length() <= PixelDistance: 
		#print("GreenSlime(): Target reached!")
		return true
	else:
		return false
	
func CheckLOS(Target : Node2D) -> bool:
	if Target: # If target is valid, set raycast position to Target
		var TargetCentermass : Vector2 = Target.global_position
		TargetCentermass.y -= 15 # Center raycast to the middle of Target
		ray_cast_2d.target_position = TargetCentermass - global_position
		
		# If raycast is colliding with Target, LOS is true
		if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider() == Target:
			#print("LOS true, Target =" + str(Target.name))
			return true
	return false

func SetActiveTarget():
	# Check for player in detection & line of sight, set active target
	if !PlayerTarget and Player_in_range and CheckLOS(Player_in_range):
		PlayerTarget = Player_in_range
		print("Player target set " + str(PlayerTarget))
	#Line of sight lost, but player in range
	elif PlayerTarget and Player_in_range and !CheckLOS(Player_in_range):
		print("Player LOS lost " + str(PlayerTarget))
		PlayerTarget = null
	# Player went out of vision range
	elif PlayerTarget and !Player_in_range:
		print("Player target out of range " + str(PlayerTarget))
		PlayerTarget = null

func _on_player_detection_body_entered(body):
	#print("Player found! Player = " + str(body))
	Player_in_range = body

func _on_player_detection_body_exited(_body):
	#print("Player lost Player = " + str(_body))
	Player_in_range = null
