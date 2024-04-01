extends Node2D

#@export var top_enabled:bool:
#		top_enabled = value
#	set(value):
#		if not is_inside_tree():
#			await ready
#		top.is_solid = value

#	get:
#		top.is_solid = value
#		if not is_inside_tree():
#			await ready
#		top_enabled =  top.is_solid

#		return top_enabled

var square:Square

func _ready():
	square = Square.new('')
	
	square.left = Line.new(true)
	square.right = Line.new(true)
	square.top = Line.new(true)
	square.bottom = Line.new(true)
	
#	$Square.left = LineView.new()
#	$Square.right = LineView.new()
	#$Square.top = LineView.new()
#	$Square.bottom = LineView.new()
	$Square.init(square)
	
