@tool
class_name WallView
#extends Line2D
extends Node2D

@export var is_horizontal:bool = true:set = set_horizontal
var square_size:SquareSize = SquareSize.new(0):set = set_square_size
var pos:Vector2 = Vector2(0,0) : set = set_pos

var width:int

var line:Line = null
var debug:
	set(val):
		if debug:
			print("resetting")
		debug = val


func _ready():
	width = 1
	select(false)
	



func _on_line_changed(line):
	visible = line.is_solid	
	show_line()
	
func init_with_line(new_line:Line):
	if line && line.line_changed.is_connected(_on_line_changed):
		line.line_changed.disconnect(_on_line_changed)
	line = new_line
	line.line_changed.connect(_on_line_changed)
	_on_line_changed(line)
	show_line()
	
func show_line():
	if line.is_solid:
		width = 8
	else:
		width = 1

var is_solid:bool:
	get = get_is_solid,
	set = set_is_solid


	
#func init(new_pos, new_is_horizontal, new_square_size):
#	set_pos(new_pos)
#	set_horizontal(new_is_horizontal)
#	set_square_size(new_square_size)
	
	#width = 1
	
func select(new_selected):
	pass
		
		
func set_is_border(new_border):
	if not is_inside_tree():
		await ready
			
	line.is_border = new_border
	

func set_is_solid(new_is_solid):
	is_solid = new_is_solid
	line.is_solid = new_is_solid

	if is_solid:
		width = 8
	else:
		width = 1
		
		
		
func get_is_solid():
	return line.is_solid
			
func set_pos(_pos):
	pos = _pos
	refresh_view()
	
func set_square_size(new_square_size):
	square_size = new_square_size
	square_size.size_changed.connect(on_square_size_changed)
	on_square_size_changed(square_size.length)
	

func on_square_size_changed(length):
	refresh_view()
	

func set_horizontal(new_is_horizontal:bool):
	is_horizontal = new_is_horizontal
	refresh_view()
	
func refresh_view():
	var length = square_size.length
	var texture_size = Vector2(448,64) #texture.get_size()
	var temp_scale = (length)/texture_size.x
	scale = Vector2(temp_scale,temp_scale)
	if is_horizontal:
		rotation = 0
		position.x = length/2 if pos.x == 0 else length * 1.5
		position.y = 0 if pos.y == 0 else length
	else:
		rotation = PI/2
		position.x = 0 if pos.x == 0 else length
		position.y = length/2 if pos.y == 0 else length * 1.5
	
	pass

