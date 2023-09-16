class_name Puzzle
signal PrP_Tri

var pp: int #The code of the triggered pressure plate 


func pp_triggered ():
	print ("Pressure plate ", pp, " is triggered")
	emit_signal("PrP_Tri", pp) #Signal is emited. Should be able to detect it from Open_door
