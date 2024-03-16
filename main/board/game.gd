extends Node2D

@onready var left_check:CheckBox = $left_check
@onready var right_check:CheckBox = $right_check
@onready var top_check:CheckBox = $top_check
@onready var bottom_check:CheckBox = $bottom_check
@onready var target_check:CheckBox = $target_check
@onready var board = $board
@onready var robot 
@onready var RobotTemplate = preload("res://main/board/robot/robot.tscn")


var selected_square:Square
signal go_to_editor()


func _ready():
	$board.square_selected.connect(_on_square_selected)
	robot = RobotTemplate.instantiate()
	robot.set_square_size(board.square_size)
	robot.on_finished_moving.connect(robot_finished_moving)
	board.add_robot(robot)	
	load_all()
#	_on_board_setup_complete()
	

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
	var file = FileAccess.open("user://level1.dat", FileAccess.READ)
	var target_pos = file.get_var()
	board.set_target_pos(target_pos)
	var edges = file.get_var()
	board.parse_edge_layout(edges)
	file.close()


func _on_editor_button_pressed():
	go_to_editor.emit()


func move(direction):	
	$GameState.send_event("StartMoving")	
	var next_pos = board.get_next_wall(robot.pos, direction)
	robot.set_pos(next_pos)

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
