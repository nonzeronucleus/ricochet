extends BoardContainer

@onready var left_check:CheckBox = $left_check
@onready var right_check:CheckBox = $right_check
@onready var top_check:CheckBox = $top_check
@onready var bottom_check:CheckBox = $bottom_check
@onready var target_check:CheckBox = $target_check
@onready var game_state:StateChart = $StateChart

var cmds = []


var selected_square:SquareView
var swipe_started = false
var swipe_start = Vector2()
const minimum_drag = 5
var scene_loader:SceneLoader:
	set = set_scene_loader
	


		
func set_scene_loader(val):
	scene_loader = val

func start():
	_reset()
	
func _reset():	
	super._reset()
	cmds = []
	if game_state:
		game_state.send_event(GameEvents.START)	
	
	
#func set_navigator(new_navigator:StateChart) -> void:
#	navigator = new_navigator


#func _on_editor_button_pressed():
	#navigator.send_event("GoToEditor")		

func move(direction):
	cmds.append(MoveRobotCmd.new(game_state,board, board.get_selected_robot(), direction))

#func _unhandled_input(event):
#	_on_ready_state_unhandled_input(event)

func _on_active_state_unhandled_input(event):
	_on_ready_state_unhandled_input(event)

func _on_ready_state_unhandled_input(event):
	
	if Input.is_action_pressed("ui_left"):
		move(Direction.Left)
	elif Input.is_action_pressed("ui_right"):
		move(Direction.Right)
	elif Input.is_action_pressed("ui_up"):
		move(Direction.Up)
	elif Input.is_action_pressed("ui_down"):
		move(Direction.Down)


func _on_restart_button_pressed():
	board.get_player_robot().reset_size()
	_reset()
	if game_state:
		game_state.send_event(GameEvents.START)	


func _on_back_button_pressed():
	scene_loader.goto_level_select()
#	navigator.send_event("Back")	


#func _process(delta):
#	_on_ready_state_processing(delta)

func _on_active_state_processing(delta):
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
	level_mgr.load_level_by_id(level.level_idx+1)
	if game_state:
		game_state.send_event(GameEvents.START)	
#	cmds.append(NextLevelCmd.new(level_mgr))
#	$GameState.send_event("StartGame")

func _on_game_over_state_processing(delta):
	check_cmds()

func _on_handle_swipe_input(event):
	var direction = null

	if event is InputEventScreenTouch:
		if event.pressed:
			swipe_start = event.position
		else:			
			var diff = event.position - swipe_start
			if diff.length() > minimum_drag:
				if abs(diff.x) > abs(diff.y):
					if diff.x > 0:
						move(Direction.Right)
					else:
						move(Direction.Left)
				else:
					if diff.y > 0:
						move(Direction.Down)
					else:
						move(Direction.Up)




