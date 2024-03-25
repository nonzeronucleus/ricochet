@tool
class_name LineView
extends Line2D

@export var is_horizontal:bool = true:set = set_horizontal
var square_size:SquareSize = SquareSize.new(0):set = set_square_size
var pos:Vector2 = Vector2(0,0)
var default_gradient:Gradient
var selected_gradient:Gradient

var line:Line = Line.new()

func _init():
	line = Line.new()

func _on_line_changed(line):
	show_line()
	
func init_with_line(new_line:Line):
	if line:
		line.line_changed.disconnect(_on_line_changed)
	line = new_line
	line.line_changed.connect(_on_line_changed)
	show_line()
	
func show_line():
	if line.is_solid:
		width = 8
	else:
		width = 1




var is_solid:bool:
	get = get_is_solid,
	set = set_is_solid

func _ready():
	default_gradient = Gradient.new()
	default_gradient.colors = [Color.WHITE, Color.WHITE]
	default_gradient.offsets = [0.5, 0.5]
	selected_gradient = Gradient.new()
	selected_gradient.colors = [Color.RED, Color.RED]
	selected_gradient.offsets = [0.5, 0.5]
	select(false)


	
func init(new_pos, new_is_horizontal, new_square_size):
	set_pos(new_pos)
	set_horizontal(new_is_horizontal)
	set_square_size(new_square_size)
	width = 1
	
func select(new_selected):
	if new_selected:
		gradient = selected_gradient
	else:
		gradient = default_gradient
		
		
func set_is_border(new_border):
	if not is_inside_tree():
		await ready
			
	line.is_border = new_border
	

func set_is_solid(new_is_solid):
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
	refresh_view()
	

func set_horizontal(new_is_horizontal:bool):
	is_horizontal = new_is_horizontal
	refresh_view()
	
func refresh_view():
	if is_horizontal:
		points = PackedVector2Array([square_size.screen_pos(pos), square_size.screen_pos(pos + Vector2(0,1))])
	else:
		points = PackedVector2Array([square_size.screen_pos(pos), square_size.screen_pos(pos + Vector2(1,0))])
	pass

