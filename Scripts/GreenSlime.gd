extends CharacterBody2D

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

# Debug testing
var TargetObject: Node2D # Used to track a player or object

# Called when the node enters the scene tree for the first time.
func _ready():
	if DebugLabelVisible : #Enable debug label if toggled
		debug_state.visible = true
	animation_player.play("Idle")
	debug_state.text = "Idle"

func SwapTargets(NewTarget : Node2D):
	enemy_pursue_state.SwapTargets(NewTarget)
