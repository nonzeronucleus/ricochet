extends Control

@onready var game_screen = $game
@onready var editor_screen = $editor
@onready var level_select_screen = $level_select

var level_mgr = LevelMgr.new()

func _ready():
#	game_screen.go_to_editor.connect(_on_go_to_editor)
#	editor_screen.go_to_game.connect(_on_go_to_game)
	for child in get_children():
		if child.has_method("set_level_mgr"):
			child.set_level_mgr(level_mgr)
			child.set_navigator($Navigation)
#			print(child)
#	game_screen.level_mgr = level_mgr
#	editor_screen.level_mgr = level_mgr
	
	
	
#func _on_go_to_editor():
#	$Navigation.send_event("GoToEditor")	

#func _on_go_to_game():
#	$Navigation.send_event("GoToGame")	


func _on_editor_screen_state_entered():
	editor_screen.visible = true


func _on_editor_screen_state_exited():
	editor_screen.visible = false


func _on_game_screen_state_entered():
	game_screen.visible = true
	game_screen._on_restart_button_pressed()


func _on_game_screen_state_exited():
	game_screen.visible =false


func _on_level_select_screen_state_entered():
	level_select_screen.visible=true


func _on_level_select_screen_state_exited():
	level_select_screen.visible=false
