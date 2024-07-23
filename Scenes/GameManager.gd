extends Node

@onready var knight_player_2d = $"../KnightPlayer2D"
@onready var player_camera = $"../KnightPlayer2D/PlayerCamera"
@onready var DebugMenu = $"../DebugModeUI"

var DebugMode : bool = false
var freeze_time : bool = false
var selectable_object : Node # Mouse hovering over selectable object during DebugMode
var selected_object_array: Array # Array of selected objects
@export var CameraSpeed: float = 200
@export var CameraAccel: float = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	knight_player_2d.PlayerMovement(!DebugMode)
	EnterDebugMode(DebugMode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("DebugCameraControl"):
		DebugMode = !DebugMode
		#print("Debug Camera Mode = " + str(DebugMode))
		knight_player_2d.PlayerMovement(!DebugMode)
		player_camera.ObjectMovement(DebugMode)
		EnterDebugMode(DebugMode)
	if selectable_object:
		print("Object selectable = " + str(selectable_object))

func EnterDebugMode(enable : bool):
	if enable: DebugMenu.visible = true
	else: DebugMenu.visible = false

func _on_freeze_time_toggled(toggled_on):
	#print("Freeze_time = " + str(toggled_on))
	get_tree().paused = toggled_on
