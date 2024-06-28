class_name EnemyWanderState
extends State

# Enemy Idle/Wander Script

# Responsible for:
# Idle timeout
# Randomized wandering

# Dependencies:
# Enemy script

@export var enemy: GreenSlimeEnemy
@export var animator_sprite: AnimatedSprite2D
@export var WanderDistance : int = 100 # Distance from current location to wander
@export var move_speed := 10.0
@export var idle_timer : Timer

var move_direction : Vector2
var wander_time : float
	
func _enter_state():
	if enemy.animation_player:
		enemy.animation_player.play("Idle")
	idle_timer.start()
	print("Entering Enemy Idle State")
	
func _exit_state():
	idle_timer.stop()
	print("Exiting Enemy Idle State")

func Update(_delta : float):
	pass
	#if wander_time > 0: #Decrease Wander time
		#wander_time -= _delta
	#else:
		#randomize_wander()

func Physics_Update(_delta : float):
	if enemy.PlayerTarget:
		Transitioned.emit(self, "EnemyPursueState") # Transition to Pursue state

func _on_idle_timer_timeout():
	print("Idle Timer expired!")
	randomize_wander()

# Randomize move position when Idle
func randomize_wander():
	# Randomize a local point, then convert to global
	var random_target = Vector2(randi_range(-WanderDistance, WanderDistance), 
							 randi_range(-WanderDistance, WanderDistance))
	print("random target = " + str(random_target))
	random_target = enemy.position + random_target
	print("random_target combined with local position = " + str(random_target))
	#enemy.WanderPosition(random_target)
