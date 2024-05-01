@tool
class_name EditorPieceIcon
extends EditorIcon

@onready var RobotTemplate = preload("res://main/board/robot/robot.tscn")
@onready var robot = $robot


@export var texture:Texture2D:
	set(val):
		texture = val
		if not is_inside_tree():
			await ready
		$robot.texture = texture
		
func apply(board, square):
	if robot.is_player:
		var board_robot = board.player_robot
		board_robot.set_init_pos(square.pos)
