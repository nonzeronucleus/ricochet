class_name MultiArray
extends Node

var dimensions:Vector2
var data:Array = []

func _init(_dimensions:Vector2):
	dimensions = _dimensions
	data.resize(dimensions.x * dimensions.y)
	
func set_at(x:int ,y:int , value):
	data[(y * dimensions.y) + x] = value
	
func at(x:int,y:int):
	return data[(y * dimensions.y) + x]
	
