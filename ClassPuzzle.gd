class_name Puzzle
signal Tri(code)

var pp: int #The code of the triggered pressure plate 


func pp_triggered ():
	print ("Pressure plate ", pp, " is triggered") #Yup, this func works normally
	emit_signal("Tri", pp) #Seems like class aren't able to emit signal
