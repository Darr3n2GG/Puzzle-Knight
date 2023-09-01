extends Node2D
@onready var door = $Shape2D2
@onready var text =  get_parent().get_node("UI/Control/Label") 

func _on_area_body_entered(_body):
	door.color = Color(255,255,255)
	text.visible = true

