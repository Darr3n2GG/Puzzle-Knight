extends Node2D
@onready var anim = $AnimationPlayer



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_area_body_entered(_body):
	anim.play("Move")
	var tri = Puzzle.new()
	tri.pp = true
	_body.triggered(tri.pp) #How do I connect this line to Open_door.gd? Signal?
	

func _on_area_body_exited(_body):
	anim.play_backwards("Move")
