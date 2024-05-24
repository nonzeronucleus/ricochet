class_name LevelMgr
extends Node
 
#var level_dirname:String = "user://levels"
var level_dirname:String = "res://main/levels"
var level_prefix = ""
var level_suffix = ".tmj"
var version_prefix = "Version:"
var level_names:Array
var max_level:int = 0

signal level_changed(current_level)
signal level_added()

var swipe_started = false
var swipe_start = Vector2()


var default_edge_rows = [
	"|.......",
	".|_J....",
	"........",
	"...._...",
	"....|...",
	".|......",
	"........",
	"|...|..."]
	
enum Pieces {PLAYER=3, NPC=4, TARGET=7}



func _init():
	var dir = DirAccess.open(level_dirname)
	if !dir:
#		dir = DirAccess.open("user://")
		dir = DirAccess.open("levels")
		dir.make_dir("levels")
		dir = DirAccess.open(level_dirname)
	
	level_added.emit()

func create_level(dimensions:Vector2) -> Level:
	var square_array = Array()
	var prev_row:Array
	for y in dimensions.y:
		var square_line = Array()
		var square_row = create_empty_row(dimensions.x, y == dimensions.y-1, y)
		square_row.resize(dimensions.x)
		square_array.append(square_row)
		if prev_row:
			populate_top_edge(prev_row, square_row)
		prev_row = square_row
		
	populate_top_edge(prev_row, square_array[0])
	
	max_level += 1

	return Level.new(max_level, create_level_name(max_level), square_array, dimensions-Vector2(1,1), Vector2(0,0))
	
	
func create_level_name(id)->String:
	return level_prefix+str(id)
	
func list_levels():
	level_names = []
	var dir = DirAccess.open(level_dirname)
	if !dir:
		dir = DirAccess.open("user://")
		dir.make_dir("levels")
		dir = DirAccess.open(level_dirname)
		
	for level_name in dir.get_files():
		if level_name.left(level_prefix.length())==level_prefix && level_name.right(level_suffix.length())==level_suffix:			
			var id_text = level_name.trim_prefix(level_prefix).trim_suffix(level_suffix)
			var id = int(id_text)
			max_level = max(max_level, id) 
			level_names.append(level_name.trim_suffix(level_suffix))
			
	return level_names
	
func get_level_filename(level_idx:String) -> String:
	return level_dirname+"/"+level_idx+level_suffix



func load_level_by_id(level_idx:int) -> Level:
	return _load_level(level_idx, level_names[level_idx])


func _load_level(level_idx:int, level_name:String) -> Level:
	var level = load_tmj(level_idx, level_name)
	level_changed.emit(level)
	return level


func load_level2(level_idx:int, level_name:String) -> Level:
	var file = FileAccess.open(get_level_filename(level_name), FileAccess.READ)
	var level
	if file:
		var version_text = file.get_var()
		if version_text is String:
			var version = int(version_text.trim_prefix(version_prefix))
			match version:
				2:
					level = load_v2(file, level_idx, level_name)
				3:
					level = load_v3(file, level_idx, level_name)
	if !level:
		# Couldn't load. Get a default
		var edges = default_edge_rows
		var target_pos = Vector2(edges[0].length()-1,edges.size()-1)
		level = populate_level(level_idx, level_name, edges, target_pos, Vector2(0,0))
#	set_current_level(level)
	level_changed.emit(level)
		
	return level 


func load_v2(file:FileAccess, level_idx:int, level_name:String) -> Level:
	var edges = file.get_var()
	if edges == null or typeof(edges) != typeof(Array()):
		return null
	var target_pos = file.get_var()
	if target_pos == null  or typeof(edges) != typeof(Vector2()):
		target_pos = Vector2(edges[0].length()-1,edges.size()-1)
	file.close()
	return populate_level(level_idx, level_name, edges, target_pos, Vector2(0,0))
	
	
func load_v3(file:FileAccess, level_idx:int, level_name:String) -> Level:
	var edges = file.get_var()
	if edges == null or typeof(edges) != typeof(Array()):
		return null
	var target_pos = file.get_var()
	if target_pos == null  or typeof(target_pos) != typeof(Vector2()):
		target_pos = Vector2(edges[0].length()-1,edges.size()-1)
	var start_pos = file.get_var()
	if start_pos == null  or typeof(start_pos) != typeof(Vector2()):
		start_pos = Vector2(0,0)
	file.close()
	return populate_level(level_idx, level_name, edges, target_pos,start_pos)



func populate_level(level_idx, level_name, edges:Array, target_pos:Vector2, start_pos) -> Level:
	var square_array = Array()
	var prev_row:Array
	for y in edges.size():		
		var square_line = Array()
		var edge_line = edges[y]
		var square_row:Array = parse_edge_layout(edge_line, y)
		square_array.append(square_row)
		if prev_row:
			populate_top_edge(prev_row, square_row)
		prev_row = square_row
		
	populate_top_edge(prev_row, square_array[0])

	return Level.new(level_idx, level_name, square_array, target_pos, start_pos)	
	
func populate_json_level(level_idx:int, level_name:String, edges:Array, target_pos:Vector2, start_pos:Vector2, npc_starts:Array) -> Level:
	var square_array = Array()
	var prev_row:Array
	for y in edges.size():		
		var square_line = Array()
		var edge_line = edges[y]
		var square_row:Array = parse_edge_layout_json(edge_line, y)
		square_array.append(square_row)
		if prev_row:
			populate_top_edge(prev_row, square_row)
		prev_row = square_row
		
	populate_top_edge(prev_row, square_array[0])
	
	return Level.new(level_idx, level_name, square_array, target_pos, start_pos, npc_starts)	


