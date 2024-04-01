@tool
class_name SquareView
extends ColorRect

@onready var LineTemplate = preload("res://main/board/line_view/line_view.tscn")


@export var is_editor_square:bool = false
var square:Square

var left:LineView:set = set_left
var top:LineView:set = set_top
var right:LineView:set = set_right
var bottom:LineView:set = set_bottom
var square_size:SquareSize:set = set_square_size
var pos:Vector2:set = set_pos
var is_target:bool = false

var debug = false

signal square_selected(square)

func _ready():
	top = create_line(true)
	left = create_line(false)
	right = create_line(false)
	bottom = create_line(true)
	
	if !is_editor_square:
		gui_input.connect(_on_gui_input)
	
	if !square_size:
		square_size = SquareSize.new(size.x)
	
	set_as_target(false)


func create_line(is_horizontal:bool) -> LineView:
	var line = LineTemplate.instantiate()
	line.is_horizontal = is_horizontal
	add_child(line)
	return line


func init(init_square:Square):
	square = init_square
	if not is_inside_tree():
		await ready
		
	if debug:
		print(square)
	if top:
		top.init_with_line(square.top)
	if left:
		left.init_with_line(square.left)
	if right:
		right.init_with_line(square.right)
	if bottom:
		bottom.init_with_line(square.bottom)


func set_square_size(_square_size):
	square_size = _square_size
	if not is_inside_tree():
		await ready
	
	if top:
		top.set_square_size(_square_size)
	if left:
		left.set_square_size(_square_size)
	if right:
		right.set_square_size(_square_size)
	if bottom:
		bottom.set_square_size(_square_size)
	square_size.size_changed.connect(_on_size_changed)
	_on_size_changed(square_size.length)



func _on_size_changed(new_length):
	set_size(Vector2(new_length, new_length))
	if not is_inside_tree():
		await ready
	if top:
		top.set_position(Vector2(0,0))
	if left:
		left.set_position(Vector2(0,0))
	if right:
		right.set_position(Vector2(new_length,0))
	if bottom:
		bottom.set_position(Vector2(0, new_length))

func set_pos(_pos:Vector2):
	pos = _pos
	set_position(square_size.screen_pos(pos))
		

func set_left(_left):
	left = _left
	
func set_right(_right):
	right = _right
	
func set_top(_top):
	if !_top.debug:
		pass
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
			print(event)
			square_selected.emit(self)




func set_selected(_selected):
	left.select(_selected)
	right.select(_selected)
	top.select(_selected)

	bottom.select(_selected)

