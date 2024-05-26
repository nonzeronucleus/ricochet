class_name Moves
extends Node

signal moves_changed()

var _history = []

func reset():
	_history.clear()
	moves_changed.emit()
	
func add_move(move:Vector2):
	_history.append(move)
	moves_changed.emit()
	
func get_move_count():
	return _history.size()
