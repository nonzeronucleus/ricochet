@tool
class_name SquareView
extends ColorRect

var square:Square

var left:LineView:set = set_left
var top:LineView:set = set_top
var right:LineView:set = set_right
var bottom:LineView:set = set_bottom
var square_size:SquareSize:set = set_square_size
var pos:Vector2:set = set_pos
var is_target:bool = false

signal square_selected(square)

func init(init_square:Square):
	square = init_square
	left.init_with_line(square.left)
	top.init_with_line(square.top)
	right.init_with_line(square.right)
	bottom.init_with_line(square.bottom)
	

func _ready():
	set_as_target(false)
	
func set_square_size(_square_size):
	square_size = _square_size
	set_size(Vector2(square_size.length, square_size.length))

func set_pos(_pos:Vector2):
	pos = _pos
	set_position(square_size.screen_pos(pos))
		
func set_selected(_selected):
	left.select(_selected)
	right.select(_selected)
	top.select(_selected)
	bottom.select(_selected)
	

func set_left(_left):
	left = _left
	
func set_right(_right):
	right = _right
	
func set_top(_top):
	top = _top
	
func set_bottom(_bottom):
	bottom = _bottom
	
func set_as_target(_is_target):
	is_target = _is_target
	if is_target:
		color = Color.RED
	else:
		color = Color.BLUE

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			square_selected.emit(self)

