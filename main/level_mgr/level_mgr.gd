class_name LevelMgr
extends Node

var current_level: Level

var dir

var level_dirname:String = "user://levels"

signal level_changed(current_level)

var default_edge_rows = [
	"|.......",
	".|_J....",
	"........",
	"...._...",
	"....|...",
	".|......",
	"........",
	"|...|..."]


func _init():
	dir = DirAccess.open(level_dirname)
	if !dir:
		dir = DirAccess.open("user://")
		dir.make_dir("levels")
		dir = DirAccess.open(level_dirname)
	current_level = load_level(1)		


#func set_current_level(new_level:int):
#	current_level = new_level
#	level_changed.emit(current_level)
	
	
func get_level_filename(level_id:int) -> String:
	return level_dirname+"//level"+str(level_id)+".dat"

func load_level(level_id:int) -> Level:
	var edges
	var target_pos 
	var file = FileAccess.open(get_level_filename(level_id), FileAccess.READ)
	if file:
		edges = file.get_var()
		if edges == null or typeof(edges) != typeof(Array()):
			edges = default_edge_rows
		target_pos = file.get_var()
		if target_pos == null  or typeof(edges) != typeof(Vector2()):
			target_pos = Vector2(edges[0].length()-1,edges.size()-1)
		file.close()
	else:
		edges = default_edge_rows
		target_pos = Vector2(edges[0].length()-1,edges.size()-1)
	
	
	var square_array = Array()
	var prev_row:Array
	for y in edges.size():		
		var square_line = Array()
		var edge_line = edges[y]
		var square_row:Array = parse_edge_layout(edge_line)
		square_array.append(square_row)
		if prev_row:
			populate_top_edge(prev_row, square_row)
		prev_row = square_row
		
	populate_top_edge(prev_row, square_array[0])

	return Level.new(level_id, square_array, target_pos)


func populate_top_edge(prev_row, square_row):
	for x in square_row.size():
		var prev_square = prev_row[x]
		var current_square = square_row[x]
		current_square.top = prev_square.bottom

func parse_edge_layout(edge_row) -> Array:
	var square_row = Array()
	var prev_square:Square	
	for edge in edge_row:
		var square = Square.new()
		
		square.right.is_solid = (edge == 'J' or edge == '|')
		square.bottom.is_solid = (edge == 'J' or edge =='_')
		square_row.append(square)
		if prev_square:
			square.left = prev_square.right
		prev_square = square
	square_row[0].left = prev_square.right 
	return square_row


func save(level:Level):
	var level_text = []
	for square_row in level.squares:
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
	var file = FileAccess.open(get_level_filename(level.level_id), FileAccess.WRITE)
	file.store_var(level_text)
	file.store_var(level.target_pos)
	file.close()


func get_edge_text():
	var text = ""
#	for y in grid_dimension.y:
#		text+="\t\""
#		for x in grid_dimension.x:
#			var square = squares.at(x,y)
#			if square.right.is_solid == true:
#				if square.bottom.is_solid == true:
#					text += "J"
#				else:
#					text += "|"
#			elif square.bottom.is_solid == true:
#				text += "_"
#			else:
#				text += "."
#		if y<grid_dimension.y-1:
#			text+="\",\n"
#		else:
#			text+="\"]\n"
#	print (text)
#	print("\n**************\n")

