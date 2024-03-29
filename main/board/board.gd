@tool
class_name Board
extends ColorRect

@onready var SquareTemplate = preload("res://main/board/square_view/square_view.tscn")
@onready var LineTemplate = preload("res://main/board/line_view/line_view.tscn")

var grid_dimension = Vector2(8,8)
var target = SquareView

var square_size
var square_views:MultiArray
var squares:Array
var level:Level:
	set = set_level

var level_mgr

signal square_selected(square)
signal setup_complete()

func _init():
	pass


func set_level(new_level):
	level = new_level
	init_squares(level.squares)
	set_target_pos(level.target_pos)


func init_squares(init_squares:Array):
	for y in init_squares.size():	
		var row = init_squares[y]
		for x in row.size():
			var square_view = square_views.at(x,y)
			square_view.init(row[x])
	squares = init_squares


func _ready():
	var board_size = get_size()
	
	square_size = SquareSize.new(board_size.x / grid_dimension.x)
	square_views = MultiArray.new(grid_dimension)
	
	#Add all squares
	for x in grid_dimension.x:
		for y in grid_dimension.y:
			var square_view = SquareTemplate.instantiate()
#			square_view.init()
			square_view.square_size = square_size
			square_view.pos = Vector2(x,y)
			square_views.set_at(x,y,square_view)
			mark_square_target(square_view)
			square_view.square_selected.connect(_on_square_selected)
			add_child(square_view)
	set_target(square_views.at(0,0))
			
	#Add all lines
	for x in grid_dimension.x:
		for y in grid_dimension.y:
			if x == 0:
				var left_line = LineTemplate.instantiate()
				left_line.init(Vector2(x,y), true, square_size)
				square_views.at(x,y).left = left_line
				add_child(left_line)
				
			if y == 0:
				var top_line = LineTemplate.instantiate()
				top_line.init(Vector2(x,y), false, square_size)
				square_views.at(x,y).top = top_line
				add_child(top_line)
				
			var right_line = LineTemplate.instantiate()
			right_line.init(Vector2(x+1,y), true, square_size)
			square_views.at(x,y).right = right_line
			if x<grid_dimension.x-1:
				square_views.at(x+1,y).left = right_line
			else:
				right_line.width = 4
			add_child(right_line)

			var bottom_line = LineTemplate.instantiate()
			bottom_line.init(Vector2(x,y+1), false, square_size)
			square_views.at(x,y).bottom = bottom_line
			if y<grid_dimension.y-1:
				square_views.at(x,y+1).top = bottom_line
			else:
				bottom_line.width = 4
			add_child(bottom_line)
#	if Engine.is_editor_hint():
#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_square_selected(selected_square):
	for x in grid_dimension.x:
		for y in grid_dimension.y:
			square_views.at(x,y).set_selected(false)
		
	selected_square.set_selected(true)
	square_selected.emit(selected_square)


func set_target_pos(target_pos:Vector2):
	set_target(square_views.at(target_pos.x, target_pos.y))

		
func set_target(new_target):
	var old_target = target
	target = new_target
	mark_square_target(target)
	if old_target:
		mark_square_target(old_target)
	
	
	
func mark_square_target(new_target_square):
	if new_target_square == target:
		new_target_square.set_as_target(true)
	else:
		new_target_square.set_as_target(false)

				
	
func add_robot(robot):
	robot.on_finished_moving.connect(_on_robot_finished_moving)
	add_child(robot)
	robot.set_init_pos(Vector2())
	
	
func _on_robot_finished_moving(robot):
	if robot.pos == target.pos:
		robot.shrink()
	

func is_wall_open(pos, direction) -> bool:
	var square = square_views.at(pos.x, pos.y)
	match(direction):
		Direction.Up:
			return !square.top.is_solid
		Direction.Down:
			return !square.bottom.is_solid
		Direction.Left:
			return !square.left.is_solid
		Direction.Right:
			return !square.right.is_solid
			
	return false
	
func get_moves(init_pos, direction) -> Array:
	var moves:Array = []
	var end_pos = init_pos
	var looped_round = false
	
	while(is_wall_open(end_pos,direction) && !looped_round):
		end_pos += direction
		
		#check for whether needs to loop round
		if end_pos.x < 0:
			moves.append(Move.new(end_pos))
			moves.append(Move.new(Vector2(square_views.dimensions.x,end_pos.y),true))
			end_pos.x = square_views.dimensions.x-1
		if end_pos.y < 0:
			moves.append(Move.new(end_pos))
			moves.append(Move.new(Vector2(end_pos.x,square_views.dimensions.y),true))
			end_pos.y = square_views.dimensions.y -1
		if end_pos.x >= square_views.dimensions.x:
			moves.append(Move.new(end_pos))
			moves.append(Move.new(Vector2(-1,end_pos.y),true))
			end_pos.x = 0
		if end_pos.y >= square_views.dimensions.y:
			moves.append(Move.new(end_pos))
			moves.append(Move.new(Vector2(end_pos.x,-1), true))
			end_pos.y = 0
		#Check to see if looped all the way round
		
		if end_pos == init_pos:
			looped_round = true
		
	
	moves.append(Move.new(end_pos))
	return moves


func forward_canvas_gui_input(event):
	print(event)
