class_name SquareSize
extends Node

signal size_changed()

var _length:float = 40.0:set = set_length

func _init(new_length:float):
	_length = new_length
	size_changed.emit()

func set_length(new_length):
#	print("Setting length "+str(new_length))
	if new_length != _length:
		_length = new_length
		size_changed.emit()

func screen_pos(game_pos:Vector2) -> Vector2:
	return game_pos*_length
	

func set_node_size(node):
	node.set_size(Vector2(_length, _length))

func screen_pos_centred(game_pos:Vector2) -> Vector2:
	return (game_pos+Vector2(0.5,0.5))*_length
	
	#var target_size = Vector2(square_size.length, square_size.length)

func calc_scale(init_size:Vector2) -> Vector2:
	var target_size = Vector2(_length, _length)
	var new_scale = target_size/init_size
	return new_scale
