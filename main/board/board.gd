@tool
class_name Board
extends ColorRect

@onready var SquareTemplate = preload("res://main/board/square_view/square_view.tscn")
@onready var WallTemplate = preload("res://main/board/wall_view/wall_view.tscn")
@onready var RobotTemplate = preload("res://main/board/robot/robot.tscn")

var grid_dimension = Vector2(1,1)
var target = SquareView

var square_size
var square_views:MultiArray
var squares:Array
var all_robots:Array = []
var _level:Level

func get_selected_robot() -> Robot:
	return all_robots.filter(func(robot): return robot.is_selected)[0]


func get_player_robot() -> Robot:
	return all_robots.filter(func(robot): return robot.is_player)[0]


func get_npc_robots() -> Array:
	return all_robots.filter(func(robot): return !robot.is_player)



signal square_selected(square)
signal setup_complete()


func _ready():
#	var player_robot = RobotTemplate.instantiate()
#	player_robot.is_player = true
#	player_robot.set_screen_position()	
	square_size = SquareSize.new(calc_square_size())
#	player_robot.set_square_size(square_size)	
	square_size.size_changed.connect(_on_square_size_changed)
#	player_robot.is_selected = true
#	all_robots.append(player_robot)


func _on_square_size_changed(_length):
	pass

func calc_square_size():
	var board_size = get_size()
	
	return (board_size.x / grid_dimension.x)

func resize_squares():
	square_size.set_length(calc_square_size())
	queue_redraw()


func set_level(new_level:Level):
	_level = new_level
	reset()
	
func reset():
	if _level:
		remove_all_squares()
		grid_dimension = _level.get_size()
		square_views = MultiArray.new(_level.get_size())
		add_all_squares()
		init_squares(_level.squares)
		set_target_pos(_level.target_pos)
		#get_player_robot().set_init_pos(_level.start_pos)
		add_player_robot(_level.start_pos)
		add_npcs(_level.npcs_pos)
		resize_squares()


func add_player_robot(pos:Vector2):
	var player_robot = RobotTemplate.instantiate()
	player_robot.is_player = true
#	player_robot.set_screen_position()	
	player_robot.set_square_size(square_size)	
	player_robot.is_selected = true
	player_robot.set_init_pos(pos)
	all_robots.append(player_robot)
	add_child(player_robot)
		


#func reset():
#	pass
	


func init_squares(new_squares:Array):	
	for y in new_squares.size():	
		var row = new_squares[y]
		for x in row.size():
			var square_view = square_views.at(x,y)
			if square_view:
				square_view.init(row[x])
	squares = new_squares
	
func add_npcs(npcs_pos:Array):
	for pos in npcs_pos:
		var npc:Robot = RobotTemplate.instantiate()
		npc.pos = pos
		npc.square_size = square_size
		add_child(npc)
		all_robots.append(npc)
		npc.set_screen_position()


func remove_all_squares():
	if !square_views:
		return
	for x in range(square_views.dimensions.x):
		for y in range(square_views.dimensions.y):
			square_views.at(x,y).queue_free()
			square_views.set_at(x,y,null)
	
	for robot:Robot in all_robots:
#		if !robot.is_player:
#		all_robots.erase(robot)
		remove_child(robot)
		robot.queue_free()
	all_robots.clear()
	
func add_all_squares():
	for x in grid_dimension.x:
		for y in grid_dimension.y:
			var square_view = SquareTemplate.instantiate()
			square_view.square_size = square_size
			square_view.pos = Vector2(x,y)
			square_views.set_at(x,y,square_view)
			mark_square_target(square_view)
			square_view.square_selected.connect(_on_square_selected)
			add_child(square_view) 
	set_target(square_views.at(0,0))
	#add_child(get_player_robot())
	


func _on_square_selected(selected_square:SquareView):
	for robot in all_robots:
		if robot.pos == selected_square.pos:
			select_robot(selected_square.pos)
	return
	

func select_robot(pos:Vector2):
	for robot in all_robots:
		robot.is_selected = (robot.pos == pos)
	return


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

				
		
func is_square_open(current_robot, pos) -> bool:
	
	for robot in all_robots:
		if robot.pos == pos && robot!=current_robot:
			return false
	return true

	
func is_wall_open(current_robot, pos, direction) -> bool:
	var square = square_views.at(pos.x, pos.y)
	var next_pos = pos + direction
	
	if !is_square_open(current_robot, next_pos):
		return false
	
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
	var line_color = Color.BLACK
	var width = 4.0
	draw_line(Vector2(0,0), Vector2(0,size.y), line_color, width)
	draw_line(Vector2(0,0), Vector2(size.x,0), line_color, width)
	draw_line(Vector2(0,size.y), Vector2(size.x,size.y), line_color, width)
	draw_line(Vector2(size.x,0), Vector2(size.x,size.y), line_color, width)


func _add_npc_robot(pos:Vector2):
	var npc = RobotTemplate.instantiate()
	npc.set_square_size(square_size)
	npc.is_player = false
	npc.set_init_pos(pos)
	all_robots.append(npc)
	add_child(npc)
	npc.set_screen_position()
