class_name Level

extends Node

var level_id:String
var squares:Array
var target_pos:Vector2 : set = set_target_pos
var dirty:bool


func _init(new_level_id:String,new_squares:Array, new_target_pos:Vector2):
	level_id = new_level_id
	squares = new_squares
	for square_row:Array in squares:
		for square:Square in square_row:
			square.square_changed.connect(_on_square_chaged)
	target_pos = new_target_pos
	dirty = false
	
	
	
func set_target_pos(new_target_pos:Vector2):
	if target_pos != new_target_pos:
		target_pos = new_target_pos
		dirty = true

func print():
	print(level_id)
	for line in get_squares_text():
		print(line)
	
func get_squares_text():
	var level_text = []
	for square_row in squares:
		var text = ""
		for square in square_row:
			text+=square.get_square_text()
		level_text.append(text)
	return level_text

func _on_square_chaged(square):
	dirty = true

