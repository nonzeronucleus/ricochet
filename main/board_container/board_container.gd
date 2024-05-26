class_name BoardContainer
extends Node2D

@onready var board:Board = $board
var level:Level


var level_mgr:LevelMgr:
	set = set_level_mgr

#var navigator:StateChart:
#	set = set_navigator


func _ready():
	_reset()
	
func _reset():
	board.reset()
#	if level:
		
#		board.get_player_robot().set_init_pos(level.start_pos)
	
func set_level_mgr(new_level_mgr:LevelMgr) -> void:
	level_mgr = new_level_mgr
	level_mgr.level_changed.connect(_on_level_changed)


#func set_navigator(new_navigator:StateChart) -> void:
#	navigator = new_navigator

func _on_level_changed(new_level):
	level = new_level
	board.set_level(level)	
	_reset()

