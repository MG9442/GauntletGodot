extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("Idle")
	animation_player.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
