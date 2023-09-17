extends Node2D
@onready var door = $Shape2D2
@onready var text = get_parent().get_node("HUD/Control/Label") 
@onready var trigger = get_node("pressure plate")

#func _on_area_pp_body_entered(_body):
#	door.color = Color(255,255,255)

func _ready():
	connect("Tri", triggered)

func triggered():
	door.color = Color(255,255,255)

func _on_area_door_body_entered(_body):
	text.visible = true

