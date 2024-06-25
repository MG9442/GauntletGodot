extends State

# Enemy Pursue Script

# Responsible for:
# Chasing, attacking targets
# NavAgent guiding to target
# NavTimer for updating Taget position

# Dependencies:
# Enemy script

@export var enemy: CharacterBody2D

# Navigation Elements
@export var navigation_agent_2d : NavigationAgent2D
@export var Nav_timer : Timer
@export var PursueDistance : int = 20 # Distance from target to stop at
@export var TargetObject: Node2D # Used to track a player or object
var TargetPosition: Vector2 # Used to navigate to a static location

# StateMachine Elements
@onready var idle_timer = $StateMachine/IdleTimer

func Physics_Update(_delta):
	# Examine distance that enemy is away from Target
	if Target_Reached(TargetPosition) and TargetObject:
		enemy.debug_state.text = "TargetObject reached"
		enemy.animation_player.play("Idle")
		navigation_agent_2d.debug_enabled = false
		print("TargetReached case")
		return
	elif !TargetObject and Target_Reached(TargetPosition) and idle_timer.is_stopped():
		enemy.debug_state.text = "Static target reached"
		enemy.animation_player.play("Idle")
		TargetPosition = Vector2.ZERO
		navigation_agent_2d.debug_enabled = false
		idle_timer.start(3)
		print("No Target, Idle case")
		return
	if enemy.DebugLabelVisible:
		navigation_agent_2d.debug_enabled = true
	enemy.debug_state.text = "Pursuing Target"
	#print("Slimedirection = " + str(direction.x))
	#print("SlimeVariedSpeed = " + str(VariedSpeed))
	if !TargetObject and !TargetPosition: # No target set
		print("No Target & No Target Position case")
		return
	
	var direction = navigation_agent_2d.get_next_path_position() - enemy.global_position
	direction = direction.normalized()
	
	# Flip Sprite based on direction normal (negative = left, positive = right)
	if direction.x < 0:
		enemy.animated_sprite_2d.flip_h = true
	else:
		enemy.animated_sprite_2d.flip_h = false
	enemy.velocity = enemy.velocity.lerp(direction * enemy.VariedSpeed, enemy.acceleration * _delta)
	enemy.animation_player.play("SlideMove")
	enemy.move_and_slide()
	
	# Determine if Target position has been reached
func Target_Reached(TargetExamine : Vector2) -> bool:
	# Examine distance that enemy is away from Target
	var distance =  TargetExamine - enemy.global_position
	#print("SlimeDistance.length() = " + str(distance.length()))
	if distance.length() <= PursueDistance: 
		#print("GreenSlime(): Target reached!")
		return true
	else:
		return false

# Used for setting a moving object like a player
func SwapTargets(NewTarget : Node2D):
	if !NewTarget: # guard against value not being ready or set yet
		print("SwapTargets(): Error, invalid setting of Targets!")
		return
	TargetObject = NewTarget
	var MovePosition = closest_nav_position(NewTarget.global_position)
	navigation_agent_2d.target_position = MovePosition
	Nav_timer.start() # Used since target could be actively moving

# Return position that falls within navmesh
func closest_nav_position(target_position : Vector2) -> Vector2:
	var map := enemy.get_world_2d().navigation_map
	var closest_point := NavigationServer2D.map_get_closest_point(map, target_position)
	print("SwapTargets(): closestPoint on Navmap = " + str(closest_point))
	return closest_point

# Used to periodically update position of a moving taget
func _on_nav_timer_timeout():
	if TargetObject:
		navigation_agent_2d.target_position = TargetObject.global_position
		# Update last known position in case target is lost
		TargetPosition = TargetObject.global_position
	else:
		Nav_timer.stop()

func _on_idle_timer_timeout():
	print("Idle Timer expired!")
