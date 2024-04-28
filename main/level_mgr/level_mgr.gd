class_name LevelMgr
extends Node

var current_level: Level : 
	set = set_current_level

var level_dirname:String = "user://levels"
var level_prefix = "Level-"
var level_suffix = ".eiffel65"
var version_prefix = "Version:"
var level_names:Array
var max_level:int = 0

signal level_changed(current_level)
signal level_added()


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
	var dir = DirAccess.open(level_dirname)
	if !dir:
#		dir = DirAccess.open("user://")
		dir = DirAccess.open("levels")
		dir.make_dir("levels")
		dir = DirAccess.open(level_dirname)
#	for level_name in dir.get_files():
#		if level_name.left(level_prefix.length())==level_prefix && level_name.right(level_suffix.length())==level_suffix:
#			var id_text = level_name.trim_prefix(level_prefix).trim_suffix(level_suffix)
#			var id = int(id_text)
#			max_level = max(max_level, id) 
#			level_names.append(level_name.trim_suffix(level_suffix))
	
	print(level_names)
	
	level_added.emit()
	current_level = load_level(create_level_name(1))

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

	return Level.new(create_level_name(max_level), square_array, dimensions-Vector2(1,1), Vector2(0,0))
	
	
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
	
func get_level_filename(level_id:String) -> String:
	return level_dirname+"//"+level_id+level_suffix


func select_level(level_id):
	current_level = load_level(level_id)
	

#func load_next_level():
#	var level_idx = level_names.find(current_level)
	
	

func load_level_by_idx(idx:int) -> Level:
	return load_level(level_names[idx])


func load_level(level_id:String) -> Level:
	var file = FileAccess.open(get_level_filename(level_id), FileAccess.READ)
	var level
	if file:
		var version_text = file.get_var()
		if version_text is String:
			var version = int(version_text.trim_prefix(version_prefix))
			match version:
				2:
					level = load_v2(file, level_id)
				3:
					level = load_v3(file, level_id)
	if !level:
		# Couldn't load. Get a default
		var edges = default_edge_rows
		var target_pos = Vector2(edges[0].length()-1,edges.size()-1)
		level = populate_level(level_id, edges, target_pos, Vector2(0,0))
	set_current_level(level)
	return level 


func load_v2(file:FileAccess, level_id:String) -> Level:
	var edges = file.get_var()
	if edges == null or typeof(edges) != typeof(Array()):
		return null
	var target_pos = file.get_var()
	if target_pos == null  or typeof(edges) != typeof(Vector2()):
		target_pos = Vector2(edges[0].length()-1,edges.size()-1)
	file.close()
	return populate_level(level_id, edges, target_pos, Vector2(0,0))
	
	
func load_v3(file:FileAccess, level_id:String) -> Level:
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
	return populate_level(level_id, edges, target_pos,start_pos)



func populate_level(level_id, edges:Array, target_pos:Vector2, start_pos) -> Level:
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

	return Level.new(level_id, square_array, target_pos, start_pos)	


func populate_top_edge(prev_row, square_row):
	for x in square_row.size():
		var prev_square = prev_row[x]
		var current_square = square_row[x]
		current_square.top = prev_square.bottom

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
func save(level_id,squares,target_pos, start_pos):
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
	#save_v2(level_id, level_text, target_pos) #TODO
	save_v3(level_id, level_text, target_pos, start_pos) #TODO


func backup_version(filename:String):
	var dir = DirAccess.open(level_dirname)
	
	if dir.file_exists(filename):
		var backup_name = filename + "." + Time.get_datetime_string_from_system()
		var err = dir.copy(filename, backup_name)
		print(err)
		
	
func save_v2(level_id: String, level_text:Array, target_pos:Vector2):
	var filename = get_level_filename(level_id)
	
	backup_version(filename)
	
	var file = FileAccess.open(filename, FileAccess.WRITE)
	file.store_var(version_prefix + "2")
	file.store_var(level_text)
	file.store_var(target_pos)
	file.close()
	
func save_v3(level_id: String, level_text:Array, target_pos:Vector2, start_pos:Vector2):
	var filename = get_level_filename(level_id)
	
	var file = FileAccess.open(get_level_filename(level_id), FileAccess.WRITE)
	file.store_var(version_prefix + "3")
	file.store_var(level_text)
	file.store_var(target_pos)
	file.store_var(start_pos)
	file.close()
	

func set_current_level(new_level:Level):
	current_level = new_level
	level_changed.emit(current_level)

func new_level():
	var new_level = create_level(Vector2(8,8))
	save(new_level.level_id, new_level.squares, new_level.target_pos, new_level.start_pos)
	
#	save(new_level)
	set_current_level(new_level)
