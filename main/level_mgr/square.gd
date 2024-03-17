class_name Square
extends Node

#var left:Line:set = set_left
#var top:Line:set = set_top
#var right:Line:set = set_right
#var bottom:Line:set = set_bottom

#Top and Left come from other squares
#If on the edge, they come from the other side of the board
var left: Line
var top: Line
#Right and Bottom are owned by this square
var right:Line = Line.new()
var bottom:Line = Line.new()


signal square_changed(square)


#func set_left(new_left:Line):
#	left = new_left
#	square_changed.emit(self)


#func set_top(new_top:Line):
#	top = new_top
#	square_changed.emit(self)
	

func set_right(new_right:Line):
	right = new_right
	square_changed.emit(self)


func set_bottom(new_bottom:Line):
	bottom = new_bottom
	square_changed.emit(self)
