@tool
class_name LineView
extends Line2D

@export var is_horizontal:bool = true:set = set_horizontal
var square_size:SquareSize = SquareSize.new(0):set = set_square_size
var pos:Vector2 = Vector2(0,0)
var default_gradient:Gradient
var selected_gradient:Gradient
var is_border
var is_solid:bool = false:set = set_is_solid

var is_passable:bool : get = get_is_passable, set = set_is_passable 
	
func _ready():
	default_gradient = Gradient.new()
	default_gradient.colors = [Color.WHITE, Color.WHITE]
	default_gradient.offsets = [0.5, 0.5]
	selected_gradient = Gradient.new()
	selected_gradient.colors = [Color.RED, Color.RED]
	selected_gradient.offsets = [0.5, 0.5]
	select(false)


	
func init(new_pos, new_is_horizontal, new_square_size, new_is_border = false):
	set_pos(new_pos)
	set_horizontal(new_is_horizontal)
	set_square_size(new_square_size)
	is_border = new_is_border
	if is_border:
		width = 8
		
	else:
		width = 1
	
func select(new_selected):
	if new_selected || is_border:
		gradient = selected_gradient
	else:
		gradient = default_gradient
		
func set_is_solid(new_is_solid):
	is_solid = new_is_solid
	if is_border:
		return
	if is_solid:
		width = 8
	else:
		width = 1
			
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

func get_is_passable():
	return !is_border && !is_solid

func set_is_passable(new_is_passable):
	assert( true, "set_is_passable should not be called")
