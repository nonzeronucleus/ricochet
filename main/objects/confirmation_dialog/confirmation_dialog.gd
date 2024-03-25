@tool
extends PopupPanel

signal yes_pressed()
signal no_pressed()
signal cancel_pressed()

@export var confirmation_text:String = "Placeholder" : set = set_confirmation_text


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
	yes_pressed.emit()


func _on_no_button_pressed():
	visible = false
	no_pressed.emit()


func _on_cancel_button_pressed():
	visible = false
	cancel_pressed.emit()


