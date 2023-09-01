extends CharacterBody2D
@onready var player = get_parent().get_node("Player")  #get player node
@onready var timer = $Timer #get timer node
var carried = 0 #check if golem is JUST carried
var throwed = 0 #check if golem is throwed
var dir = 0
@export var throw_vel = -400.0
@export var state = 0 #golem state 
# 0 -> follow player
# 1 -> become solid
# 2 -> carry golem
@export var speed : float = 190.0
@export var TS = 3 #throw speed


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor() and state != 2:
		velocity.y += gravity * delta
	follow_player(delta)
	if throwed == 1:
		if dir == 0:
			if player.get_child(0).is_flipped_h() == false:
				dir = 1
			else:
				dir = -1
		if not is_on_floor():
			global_position.x += TS * dir
		else:
			throwed = 0
			dir = 0
			pass
	move_and_slide()

func _input(_event):
	var dist = position.distance_to(player.position)
	if dist < 100:
		if Input.is_action_just_pressed("interact golem") and state != 2:
			timer.start()
		elif Input.is_action_just_released("interact golem"):
			if carried == 0:
				if state == 0:
					change_state(1)
				else:
					change_state(0)
			timer.stop()
		elif Input.is_action_just_pressed("jump") and state == 2:
			change_state(1)
			velocity.y = throw_vel
			throwed = 1

func change_state(stated):
	state = stated
	if stated != 0:
		set_collision_layer_value(2,0)
		set_collision_layer_value(1,1)
		set_collision_mask_value(2,0)
		set_collision_mask_value(1,1)
	else:
		set_collision_layer_value(1,0)
		set_collision_layer_value(2,1)
		set_collision_mask_value(1,0)
		set_collision_mask_value(2,1)
	carried = 0

func follow_player(process_delta):
	var selfpos = global_position
	var playerpos = player.global_position
	var distx = Vector2(selfpos.x,0).distance_to(Vector2(playerpos.x,0))
	var disty = Vector2(0,selfpos.y).distance_to(Vector2(0,playerpos.y))
	if disty > 500:
		global_position = player.global_position
	elif distx > 50 and state == 0:
		var dirfp = (player.global_position.x - self.global_position.x)/abs(player.global_position.x - self.global_position.x)
#		var delta = get_process_delta_time()
		global_position.x += speed * dirfp * process_delta
	elif state == 2:
		global_position = Vector2(playerpos.x,playerpos.y - 30)
	else:
		pass

func _on_timer_timeout():
	change_state(2)
	carried = 1
	
