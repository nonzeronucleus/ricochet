class_name Level

extends Node

var level_id:String
var squares:Array
var target_pos:Vector2


func _init(new_level_id:String, new_squares:Array, new_target_pos:Vector2):
	level_id = new_level_id
	squares = new_squares
	target_pos = new_target_pos

func print():
	print(level_id)
	for line in get_squares_text():
		print(line)
	
func get_squares_text():
	var level_text = []
	for square_row in squares:
		var text = ""
		for square in square_row:
			if square.right.is_solid == true:
				if square.bottom.is_solid == true:
					text += "J"
				else:
					text += "|"
			elif square.bottom.is_solid == true:
				text += "_"
			else:
				text += "."	
		level_text.append(text)
	return level_text
