extends Node

@onready var label = $Label

@export var Override_name : String

func _ready():
	if Override_name != "":
		UpdateTargetName(Override_name)
	else:
		UpdateTargetName(self.name)

func UpdateTargetName(new_name: String):
	label.text = new_name
