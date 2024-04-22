@tool
class_name  RobotTemplate

extends Node

@export var player_texture:Texture2D
@export var npctexture:Texture2D

static var inst:RobotTemplate:
	set(val):
		inst = val
	get:
		if !inst:
			inst = RobotTemplate.new()
		return inst
