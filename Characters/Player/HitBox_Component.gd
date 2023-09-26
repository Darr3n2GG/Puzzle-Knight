extends Area2D
@export var health : health_component

func damage(attack: Attack):
	if health:
		health.damage(attack)
		print(attack)




