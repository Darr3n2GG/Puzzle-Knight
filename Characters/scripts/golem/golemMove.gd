extends CharacterBody2D
@onready var player = get_parent().get_node("Player")  #get player node
@onready var timer = $Timer #get timer node
@export var inState = 0 #check if golem is JUST carried
@export var throwed = 0 #check if golem is throwed
@export var throw_vel = -400.0
@export var state = 0 #golem state 

# 0 -> follow player
# 1 -> become solid
# 2 -> carry golem

@export var speed : float = 190.0
@export var TS = 2.5 #throw speed

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var selfposx = global_position.x
	var selfposy = global_position.y
	var playerposx = player.global_position.x
	var playerposy = player.global_position.y
	var distx = Vector2(selfposx,0).distance_to(Vector2(playerposx,0))
	var disty = Vector2(0,selfposy).distance_to(Vector2(0,playerposy))
	# calc distance between golem and player
	if not is_on_floor() and state != 2:
		velocity.y += gravity * delta
	if state == 0:
		if disty > 500:
			global_position = player.global_position
		elif distx > 50:
			var dir = (player.global_position.x - self.global_position.x)/abs(player.global_position.x - self.global_position.x)
			global_position.x += speed * dir * delta
	#golem will follow player if too far
	elif state == 2:
		global_position = Vector2(playerposx,playerposy - 30)
	else:
		pass
	if throwed == 1:
		var dir = 0
		if player.get_child(0).is_flipped_h() == false:
			dir = 1
		else:
			dir = -1
		if not is_on_floor():
			global_position.x += TS * dir
		else:
			throwed = 0
	move_and_slide()

func _input(_event):
	var dist = position.distance_to(player.position)
	if dist < 60:
		if Input.is_action_just_pressed("interact golem") and state == 0:
			timer.start()
		elif Input.is_action_just_released("interact golem"):
			if inState == 0:
				change_state()
			inState = 0
			timer.stop()
		elif Input.is_action_just_pressed("jump") and state == 2:
			state = 1
			velocity.y = throw_vel
			throwed = 1

func change_state():
	if state == 0:
		state = 1
		set_collision_layer_value(2,0)
		set_collision_layer_value(1,1)
		set_collision_mask_value(2,0)
		set_collision_mask_value(1,1)
	elif state == 1 or state == 2:
		state = 0
		set_collision_layer_value(1,0)
		set_collision_layer_value(2,1)
		set_collision_mask_value(1,0)
		set_collision_mask_value(2,1)

func _on_timer_timeout():
	change_state()
	state = 2
	inState = 1
	timer.stop()
	
