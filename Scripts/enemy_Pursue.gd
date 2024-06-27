extends State

# Enemy Pursue Script

# Responsible for:
# Chasing, attacking targets
# NavAgent guiding to target
# NavTimer for updating Taget position

# Dependencies:
# Enemy script

@export var enemy : GreenSlimeEnemy

# Navigation Elements
@export var navigation_agent_2d : NavigationAgent2D
@export var Nav_timer : Timer
@export var PursueDistance : int = 50 # Distance from target to stop at
@export var VisionDistance : int = 500 # Distance that enemy is able to see to
var LastSeenTarget
var TargetPosition: Vector2 # Used to navigate to a static location

func Physics_Update(_delta):
	if enemy.PlayerTarget and Nav_timer.is_stopped():
		var MovePosition = closest_nav_position(enemy.PlayerTarget.global_position)
		navigation_agent_2d.target_position = MovePosition
		Nav_timer.start() # Used since target could be actively moving
	
	# Update the target to move towards
	enemy.movement_target = navigation_agent_2d.get_next_path_position()
	
	# Examine if target has been reached
	if enemy.PlayerTarget and enemy.Target_in_Range(TargetPosition, PursueDistance):
		enemy.debug_state.text = "TargetObject reached"
		enemy.animation_player.play("Idle")
		enemy.movement_disabled = true
		navigation_agent_2d.debug_enabled = false
		#print("TargetReached case")
		return
	elif !enemy.PlayerTarget and enemy.Target_in_Range(TargetPosition, PursueDistance):
		enemy.debug_state.text = "Static target reached"
		enemy.animation_player.play("Idle")
		enemy.movement_disabled = true
		TargetPosition = Vector2.ZERO
		navigation_agent_2d.debug_enabled = false
		#idle_timer.start(3)
		#Transitioned.emit(self, "EnemyWanderState") # Transition to Idle state
		print("No Target, Idle case starting")
		return
	if enemy.DebugLabelVisible:
		navigation_agent_2d.debug_enabled = true
		if enemy.PlayerTarget: enemy.debug_state.text = "Pursuing Target LOS = true"
		else: enemy.debug_state.text = "Pursuing Target LOS = false"
	
	enemy.movement_disabled = false
	#print("Slimedirection = " + str(direction.x))
	#print("SlimeVariedSpeed = " + str(VariedSpeed))
	

# Return position that falls within navmesh
func closest_nav_position(target_position : Vector2) -> Vector2:
	var map := enemy.get_world_2d().navigation_map
	var closest_point := NavigationServer2D.map_get_closest_point(map, target_position)
	print("SwapTargets(): closestPoint on Navmap = " + str(closest_point))
	return closest_point

# Used to periodically update position of a moving taget
func _on_nav_timer_timeout():
	if enemy.PlayerTarget:
		navigation_agent_2d.target_position = enemy.PlayerTarget.global_position
		# Update last known position in case target is lost
		TargetPosition = enemy.PlayerTarget.global_position
	else:
		Nav_timer.stop()

func _on_idle_timer_timeout():
	print("Idle Timer expired!")
