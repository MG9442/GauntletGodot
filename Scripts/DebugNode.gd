extends Area2D

@onready var GameManager # Used to handle debug events
@onready var marker = $Marker

func _ready():
	# Add GameManager from group
	GameManager = get_tree().get_first_node_in_group("GameManager")

func _on_input_event(viewport, event, shape_idx):
	if GameManager.DebugMode and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Object selected in DebugMode = " + str(owner))
		GameManager.selected_object_switch(owner)

func show_active(enable : bool):
	marker.visible = enable
	#print("DebugNode(): show_active = " + str(enable))

func examine_properties() -> Array:
	var properties : Array
	#print("DebugNode(): owner.name = " + str(owner.name))
	properties.append("Name")
	properties.append(owner.name)
	#print("DebugNode(): owner.global_position = " + str(owner.global_position))
	properties.append("Transform")
	properties.append(owner.global_position)
	#print("DebugNode(): owner.scale = " + str(owner.scale))
	properties.append("Scale")
	properties.append(owner.scale)
	if owner.has_method("RecieveDmg"):
		#print("DebugNode(): owner.Health = " + str(owner.Health))
		properties.append("Health")
		properties.append(owner.Health)
	#print("DebugNode(): owner.z_index = " + str(owner.z_index))
	properties.append("ZIndex")
	properties.append(owner.z_index)
	
	return properties

func move_owner(new_position : Vector2):
	owner.global_position += new_position
	#print("new_position = " + str(new_position))
	#print("owner.global_position = " + str(owner.global_position))

func delete_owner():
	owner.queue_free()
