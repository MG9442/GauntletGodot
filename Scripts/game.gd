extends Node2D

@onready var knight_player_2d = $KnightPlayer2D
@onready var player_camera = $KnightPlayer2D/PlayerCamera

var DebugMode = false
@export var CameraSpeed: float = 200
@export var CameraAccel: float = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	knight_player_2d.PlayerMovement(!DebugMode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("DebugCameraControl"):
		print("Entered Debug Camera Mode")
		DebugMode = !DebugMode
		knight_player_2d.PlayerMovement(!DebugMode)
		player_camera.ObjectMovement(DebugMode)
