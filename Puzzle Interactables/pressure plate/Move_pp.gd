extends Node2D
@onready var anim = $AnimationPlayer



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_area_body_entered(_body):
	anim.play("Move")
#	var tri = Puzzle.new()
	
	

func _on_area_body_exited(_body):
	anim.play_backwards("Move")
