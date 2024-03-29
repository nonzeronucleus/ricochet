class_name MoveRobotCmd
extends Node

var game_state:StateChart 
var board:Board
var robot:Robot
var direction:Vector2

func _init(new_game_state:StateChart, new_board:Board, new_robot:Robot, new_direction:Vector2):
	game_state = new_game_state
	board = new_board
	robot = new_robot
	direction = new_direction
	
func execute():
	game_state.send_event("StartMoving")
	robot.finished_moving.connect(on_robot_finished_moving)	
	var moves = get_moves(board, robot.pos, direction)
	robot.set_moves(moves)
	
func get_moves(board, init_pos, direction) -> Array:
	var grid_dimension = board.grid_dimension
	var moves:Array = []
	var end_pos = init_pos
	var looped_round = false
	
	while(board.is_wall_open(end_pos,direction) && !looped_round):
		end_pos += direction
		
		#check for whether needs to loop round
		if end_pos.x < 0:
			moves.append(Move.new(end_pos))
			moves.append(Move.new(Vector2(grid_dimension.x,end_pos.y),true))
			end_pos.x = grid_dimension.x-1
		if end_pos.y < 0:
			moves.append(Move.new(end_pos))
			moves.append(Move.new(Vector2(end_pos.x,grid_dimension.y),true))
			end_pos.y = grid_dimension.y -1
		if end_pos.x >= grid_dimension.x:
			moves.append(Move.new(end_pos))
			moves.append(Move.new(Vector2(-1,end_pos.y),true))
			end_pos.x = 0
		if end_pos.y >= grid_dimension.y:
			moves.append(Move.new(end_pos))
			moves.append(Move.new(Vector2(end_pos.x,-1), true))
			end_pos.y = 0
		#Check to see if looped all the way round
		
		if end_pos == init_pos:
			looped_round = true
		
	
	moves.append(Move.new(end_pos))
	return moves

func on_robot_finished_moving(robot):
	if robot.pos == board.target.pos:
		robot.finished_shrinking.connect(on_robot_finished_shrinking)	
		robot.shrink()
	else:
		game_state.send_event("StopMoving")

func on_robot_finished_shrinking(robot):
	game_state.send_event("StopMoving")
