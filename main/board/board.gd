@tool
class_name Board
extends ColorRect

@onready var SquareTemplate = preload("res://main/board/square/square.tscn")
@onready var LineTemplate = preload("res://main/board/line/Line.tscn")

var grid_dimension = Vector2(8,8)
var target = Square

var square_size
var squares:MultiArray

signal square_selected(square)
signal setup_complete()

var edge_rows = [
	"|.......",
	".|_J....",
	"........",
	"...._...",
	"....|...",
	".|......",
	"........",
	"....|..."]

func _init():
	pass
		

func _ready():
	var board_size = get_size()
	
	square_size = SquareSize.new(board_size.x / grid_dimension.x)
	squares = MultiArray.new(grid_dimension)
	
	#Add all squares
	for x in grid_dimension.x:
		for y in grid_dimension.y:
			var square = SquareTemplate.instantiate()
			square.square_size = square_size
			square.pos = Vector2(x,y)
			squares.set_at(x,y,square)
			mark_square_target(square)
			square.square_selected.connect(_on_square_selected)
			add_child(square)
	set_target(squares.at(0,0))
			
	#Add all lines
	for x in grid_dimension.x:
		for y in grid_dimension.y:
			if x == 0:
				var left_line = LineTemplate.instantiate()
				left_line.init(Vector2(x,y), true, square_size, true)
				squares.at(x,y).left = left_line
				add_child(left_line)
				
			if y == 0:
				var top_line = LineTemplate.instantiate()
				top_line.init(Vector2(x,y), false, square_size, true)
				squares.at(x,y).top = top_line
				add_child(top_line)
				
			var right_line = LineTemplate.instantiate()
			right_line.init(Vector2(x+1,y), true, square_size, x == grid_dimension.x-1)
			squares.at(x,y).right = right_line
			if x<grid_dimension.x-1:
				squares.at(x+1,y).left = right_line
			else:
				right_line.width = 4
			add_child(right_line)

			var bottom_line = LineTemplate.instantiate()
			bottom_line.init(Vector2(x,y+1), false, square_size, y == grid_dimension.y-1)
			squares.at(x,y).bottom = bottom_line
			if y<grid_dimension.y-1:
				squares.at(x,y+1).top = bottom_line
			else:
				bottom_line.width = 4
			add_child(bottom_line)
	parse_edge_layout(edge_rows)


func parse_edge_layout(edge_rows):
	for x in grid_dimension.x:
		for y in grid_dimension.y:
			var edge = edge_rows[y][x]
			var square = squares.at(x,y)
			square.right.is_solid = (edge == 'J' or edge == '|')
			square.bottom.is_solid = (edge == 'J' or edge =='_')
			


func _on_square_selected(selected_square):
	for x in grid_dimension.x:
		for y in grid_dimension.y:
			squares.at(x,y).set_selected(false)
		
	selected_square.set_selected(true)
	square_selected.emit(selected_square)


func get_edge(x,y):
	return edge_rows[y][x]

	
func set_target_pos(target_pos:Vector2):
	set_target(squares.at(target_pos.x, target_pos.y))

		
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
	
	
func get_edge_text():
	var text = ""
	for y in grid_dimension.y:
		text+="\t\""
		for x in grid_dimension.x:
			var square = squares.at(x,y)
			if square.right.is_solid == true:
				if square.bottom.is_solid == true:
					text += "J"
				else:
					text += "|"
			elif square.bottom.is_solid == true:
				text += "_"
			else:
				text += "."
		if y<grid_dimension.y-1:
			text+="\",\n"
		else:
			text+="\"]\n"
	print (text)
	print("\n**************\n")
	
	
func get_edges() -> Array:
	var edges = []
	for y in grid_dimension.y:
		var text = ""
		for x in grid_dimension.x:
			var square = squares.at(x,y)
			if square.right.is_solid == true:
				if square.bottom.is_solid == true:
					text += "J"
				else:
					text += "|"
			elif square.bottom.is_solid == true:
				text += "_"
			else:
				text += "."
		edges.append(text)
	return edges
				
	
func add_robot(robot):
	robot.on_finished_moving.connect(_on_robot_finished_moving)
	add_child(robot)
	robot.set_init_pos(Vector2())
	
	
func _on_robot_finished_moving(robot):
	if robot.pos == target.pos:
		robot.shrink()
	

func is_wall_open(pos, direction) -> bool:
	var square = squares.at(pos.x, pos.y)
	match(direction):
		Direction.Up:
			return square.top.is_passable
		Direction.Down:
			return square.bottom.is_passable
		Direction.Left:
			return square.left.is_passable
		Direction.Right:
			return square.right.is_passable
			
	return false
	
func get_next_wall(init_pos, direction) -> Vector2:
	var end_pos = init_pos
	while(is_wall_open(end_pos,direction)):
		end_pos += direction
	
	return end_pos
