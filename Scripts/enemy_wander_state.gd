extends State

# Enemy Idle/Wander Script

# Responsible for:
# Idle timeout
# Randomized wandering

# Dependencies:
# Enemy script
# Enemy navigation script

@export var enemy: GreenSlimeEnemy
@export var WanderDistance : int = 100 # Distance from current location to wander
@export var idle_timer : Timer


func _enter_state():
	print("Entering Enemy Idle State")
	idle_timer.start()
	#enemy.animation_player.play("Idle")
	if enemy.debug_state:
		enemy.debug_state.text = "Idle"
	
func _exit_state():
	print("Exiting Enemy Idle State")
	idle_timer.stop()

func Update(_delta : float):
	pass

func Physics_Update(_delta : float):
	if enemy.PlayerTarget:
		Transitioned.emit(self, "EnemyPursueState") # Transition to Pursue state

func _on_idle_timer_timeout():
	print("Idle Timer expired!")
