extends Node

@onready var knight_player_2d = $"../KnightPlayer2D"
@onready var player_camera = $"../KnightPlayer2D/PlayerCamera"
@onready var DebugMenu = $"../DebugModeUI"

var DebugMode : bool = false
var freeze_time : bool = false
var selected_object : Node # Mouse click on selected object during DebugMode
var selected_object_array: Array # Array of selected objects
@export var CameraSpeed: float = 200
@export var CameraAccel: float = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	knight_player_2d.PlayerMovement(!DebugMode)
	EnterDebugMode(DebugMode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("DebugMode"):
		DebugMode = !DebugMode
		#print("Debug Camera Mode = " + str(DebugMode))
		knight_player_2d.PlayerMovement(!DebugMode)
		player_camera.ObjectMovement(DebugMode)
		EnterDebugMode(DebugMode)
	if selected_object:
		var direction: Vector2 = Input.get_vector("ArrowLeft", "ArrowRight", "ArrowUp", "ArrowDown")
		var speed = direction * _delta * 200
		if direction != Vector2.ZERO: selected_object.find_child("DebugNode").move_owner(speed)

func EnterDebugMode(enable : bool):
	if enable: DebugMenu.visible = true
	else: DebugMenu.visible = false

func _on_freeze_time_toggled(toggled_on):
	#print("Freeze_time = " + str(toggled_on))
	get_tree().paused = toggled_on

func selected_object_switch(new_object : Node):
	if selected_object:
		selected_object.find_child("DebugNode").show_active(false) # Hide previous selection
	new_object.find_child("DebugNode").show_active(true)
	selected_object = new_object
	print("GameManager(): Selected Object = " + str(selected_object))
