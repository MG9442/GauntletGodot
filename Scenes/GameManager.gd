extends Node

@onready var knight_player_2d = $"../KnightPlayer2D"
@onready var player_camera = $"../KnightPlayer2D/PlayerCamera"
@onready var DebugMenu = $"../DebugModeUI"
@onready var DebugObjectProperties = $"../DebugModeUI/PropertiesContainer"
@onready var name_property = $"../DebugModeUI/PropertiesContainer/NameProperty"
@onready var transform_property = $"../DebugModeUI/PropertiesContainer/TransformProperty"
@onready var scale_property = $"../DebugModeUI/PropertiesContainer/ScaleProperty"
@onready var zindex_property = $"../DebugModeUI/PropertiesContainer/ZIndex"
@onready var health_property = $"../DebugModeUI/PropertiesContainer/Health"

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
		populate_list(selected_object.find_child("DebugNode").examine_properties()) # Populate list of selected object's properties
	if selected_object and Input.is_action_just_pressed("DeleteKey") and !selected_object.is_in_group("player"):
		selected_object.find_child("DebugNode").delete_owner()
		selected_object = null

func EnterDebugMode(enable : bool):
	if enable: 
		DebugMenu.visible = true
		DebugObjectProperties.visible = false
		return
		
	# Disable Debug mode
	DebugMenu.visible = false
	if selected_object: 
		selected_object.find_child("DebugNode").show_active(false) # Hide previous selection
		selected_object = null
		DebugObjectProperties.visible = false
	get_tree().paused = false

func hide_selection_list():
	name_property.visible = false
	transform_property.visible = false
	scale_property.visible = false
	zindex_property.visible = false
	health_property.visible = false

func _on_freeze_time_toggled(toggled_on):
	#print("Freeze_time = " + str(toggled_on))
	get_tree().paused = toggled_on

func selected_object_switch(new_object : Node):
	if selected_object:
		selected_object.find_child("DebugNode").show_active(false) # Hide previous selection
	var DebugNode = new_object.find_child("DebugNode")
	DebugNode.show_active(true)
	DebugObjectProperties.visible = true
	var properties : Array = DebugNode.examine_properties()
	populate_list(properties) # Populate list of selected object's properties
	selected_object = new_object
	#print("GameManager(): Selected Object = " + str(selected_object))

func populate_list(properties : Array):
	hide_selection_list() # Hide all elements starting out
	for i in properties.size():
		#print("Populate_list: Properties = " + str(properties[i]))
		if i%2 != 0: continue # Skip every other value, do for loop in pairs
		match properties[i]:
			"Name":
				name_property.find_child("Label1").text = properties[i+1]
				name_property.visible = true
				continue
			"Transform":
				var transform : Vector2 = properties[i + 1]
				transform_property.find_child("SpinBox1").value = transform.x
				transform_property.find_child("SpinBox2").value = transform.y
				transform_property.visible = true
			"Scale":
				var scale : Vector2 = properties[i + 1]
				scale_property.find_child("SpinBox1").value = scale.x
				scale_property.find_child("SpinBox2").value = scale.y
				scale_property.visible = true
			"ZIndex":
				zindex_property.find_child("SpinBox1").value = properties[i+1]
				zindex_property.visible = true
			"Health":
				health_property.find_child("SpinBox1").value = properties[i+1]
				health_property.visible = true
			_:
				print("populate_list(): Error, property not found! " + str(properties[i]))
	pass
