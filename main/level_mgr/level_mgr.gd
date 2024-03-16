class_name LevelMgr
extends Node

var current_level: int = 1 : set = set_current_level

signal level_changed(current_level)

func set_current_level(new_level:int):
	current_level = new_level
	level_changed.emit(current_level)
	

func load_level(level_id:int):
	var file = FileAccess.open("user://level"+str(level_id)+".dat", FileAccess.READ)
	var target_pos = file.get_var()
	var edges = file.get_var()
	file.close()
	var squares = Array()
	squares.resize(edges.size())
	for y in edges.size():
		var square_line = Array()
		var edge_line = edges[y]
#		square_line.resize(edge_line)
#		var square = Square.new()
		
		
		
	print(edges[0].length())

#func save():
#	var file = FileAccess.open("user://level1.dat", FileAccess.WRITE)
#	file.store_var(board.get_edges())
#	file.store_var(board.target.pos)
#	file.close()


func parse_edge_layout(edge_rows):
	print(edge_rows)
#	for x in grid_dimension.x:
#		for y in grid_dimension.y:
#			var edge = edge_rows[y][x]
#			var square = squares.at(x,y)
#			square.right.is_solid = (edge == 'J' or edge == '|')
#			square.bottom.is_solid = (edge == 'J' or edge =='_')	
