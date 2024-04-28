class_name BoardContainer
extends Node2D

@onready var board:Board = $board
#@onready var player_robot 
#var level_id
#var init_pos:Vector2
var level:Level


var level_mgr:LevelMgr:
	set = set_level_mgr

var navigator:StateChart:
	set = set_navigator


func _ready():
#	player_robot = board.player_robot
	_reset()
	
func _reset():
	if level:
		board.player_robot.set_init_pos(level.start_pos)
#	robot.reset_size()
#	robot.set_init_pos(Vector2(1,1))
	
func set_level_mgr(new_level_mgr:LevelMgr) -> void:
	level_mgr = new_level_mgr
#	if level_mgr.current_level:
#		board.set_level(level_mgr.current_level)
#		level_id=level.level_id
	level_mgr.level_changed.connect(_on_level_changed)


func set_navigator(new_navigator:StateChart) -> void:
	navigator = new_navigator

func _on_level_changed(new_level):
	level = new_level
	board.set_level(level)	
	_reset()

