@tool
class_name LevelSelectButton
extends MarginContainer

@onready var label = $TextureButton/Label
@onready var btn = $TextureButton

@export_file var level_path
@export var text:String:
	set(val):
		text = val
		if not is_inside_tree():
			await ready
		label.text = text
var level_idx : int

var original_size := scale
var grow_size := Vector2(1.1, 1.1)

signal button_pressed(level_idx)

func get_actual_size():
	var size = $TextureButton.texture_normal.get_size()
	size.x += get_theme_constant("margin_left")+get_theme_constant("margin_right")
	size.y += get_theme_constant("margin_top")+get_theme_constant("margin_bottom")
	size *= scale
	
	return size

func _on_lvl_btn_mouse_entered() -> void:
	grow_btn(grow_size, .1)

func _on_lvl_btn_mouse_exited() -> void:
	grow_btn(original_size, .1)
	
	
func grow_btn(end_size: Vector2, duration: float) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'scale', end_size, duration)
	
	
#func _on_lvl_btn_pressed() -> void:
#	navigator.send_event("SelectLevel")		

#	if level_path == null:
#		return
#	get_tree().change_scene_to_file(level_path)




func _on_texture_button_button_up():
	pass # Replace with function body.


func _on_texture_button_button_down():
	pass # Replace with function body.


func _on_texture_button_toggled(toggled_on):
	pass # Replace with function body.


func _on_texture_button_pressed():
	button_pressed.emit(level_idx)
