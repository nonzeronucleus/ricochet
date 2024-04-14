@tool
class_name EditorPieceIcon
extends EditorIcon



@export var texture:Texture2D:
	set(val):
		texture = val
		if not is_inside_tree():
			await ready
		$robot.texture = texture
		print($robot.texture)
