class_name Move
extends Node

var end_pos:Vector2
var instant:bool

func _init(new_end_pos:Vector2, new_instant:bool = false):
	end_pos = new_end_pos
	instant = new_instant