func populate_top_edge(prev_row, square_row):
	for x in square_row.size():
		var prev_square = prev_row[x]
		var current_square = square_row[x]
		current_square.top = prev_square.bottom
		
func parse_edge_layout_json(edge_row, y) -> Array:
	var square_row = Array()
	var prev_square:Square	
	for x in edge_row.size():
		var edge = edge_row[x]
		var square = Square.new(str(edge), Vector2(x,y), true)
		square_row.append(square)
		if prev_square:
			square.left = prev_square.right
		prev_square = square
	square_row[0].left = prev_square.right 
	return square_row

func parse_edge_layout(edge_row, y) -> Array:
	var square_row = Array()
	var prev_square:Square	
	for x in edge_row.length():
		var edge = edge_row[x]
		var square = Square.new(edge, Vector2(x,y))
		square_row.append(square)
		if prev_square:
			square.left = prev_square.right
		prev_square = square
	square_row[0].left = prev_square.right 
	return square_row
	

func create_empty_row(width, is_bottom, y) -> Array:
	var square_row = Array()
	var prev_square:Square	
	for x in width:
		var square = Square.new(".", Vector2(x,y))
		
		square.right.is_solid = false #(x == width - 1)
		square.bottom.is_solid = false #is_bottom
		square_row.append(square)
		if prev_square:
			square.left = prev_square.right
		prev_square = square
	square_row[0].left = prev_square.right 
	return square_row


#func save(level:Level):
func save(level_idx,squares:Array,target_pos:Vector2, player_robot:Robot, npc_robots:Array):
	var level_text = []
#	for square_row in level.squares:
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
	#save_v3(level_idx, level_text, target_pos, start_pos) #TODO
	
	var npc_pos_array = []
	for npc in npc_robots:
		npc_pos_array.append(npc.pos)
	
	save_v4(level_idx, level_text, target_pos, player_robot.pos, npc_pos_array) #TODO


func backup_version(filename:String):
	var dir = DirAccess.open(level_dirname)
	
	if dir.file_exists(filename):
		var backup_name = filename + "." + Time.get_datetime_string_from_system()
		var err = dir.copy(filename, backup_name)
		print(err)
		
	
func save_v2(level_idx: String, level_text:Array, target_pos:Vector2):
	var filename = get_level_filename(level_idx)
	
	backup_version(filename)
	
	var file = FileAccess.open(filename, FileAccess.WRITE)
	file.store_var(version_prefix + "2")
	file.store_var(level_text)
	file.store_var(target_pos)
	file.close()
	
func save_v3(level_idx: String, level_text:Array, target_pos:Vector2, start_pos:Vector2):
	var filename = get_level_filename(level_idx)
	
	var file = FileAccess.open(get_level_filename(level_idx), FileAccess.WRITE)
	file.store_var(version_prefix + "3")
	file.store_var(level_text)
	file.store_var(target_pos)
	file.store_var(start_pos)
	file.close()
	

func save_v4(level_idx: String, level_text:Array, target_pos:Vector2, start_pos:Vector2, npc_pos_array:Array):
	for pos in npc_pos_array:
		print(pos)
#	var filename = get_level_filename(level_idx)
	
#	var file = FileAccess.open(get_level_filename(level_idx), FileAccess.WRITE)
#	file.store_var(version_prefix + "4")
#	file.store_var(level_text)
#	file.store_var(target_pos)
#	file.store_var(start_pos)
#	file.close()



func new_level():
	var new_level = create_level(Vector2(8,8))
#	save(new_level.level_idx, new_level.squares, new_level.target_pos, new_level.start_pos, [])

	level_changed.emit(new_level)


func load_tmj(level_idx:int, level_name:String):
#	print(get_level_filename(level_name))
#	parser.open("res://main/levels/level-1.tmx")
	var file = FileAccess.open(get_level_filename(level_name), FileAccess.READ)
	var json_text = file.get_as_text();
	var json = JSON.new()	
	var player_start = Vector2(0,0)
	var npc_starts = []
	var target = Vector2(6,6)
	var error = json.parse(json_text)
	var edges = []
	if error == OK:
		var data = json.data
		var layers = data.layers
		if typeof(layers) == TYPE_ARRAY:
			for layer in layers:
				var name = layer.name
				if layer.name == "Walls":
					for row_id in range(layer.height):
						var start = row_id * layer.width
						var end = (row_id+1) * layer.width
						var row = layer.data.slice(start, end)
						edges.append(row)
				elif layer.name == "Pieces":
					for row_id in range(layer.height):
						var start = row_id * layer.width
						var end = (row_id+1) * layer.width
						var row = layer.data.slice(start, end)
						for col_id in range(row.size()):
							if row[col_id] == Pieces.PLAYER:
								player_start = Vector2(col_id, row_id)
							if row[col_id] == Pieces.NPC:
								var npc_start = Vector2(col_id, row_id)
								npc_starts.append(npc_start)
							if row[col_id] == Pieces.TARGET:
								target = Vector2(col_id, row_id)
		else:
			print("Failed to find layers data. Got "+layers)
#		if typeof(data_received) == TYPE_ARRAY:
#			print(data_received) # Prints array
#		else:
#			print("Unexpected data")	
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_text, " at line ", json.get_error_line())	

	return populate_json_level(level_idx, "json", edges, target, player_start, npc_starts)

