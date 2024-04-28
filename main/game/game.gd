extends BoardContainer

@onready var left_check:CheckBox = $left_check
@onready var right_check:CheckBox = $right_check
@onready var top_check:CheckBox = $top_check
@onready var bottom_check:CheckBox = $bottom_check
@onready var target_check:CheckBox = $target_check

var cmds = []


var selected_square:SquareView

	
func _reset():
	super._reset()
	cmds = []
	
#func set_level_mgr(new_level_mgr:LevelMgr) -> void:
#	level_mgr = new_level_mgr
#	board.set_level(level_mgr.current_level)
#	level_mgr.level_changed.connect(_on_level_changed)

func set_navigator(new_navigator:StateChart) -> void:
	navigator = new_navigator

#func _on_level_changed(level):
#	board.set_level(level)	
#	_reset()



func _on_editor_button_pressed():
	navigator.send_event("GoToEditor")		
	#go_to_editor.emit()
	


func move(direction):
	cmds.append(MoveRobotCmd.new($GameState,board, board.player_robot, direction))

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
	board.player_robot.reset_size()
	_reset()
	$GameState.send_event("StartGame")	


func _on_back_button_pressed():
	navigator.send_event("Back")	


func _on_ready_state_processing(delta):
	check_cmds()
	
func check_cmds():	
	var next_cmd = cmds.pop_back()
	if next_cmd:
		next_cmd.execute()	


func _on_playing_state_entered():
	$next_level_button.visible = false
	
	
func _on_game_over_state_entered():
	$next_level_button.visible = true


func _on_next_level_button_pressed():
	cmds.append(NextLevelCmd.new(level_mgr, board.player_robot))
	$GameState.send_event("StartGame")

func _on_game_over_state_processing(delta):
	check_cmds()
