extends CharacterBody2D

@onready var player = get_node("../Player")  #get player node
@onready var timer = $Timer #get timer node
enum GolemStates {FOLLOW_STATE,SOLID_STATE,CARRY_STATE}
@export var state = GolemStates.FOLLOW_STATE
const JUMP_VEL : float = -300.0
const SPEED : float = 200.0
var carried : bool #check if golem is JUST carried
var throwed : bool #check if golem is throwed
var dir : int
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor() and state != GolemStates.CARRY_STATE:
		velocity.y += gravity * delta
	var selfpos = global_position
	var playerpos = player.global_position
	var distx = abs(selfpos.x - playerpos.x)
	var disty = abs(selfpos.y - playerpos.y)
	var dyn_dir = (playerpos.x-selfpos.x)/abs(playerpos.x-selfpos.x)
	if dir == 0:
		dir = -1 if player.get_child(0).is_flipped_h() else 1
	if disty > 500:
		global_position = player.global_position
	elif distx > 50 and state == GolemStates.FOLLOW_STATE:
		global_position.x += SPEED * dyn_dir * delta
	elif state == GolemStates.CARRY_STATE:
		global_position = Vector2(playerpos.x,playerpos.y - 30)
	if not is_on_floor() and throwed == true:
		global_position.x += SPEED * 1.25 * dir * delta
	else:	
		throwed = false
		dir = 0
	move_and_slide()

func _input(_event):
	var dist = position.distance_to(player.position)
	if dist < 200:
		if Input.is_action_just_pressed("interact golem") and state != GolemStates.CARRY_STATE:
			timer.start()
		elif Input.is_action_just_released("interact golem"):
			if carried == false:
				change_state(GolemStates.SOLID_STATE if state == GolemStates.FOLLOW_STATE else GolemStates.FOLLOW_STATE)
			elif carried == true and timer.time_left == 0:
				change_state(GolemStates.FOLLOW_STATE)
			timer.stop()
		elif Input.is_action_just_pressed("jump") and state == GolemStates.CARRY_STATE:
			change_state(GolemStates.SOLID_STATE)
			velocity.y = JUMP_VEL
			throwed = true

func change_state(stated):
	state = stated
	set_collision_layer_value(2 if stated != GolemStates.FOLLOW_STATE else 1,0)
	set_collision_layer_value(1 if stated != GolemStates.FOLLOW_STATE else 2,1)
	set_collision_mask_value(2 if stated != GolemStates.FOLLOW_STATE else 1,0)
	set_collision_mask_value(1 if stated != GolemStates.FOLLOW_STATE else 2,1)
	carried = false if stated != GolemStates.CARRY_STATE else true

func _on_timer_timeout():
	change_state(GolemStates.CARRY_STATE)
	
