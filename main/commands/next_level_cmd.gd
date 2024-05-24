class_name NextLevelCmd
extends Node

var level_mgr: LevelMgr
#var robot: Robot

func _init(new_level_mgr:LevelMgr) -> void:
	level_mgr = new_level_mgr
#	robot = new_robot
	

func execute() -> void:
	var level_idx = level_mgr.level_names.find(level_mgr.current_level.level_idx)
	level_idx += 1
	var next_level_idx =  level_mgr.level_names[level_idx]
	var next_level:Level = level_mgr.load_level(next_level_idx)
	level_mgr.set_current_level(next_level)
#	robot.reset_size()	
	
