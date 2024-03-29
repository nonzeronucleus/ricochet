class_name Line
extends Node

var is_solid:bool = false:set = set_is_solid

signal line_changed(line)

func _init(new_is_solid):
	is_solid = new_is_solid

func set_is_solid(new_is_solid):
	is_solid = new_is_solid
	line_changed.emit(self)

