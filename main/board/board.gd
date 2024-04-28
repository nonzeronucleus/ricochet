@tool
class_name Board
extends ColorRect

@onready var SquareTemplate = preload("res://main/board/square_view/square_view.tscn")
@onready var WallTemplate = preload("res://main/board/wall_view/wall_view.tscn")
@onready var RobotTemplate = preload("res://main/board/robot/robot.tscn")

var grid_dimension = Vector2(8,8)
var target = SquareView

var square_size
var square_views:MultiArray
var squares:Array
#var level:Level:
#	set = set_level

var player_robot:Robot

var level_mgr

signal square_selected(square)
signal setup_complete()

func _init():
	visibility_changed.connect(_on_visibility_changed)


func _ready():
	var board_size = get_size()
	
	square_size = SquareSize.new(board_size.x / grid_dimension.x)
	square_views = MultiArray.new(grid_dimension)
	player_robot = RobotTemplate.instantiate()
	player_robot.set_square_size(square_size)
	add_child(player_robot)
	player_robot.set_screen_position()	
	#board.add_player_robot(robot)
	
	add_all_squares()
	queue_redraw()


func set_level(new_level):
#	level = new_level
	init_squares(new_level.squares)
	set_target_pos(new_level.target_pos)
	player_robot.set_init_pos(new_level.start_pos)
	


func init_squares(new_squares:Array):	
	for y in new_squares.size():	
		var row = new_squares[y]
		for x in row.size():
			var square_view = square_views.at(x,y)
			if square_view:
				square_view.init(row[x])
	squares = new_squares


	
func add_all_squares():
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
	
	
func add_all_lines():
	#Add all lines
	for x in grid_dimension.x:
		for y in grid_dimension.y:
			if x == 0:
				square_views.at(x,y).init(Direction.Left, Vector2(x,y), true, square_size)
				
			if y == 0:
				square_views.at(x,y).top.init(Vector2(x,y), true, square_size) 
				
			var right_line = WallTemplate.instantiate()
			right_line.init(Vector2(x+1,y), true, square_size)
			square_views.at(x,y).right = right_line
			if x<grid_dimension.x-1:
				square_views.at(x+1,y).left = right_line
			else:
				right_line.width = 4
			add_child(right_line)

			var bottom_line = WallTemplate.instantiate()
			bottom_line.init(Vector2(x,y+1), false, square_size)
			square_views.at(x,y).bottom = bottom_line
			if y<grid_dimension.y-1:
				pass
#				square_views.at(x,y+1).top = bottom_line TODO
			else:
				bottom_line.width = 4


func _on_square_selected(selected_square):
	for x in grid_dimension.x:
		for y in grid_dimension.y:
			square_views.at(x,y).set_selected(false)
		
	selected_square.set_selected(true)
	square_selected.emit(selected_square)


func set_target_pos(target_pos:Vector2):
	set_target(square_views.at(int(target_pos.x), int(target_pos.y)))

		
func set_target(new_target):
	var old_target = target
	target = new_target
	mark_square_target(target)
	if old_target:
		mark_square_target(old_target)
	
	
	
func mark_square_target(new_target_square):
	if !new_target_square:
		return
	if new_target_square == target:
		new_target_square.set_as_target(true)
	else:
		new_target_square.set_as_target(false)

				
	
func add_player_robot(new_robot):
	player_robot = new_robot
#	robot.on_finished_moving.connect(_on_robot_finished_moving)
	add_child(player_robot)
#	robot.set_init_pos(Vector2())
	
	
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
	
func _draw():
#	var size = get_size() #TDOD
	var line_color = Color.BLACK
	var width = 4.0
	draw_line(Vector2(0,0), Vector2(0,size.y), line_color, width)
	draw_line(Vector2(0,0), Vector2(size.x,0), line_color, width)
	draw_line(Vector2(0,size.y), Vector2(size.x,size.y), line_color, width)
	draw_line(Vector2(size.x,0), Vector2(size.x,size.y), line_color, width)




func _on_visibility_changed():
	pass
#	player_robot.set_screen_position()
