extends Node2D
class_name Puzzle
signal New(code)


var pp: int #The code of the triggered pressure plate 

func pp_triggered ():
	print ("Pressure plate ", pp, " is triggered") 
	emit_signal("New", pp) #It can't emit signal? WHY???
