@tool
extends PopupPanel

signal yes_pressed(data)
signal no_pressed(data)
signal cancel_pressed(data)

@export var confirmation_text:String = "Placeholder" : set = set_confirmation_text
var data


func _ready():
	populate_confirmation_text()

func set_confirmation_text(new_text:String):
	confirmation_text = new_text
	populate_confirmation_text()
	
func populate_confirmation_text():
#	if !Engine.is_editor_hint(): 
	if $MarginContainer/VBoxContainer/confirmation_text_field:
		$MarginContainer/VBoxContainer/confirmation_text_field.text = confirmation_text
		


func _on_confirm_button_pressed():
	visible = false
	yes_pressed.emit(data)


func _on_no_button_pressed():
	visible = false
	no_pressed.emit(data)


func _on_cancel_button_pressed():
	visible = false
	cancel_pressed.emit(data)


