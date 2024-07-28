extends CanvasLayer

var selected_object : Node # Mouse click on selected object during DebugMode

@onready var DebugObjectProperties = $PropertiesContainer
@onready var name_property = $PropertiesContainer/NameProperty
@onready var transform_property = $PropertiesContainer/TransformProperty
@onready var scale_property = $PropertiesContainer/ScaleProperty
@onready var zindex_property = $PropertiesContainer/ZIndex
@onready var health_property = $PropertiesContainer/Health

func _process(_delta):
	if selected_object:
		var debug_node = selected_object.find_child("DebugNode")
		var direction: Vector2 = Input.get_vector("ArrowLeft", "ArrowRight", "ArrowUp", "ArrowDown")
		var speed = direction * _delta * 200
		if direction != Vector2.ZERO: debug_node.move_owner(speed)
		populate_list(debug_node.examine_properties()) # Populate list of selected object's properties
	if selected_object and Input.is_action_just_pressed("DeleteKey") and !selected_object.is_in_group("player"):
		selected_object.find_child("DebugNode").delete_owner()
		enable_properties(false)
		selected_object = null
	if selected_object and Input.is_action_just_pressed("EscapeKey"):
		unselect_object()

func unselect_object():
	if selected_object:
		enable_properties(false) # Hide properties menu
		selected_object.find_child("DebugNode").show_active(false) # Hide previous selection
		selected_object = null

func enable_properties(enable : bool):
	DebugObjectProperties.visible = enable

func hide_selection_list():
	name_property.visible = false
	transform_property.visible = false
	scale_property.visible = false
	zindex_property.visible = false
	health_property.visible = false

func selected_object_switch(new_object : Node):
	if selected_object:
		selected_object.find_child("DebugNode").show_active(false) # Hide previous selection
	var DebugNode = new_object.find_child("DebugNode")
	DebugNode.show_active(true)
	enable_properties(true)
	var properties : Array = DebugNode.examine_properties()
	populate_list(properties) # Populate list of selected object's properties
	selected_object = new_object
	#print("GameManager(): Selected Object = " + str(selected_object))

func populate_list(properties : Array):
	hide_selection_list() # Hide all elements starting out
	for i in properties.size():
		if i%2 != 0: continue # Skip every other value, do for loop in pairs
		#print("DebugModeUI-> populate_list: " + str(properties[i]) + " = " + str(properties[i+1]))
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
