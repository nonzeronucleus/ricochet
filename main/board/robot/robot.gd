@tool
class_name Robot
extends AnimatedSprite2D

var square_size:SquareSize:set = set_square_size
var pos:Vector2
var moves:Array
var init_scale:Vector2

@export var is_player:bool:
	set(val):
		is_player = val
		_set_animation()

signal finished_moving(robot)
signal finished_shrinking(robot)
@export var char_texture:Texture2D
@export var npc_textures : Array[Texture2D]

var template:RobotTemplate


func  _ready():
	init_scale = scale
	z_index = 2
	_set_animation()
	
	
func _set_animation():
	if is_player:
		animation = "player"
	else:
		animation = "npc"

func set_square_size(_square_size):
	square_size = _square_size
	var texture_size = _get_texture_size()
	var target_size = Vector2(square_size.length, square_size.length)
	init_scale = target_size/texture_size
	
	scale = init_scale
	
func _get_texture_size() -> Vector2:
	var frame = sprite_frames.get_frame_texture("player", 0)
	
	return frame.get_size()


func set_init_pos(new_pos:Vector2):
	pos = new_pos
	set_screen_position()
	
	
func set_screen_position():
	position = square_size.screen_pos_centred(pos)


func _set_instant_pos(new_pos:Vector2):
	reset_size()
	pos = new_pos
	set_screen_position()
	if moves.size()>0:
		set_next_move()	
	


func set_pos(new_pos:Vector2):
	var dif = abs(pos-new_pos)
	pos = new_pos
	var tween = create_tween()
	
	if tween:
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position", square_size.screen_pos_centred(pos), 0.1 * dif.length() )	
		await(tween.finished)
		set_next_move()


func set_moves(new_moves:Array):
	moves = new_moves
	set_next_move()
		

func set_next_move():
	if moves.size()>0:
		var next_move:Move = moves.pop_front()
		if next_move.instant:
			_set_instant_pos(next_move.pos)
		else:
			set_pos(next_move.pos)
	else:
		finished_moving.emit(self)
	

func shrink():
	var tween = create_tween()
	
	if tween:
		tween.set_parallel()
		tween.tween_property(self, "rotation", TAU, 0.3) 
		tween.tween_property(self, "scale", Vector2(), 0.3 )	
		await(tween.finished)
	finished_shrinking.emit(self)
		
	
func reset_size():
	rotation = 0
	scale = init_scale
	set_screen_position()
