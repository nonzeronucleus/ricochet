class_name SceneLoader
extends Control

@onready var game_screen = $game
@onready var editor_screen = $editor
@onready var level_select_screen = $level_select

var level_mgr = LevelMgr.new()


func _ready():
	for child in get_children():
		if child.has_method("set_level_mgr"):
			child.set_level_mgr(level_mgr)
			#child.set_navigator($Navigation)
			
	for child in get_children():
		if child.has_method("set_scene_loader"):
			child.set_scene_loader(self)
			#child.set_navigator($Navigation)
			
	goto_level_select()

func goto_level_select():
	level_select_screen.visible = true
	game_screen.visible = false


func goto_game():
	level_select_screen.visible = false
	game_screen.visible = true


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
