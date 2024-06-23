class_name EnemyWanderState
extends State

@export var enemy: CharacterBody2D
@export var animator_sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var WanderDistance : int = 100 # Distance from current location to wander
@export var move_speed := 10.0

var move_direction : Vector2
var wander_time : float

func randomize_wander():
	# Randomize a local point, then convert to global
	var random_target = Vector2(randi_range(-WanderDistance, WanderDistance), 
							 randi_range(-WanderDistance, WanderDistance))
	print("random target = " + str(random_target))
	random_target = enemy.position + random_target
	print("random_target combined with local position = " + str(random_target))
	
	#enemy.SwapTargets(New_target)
	
	# Randomize direction normal vector, then time to wander for
	#move_direction = Vector2(randf_range(-1,1), randf_range(-1,1))
	#wander_time = randf_range(1,3)
	
func _enter_state():
	randomize_wander()

func _exit_state():
	pass

func Update(_delta : float):
	pass
	#if wander_time > 0: #Decrease Wander time
		#wander_time -= _delta
	#else:
		#randomize_wander()

func Physics_Update(_delta : float):
	if enemy:
		enemy.velocity = move_direction * move_speed
