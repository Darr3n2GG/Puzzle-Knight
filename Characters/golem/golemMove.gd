extends CharacterBody2D

@onready var player = get_node("../Player")  #get player node
@onready var timer = $Timer #get timer node
enum {
	FOLLOW,
	SOLID,
	CARRY,
	THROW
	}
@export var state = FOLLOW
const JUMP_VEL : float = -300.0
const SPEED : float = 200.0
var throw_dir : int
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dist : float

func _physics_process(delta):
	var playerpos = player.global_position
	var selfpos = global_position
	var distx = abs(selfpos.x - playerpos.x)
	var disty = abs(selfpos.y - playerpos.y)
	var dyn_dir = (playerpos.x-selfpos.x)/abs(playerpos.x-selfpos.x)
		
	if not is_on_floor() and state != CARRY:
		velocity.y += gravity * delta
		
	if disty > 500:
		global_position = player.global_position
		
	match state:
		FOLLOW:
			if distx > 50:
				global_position.x += SPEED * dyn_dir * delta
		CARRY:
			global_position = Vector2(playerpos.x,playerpos.y - 30)
			if Input.is_action_just_pressed("jump") and state == CARRY:
				change_state(THROW)
		THROW:
			if throw_dir == 0:
				throw_dir = -1 if player.get_child(0).is_flipped_h() else 1
			global_position.x += SPEED * 1.25 * throw_dir * delta
			if is_on_floor():
				throw_dir = 0
				change_state(SOLID)
		SOLID:
			pass
	move_and_slide()

func _input(_event):
	dist = position.distance_to(player.position)
	if dist < 200:
		if Input.is_action_just_pressed("interact golem") and state != CARRY:
			timer.start()
		elif Input.is_action_just_released("interact golem"):
			if state != CARRY and state != THROW:
				change_state(SOLID if state == FOLLOW else FOLLOW)
			elif state == CARRY and timer.time_left == 0:
				change_state(FOLLOW)
			timer.stop()

func change_state(stated):
	state = stated
	set_collision_layer_value(2 if stated != FOLLOW else 1,0)
	set_collision_layer_value(1 if stated != FOLLOW else 2,1)
	set_collision_mask_value(2 if stated != FOLLOW else 1,0)
	set_collision_mask_value(1 if stated != FOLLOW else 2,1)
	if stated == THROW:
		velocity.y = JUMP_VEL

func _on_timer_timeout():
	if dist < 50 and global_position.y - 5 <= player.position.y and player.get_node("GolemArea").has_overlapping_bodies() == false:
		change_state(CARRY)
	
