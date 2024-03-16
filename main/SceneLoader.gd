extends Control

@onready var game_screen = $game
@onready var editor_screen = $editor

func _ready():
	game_screen.go_to_editor.connect(_on_go_to_editor)
	editor_screen.go_to_game.connect(_on_go_to_game)
	
	
	
func _on_go_to_editor():
	$Navigation.send_event("GoToEditor")	

func _on_go_to_game():
	$Navigation.send_event("GoToGame")	


func _on_editor_screen_state_entered():
	editor_screen.visible = true
	pass


func _on_editor_screen_state_exited():
	editor_screen.visible = false
	pass


func _on_game_screen_state_entered():
	game_screen.visible = true


func _on_game_screen_state_exited():
	game_screen.visible =false
