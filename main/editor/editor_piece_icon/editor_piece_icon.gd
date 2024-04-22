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
		print($robot.texture)
		
func apply(square):
	var robot = RobotTemplate.instantiate()
	robot.set_square_size(board.square_size)
	board.add_robot(robot) #TODO
	robot.set_instant_pos(square.pos)
	
	
#	square.left.is_solid = left_enabled
