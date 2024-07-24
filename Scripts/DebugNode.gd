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
	print("DebugNode(): show_active = " + str(enable))

func move_owner(new_position : Vector2):
	owner.global_position += new_position
	#print("owner.global_position = " + str(owner.global_position))

func delete_owner():
	owner.queue_free()
