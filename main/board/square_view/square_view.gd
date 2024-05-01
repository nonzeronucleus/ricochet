@tool
class_name SquareView
extends ColorRect

@onready var WallTemplate = preload("res://main/board/wall_view/wall_view.tscn")


@export var is_editor_square:bool = false
var square:Square

var left:WallView:set = set_left
var top:WallView:set = set_top
var right:WallView:set = set_right
var bottom:WallView:set = set_bottom
var square_size:SquareSize:set = set_square_size
var pos:Vector2:set = set_pos
var is_target:bool = false
@export var normal_color:Color
var border_lines = []

var debug = false

signal square_selected(square)

func _ready():
	top = create_line(true)
	left = create_line(false)
	right = create_line(false)
	bottom = create_line(true)
	for _i in range(3):
		var border = Line2D.new()
		border_lines.append(border)
		add_child(border)
	
	if !is_editor_square:
		gui_input.connect(_on_gui_input)
	
	if !square_size:
		square_size = SquareSize.new(size.x)
	
	if top:
		top.set_pos(Vector2(0,0))
	if left:
		left.set_pos(Vector2(0,0))
	if right:
		right.set_pos(Vector2(1,0))		
	if bottom:
		bottom.set_pos(Vector2(0,1))
	
	set_as_target(false)
	
	queue_redraw()


func create_line(is_horizontal:bool) -> WallView:
	var line = WallTemplate.instantiate()
	line.is_horizontal = is_horizontal
	add_child(line)
	line.z_index = 2
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
	queue_redraw()
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
	queue_redraw()

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
		color = normal_color


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			square_selected.emit(self)


func set_selected(_selected):
	left.select(_selected)
	right.select(_selected)
	top.select(_selected)

	bottom.select(_selected)
	

func _draw():
	var size = get_size()
	draw_line(Vector2(0,0), Vector2(0,size.y), Color.BLACK)
	draw_line(Vector2(0,0), Vector2(size.x,0), Color.BLACK)
	draw_line(Vector2(0,size.y), Vector2(size.x,size.y), Color.BLACK)
	draw_line(Vector2(size.x,0), Vector2(size.x,size.y), Color.BLACK)

