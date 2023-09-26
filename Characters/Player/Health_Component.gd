extends Node2D
class_name health_component

@export var max_health := 10.0
var health : float

func _ready():
	health = max_health

func damage(attack : Attack):
	health -= attack.attack_damage
	print(health)

	if health <= 0:
		get_parent().get_parent().queue_free()
