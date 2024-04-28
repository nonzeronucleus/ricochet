@tool
class_name EditorPieceIcon
extends EditorIcon

@onready var RobotTemplate = preload("res://main/board/robot/robot.tscn")
var board

@export var texture:Texture2D:
	set(val):
		texture = val
		if not is_inside_tree():
			await ready
		$robot.texture = texture
		
func apply(square):
	var robot = board.player_robot
	robot.set_init_pos(square.pos)
