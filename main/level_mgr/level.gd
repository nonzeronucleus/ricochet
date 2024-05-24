class_name Level

extends Node

var level_name:String
var squares:Array
var target_pos:Vector2 : set = set_target_pos
var start_pos: Vector2 :
	set(new_pos):
		start_pos = new_pos
		dirty = true
var dirty:bool
var npcs_pos:Array = []
var level_idx:int




func _init(new_id:int, new_level_name:String,new_squares:Array, new_target_pos:Vector2, new_start_pos:Vector2, new_npc_starts:Array = []):
	level_name = new_level_name
	level_idx = new_id
	squares = new_squares
	for square_row:Array in squares:
		for square:Square in square_row:
			square.square_changed.connect(_on_square_chaged)
	target_pos = new_target_pos
	start_pos = new_start_pos
	npcs_pos = new_npc_starts
	dirty = false
	
	
	
	
func set_target_pos(new_target_pos:Vector2):
	if target_pos != new_target_pos:
		target_pos = new_target_pos
		dirty = true

func print():
	print(level_name)
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
	

func get_size():
	if !squares:
		return Vector2()
	var height = squares.size()
	
	if height>0:
		var width = squares[0].size()
		return Vector2(width, height)
		
	return Vector2()

