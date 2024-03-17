class_name Level

extends Node

var level_id:int
var squares:Array
var target_pos:Vector2


func _init(new_level_id:int, new_squares:Array, new_target_pos:Vector2):
	level_id = new_level_id
	squares = new_squares
	target_pos = new_target_pos
