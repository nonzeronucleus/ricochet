extends Node2D

@onready var left_check:CheckBox = $left_check
@onready var right_check:CheckBox = $right_check
@onready var top_check:CheckBox = $top_check
@onready var bottom_check:CheckBox = $bottom_check
@onready var target_check:CheckBox = $target_check
@onready var board:Board = $board
@onready var robot 
@onready var RobotTemplate = preload("res://main/board/robot/robot.tscn")

var level_mgr:LevelMgr:
	set = set_level_mgr


var selected_square:SquareView
signal go_to_editor()


func _ready():
	robot = RobotTemplate.instantiate()
	robot.set_square_size(board.square_size)
	robot.on_finished_moving.connect(robot_finished_moving)
	board.add_robot(robot)	
#	_on_board_setup_complete()
	
func set_level_mgr(new_level_mgr:LevelMgr):
	level_mgr = new_level_mgr
	board.level = level_mgr.current_level


func _on_board_setup_complete():
	load_all()
	
	
func _on_square_selected(new_square):
	selected_square = new_square
	left_check.disabled = selected_square.left.is_border
	right_check.disabled = selected_square.right.is_border
	top_check.disabled = selected_square.top.is_border
	bottom_check.disabled = selected_square.bottom.is_border

	left_check.visible = !selected_square.left.is_border
	right_check.visible = !selected_square.right.is_border
	top_check.visible = !selected_square.top.is_border
	bottom_check.visible = !selected_square.bottom.is_border
	
	left_check.button_pressed = selected_square.left.is_solid
	right_check.button_pressed = selected_square.right.is_solid
	top_check.button_pressed = selected_square.top.is_solid
	bottom_check.button_pressed = selected_square.bottom.is_solid
	target_check.button_pressed = selected_square.is_target


		
func save():
	var file = FileAccess.open("user://level1.dat", FileAccess.WRITE)
	file.store_var(board.target.pos)
	file.store_var(board.get_edges())

	file.close()


func load_all():
	board.load_level(2)



func _on_editor_button_pressed():
	go_to_editor.emit()


func move(direction):	
	$GameState.send_event("StartMoving")
	var moves = board.get_moves(robot.pos, direction)
#	var next_pos = moves[0]
	robot.set_moves(moves)
#	robot.set_pos(next_pos)

func robot_finished_moving(robot):
	$GameState.send_event("StopMoving")	
	


func _on_ready_state_unhandled_input(event):
	var direction = null
	
	if Input.is_action_pressed("ui_left"):
		move(Direction.Left)
	elif Input.is_action_pressed("ui_right"):
		move(Direction.Right)
	elif Input.is_action_pressed("ui_up"):
		move(Direction.Up)
	elif Input.is_action_pressed("ui_down"):
		move(Direction.Down)
