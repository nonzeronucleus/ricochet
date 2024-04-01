class_name SquareSize
extends Node

signal size_changed(length)

var length:int = 40:set = set_length

func _init(_length:int):
	length = _length

func set_length(_length):
	length = _length
	size_changed.emit(length)

func screen_pos(game_pos:Vector2) -> Vector2:
	return game_pos*length

func screen_pos_centred(game_pos:Vector2) -> Vector2:
	return (game_pos+Vector2(0.5,0.5))*length
