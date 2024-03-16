extends Sprite2D

var square_size:SquareSize:set = set_square_size
var pos:Vector2

signal on_finished_moving(robot)


func set_square_size(_square_size):
	square_size = _square_size
	#set_size(Vector2(square_size.length, square_size.length))


func set_init_pos(new_pos:Vector2):
	pos = new_pos
	position = square_size.screen_pos_centred(pos)


func set_pos(new_pos:Vector2):
	var dif = abs(pos-new_pos)
	
	pos = new_pos
	
	var tween = create_tween()
	
	if tween:
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position", square_size.screen_pos_centred(pos), 0.1 * dif.length() )	
		await(tween.finished)
		on_finished_moving.emit(self)
		
		
func shrink():
	var tween = create_tween()
	
	if tween:
		tween.set_parallel()
		tween.tween_property(self, "rotation", TAU, 0.3) 
		tween.tween_property(self, "scale", Vector2(), 0.3 )	
		await(tween.finished)
	
