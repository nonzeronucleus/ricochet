class_name Square
extends Node

var left: Line
var top: Line
#Right and Bottom are owned by this square
var right:Line
var bottom:Line

signal square_changed(square)


func _init(edge_defn:String):
	right = Line.new(edge_defn == 'J' or edge_defn == '|')
	bottom = Line.new(edge_defn == 'J' or edge_defn =='_')
	
	right.line_changed.connect(_on_line_changed)
	bottom.line_changed.connect(_on_line_changed)
	

func _on_line_changed(line:Line):
	square_changed.emit(self)
	
	
	
func set_right(new_right:Line):
	right = new_right
	square_changed.emit(self)


func set_bottom(new_bottom:Line):
	bottom = new_bottom
	square_changed.emit(self)
	
	
func get_square_text()->String:
	var text
	if right.is_solid == true:
		if bottom.is_solid == true:
			text = "J"
		else:
			text+= "|"
	elif bottom.is_solid == true:
		text = "_"
	else:
		text = "."	
	
	return text
