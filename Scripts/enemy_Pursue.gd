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
@export var StaticTargetDistance : int = 1 # Distance from static target to move to
@export var VisionDistance : int = 500 # Distance that enemy is able to see to
@export var StuckTimeout : float = 4.0 # Timeout to check if enemy is stuck

var TargetPosition: Vector2 # Used to navigate to a static location
var StuckTimer : float = StuckTimeout # Timer to determine if Enemy is stuck
var PreviousPosition : Vector2 # User to track movement, determine if stuck
var PositionDifference : float # Position calculation to determine if enemy is stuck

func _enter_state():
	print("Entering Enemy Pursue State")
	
	# Reset navigation parameters
	StuckTimer = StuckTimeout
	PositionDifference = 0
	PreviousPosition = enemy.global_position

func _exit_state():
	print("Exiting Enemy Pursue State")
	enemy.movement_disabled = true
	enemy.movement_target = Vector2.ZERO
	TargetPosition = Vector2.ZERO
	navigation_agent_2d.debug_enabled = false

func Physics_Update(_delta):
	# Restart navigation timer and update nav positions
	if enemy.PlayerTarget and Nav_timer.is_stopped():
		var MovePosition = closest_nav_position(enemy.PlayerTarget.global_position)
		navigation_agent_2d.target_position = MovePosition
		# Update last known position in case target is lost
		TargetPosition = enemy.PlayerTarget.global_position
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
	# Move to last known location of player when LOS was lost
	elif !enemy.PlayerTarget and enemy.Target_in_Range(TargetPosition, StaticTargetDistance):
		enemy.debug_state.text = "Static target reached"
		Transitioned.emit(self, "EnemyWanderState") # Transition to Idle state
		print("No Target, Idle case starting")
		return
 	# Determine if enemy is stuck while navigating
	elif !enemy.PlayerTarget and Check_if_stuck(_delta):
		print("Enemy determined to be stuck! Transition to Idle")
		Transitioned.emit(self, "EnemyWanderState")  # Transition to Idle state
		return
	
	if enemy.DebugLabelVisible:
		navigation_agent_2d.debug_enabled = true
		if enemy.PlayerTarget: enemy.debug_state.text = "Pursuing Target LOS = true"
		else: enemy.debug_state.text = "Pursuing Target LOS = false"
	
	enemy.movement_disabled = false
	PreviousPosition = enemy.global_position

# Return position that falls within navmesh
func closest_nav_position(target_position : Vector2) -> Vector2:
	var map := enemy.get_world_2d().navigation_map
	var closest_point := NavigationServer2D.map_get_closest_point(map, target_position)
	print("closest_nav_position(): closestPoint on Navmap = " + str(closest_point))
	return closest_point

# Used to periodically update position of a moving taget
func _on_nav_timer_timeout():
	if enemy.PlayerTarget:
		navigation_agent_2d.target_position = enemy.PlayerTarget.global_position
		# Update last known position in case target is lost
		TargetPosition = enemy.PlayerTarget.global_position
	else:
		Nav_timer.stop()

func Check_if_stuck(_delta) -> bool:
	var PositionReference = PreviousPosition - enemy.global_position
	#print("PositionReference.length = " + str(PositionReference.length()))
	StuckTimer -= _delta
	PositionDifference += PositionReference.length()
	if StuckTimer <= 0:
		#print("PositionDifference = " + str(PositionDifference))
		if PositionDifference < 50:
			print("Enemy determined to be stuck!")
			return true
		StuckTimer = StuckTimeout # Reset timer
		PositionDifference = 0 # Reset Difference
	return false
