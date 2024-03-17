class_name Move
extends Node

var pos:Vector2
var instant:bool

func _init(new_pos:Vector2, new_instant:bool = false):
	pos = new_pos
	instant = new_instant
