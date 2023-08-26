extends CharacterBody2D
@onready var player = get_parent().get_node("Player") 
@onready var state = 0
@export var speed : float = 190.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var selfposx = position.x
	var selfposy = position.y
	var playerposx = player.position.x
	var playerposy = player.position.y
	var distx = Vector2(selfposx,0).distance_to(Vector2(playerposx,0))
	var disty = Vector2(0,selfposy).distance_to(Vector2(0,playerposy))
	if Input.is_action_just_pressed("change state"):
		if state == 0:
			state = 1
			set_collision_layer_value(2,0)
			set_collision_layer_value(1,1)
			set_collision_mask_value(2,0)
			set_collision_mask_value(1,1)
			velocity.y = 0
		elif state == 1:
			state = 0
			set_collision_layer_value(1,0)
			set_collision_layer_value(2,1)
			set_collision_mask_value(1,0)
			set_collision_mask_value(2,1)
	if state == 0:
		if not is_on_floor():
			velocity.y += gravity * delta
		if disty > 500:
			global_position = player.position
		elif distx > 50:
			var dir = (player.position.x - self.position.x)/abs(player.position.x - self.position.x)
			global_position.x += speed * dir * delta
	
	move_and_slide()
