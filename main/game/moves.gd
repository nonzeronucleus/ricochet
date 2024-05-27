class_name Moves
extends Node

signal moves_changed()

var _history = []

func reset():
	_history.clear()
	moves_changed.emit()
	
func add_move(move:MoveRobotCmd):
	_history.push_front(move)
	moves_changed.emit()
	
func get_move_count():
	return _history.size()
