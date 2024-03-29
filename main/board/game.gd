extends Node2D

@onready var left_check:CheckBox = $left_check
@onready var right_check:CheckBox = $right_check
@onready var top_check:CheckBox = $top_check
@onready var bottom_check:CheckBox = $bottom_check
@onready var target_check:CheckBox = $target_check
@onready var board:Board = $board
@onready var robot 
@onready var RobotTemplate = preload("res://main/board/robot/robot.tscn")

var cmds = []

var level_mgr:LevelMgr:
	set = set_level_mgr

var navigator:StateChart:
	set = set_navigator


var selected_square:SquareView


func _ready():
	robot = RobotTemplate.instantiate()
	robot.set_square_size(board.square_size)
#	robot.on_finished_moving.connect(robot_finished_moving)
	board.add_robot(robot)	
	reset()
	
func reset():
	robot.set_instant_pos(Vector2())
	robot.reset_size()
	robot.position = Vector2()
	cmds = []
	
func set_level_mgr(new_level_mgr:LevelMgr) -> void:
	level_mgr = new_level_mgr
	board.level = level_mgr.current_level
	level_mgr.level_changed.connect(_on_level_changed)


func set_navigator(new_navigator:StateChart) -> void:
	navigator = new_navigator

func _on_level_changed(level):
	board.set_level(level)	



func _on_editor_button_pressed():
	navigator.send_event("GoToEditor")		
	#go_to_editor.emit()
	


func move(direction):
	cmds.append(MoveRobotCmd.new($GameState,board, robot, direction))

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


func _on_restart_button_pressed():
	robot.reset_size()


func _on_back_button_pressed():
	navigator.send_event("Back")	


func _on_ready_state_processing(delta):
	var next_cmd = cmds.pop_back()
	if next_cmd:
		next_cmd.execute()	
