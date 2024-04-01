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


func _ready():
	var board_size = get_size()
	
	square_size = SquareSize.new(board_size.x / grid_dimension.x)
	square_views = MultiArray.new(grid_dimension)
	add_all_squares()
#	if icon_group:
#		icon_group.selection_changed.connect(_on_icon_selection_changed)


#func _on_icon_selection_changed(selection):
	


func set_level(new_level):
	level = new_level
	init_squares(level.squares)
	set_target_pos(level.target_pos)


func init_squares(init_squares:Array):	
	for y in init_squares.size():	
		var row = init_squares[y]
		for x in row.size():
			var square_view = square_views.at(x,y)
			if square_view:
				square_view.init(row[x])
	squares = init_squares


	
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
			add_child(square_view) #TODO
	set_target(square_views.at(0,0))
	
	
func add_all_lines():
	#Add all lines
	for x in grid_dimension.x:
		for y in grid_dimension.y:
			if x == 0:
				#var left_line = LineTemplate.instantiate()
				#left_line.init(Vector2(x,y), true, square_size)
				square_views.at(x,y).init(Direction.Left, Vector2(x,y), true, square_size)
				#square_views.at(x,y).left.init(Vector2(x,y), true, square_size)# = left_line
				#add_child(left_line)
				
			if y == 0:
				#var top_line = LineTemplate.instantiate()
				#top_line.init(Vector2(x,y), false, square_size)
				square_views.at(x,y).top.init(Vector2(x,y), true, square_size) # = top_line #TODO
				#add_child(top_line)
				
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
				pass
#				square_views.at(x,y+1).top = bottom_line TODO
			else:
				bottom_line.width = 4
			#add_child(bottom_line) TODO


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
	if !new_target_square:
		return
	if new_target_square == target:
		new_target_square.set_as_target(true)
	else:
		new_target_square.set_as_target(false)

				
	
func add_robot(robot):
#	robot.on_finished_moving.connect(_on_robot_finished_moving)
	add_child(robot)
	robot.set_init_pos(Vector2())
	
	
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
	
