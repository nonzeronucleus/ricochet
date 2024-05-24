extends Control

@onready var button_template = load("res://main/level_select/level_select_button.tscn")

signal level_mgr_loaded()

var level_mgr:LevelMgr:
	set = set_level_mgr
	

var scene_loader:SceneLoader:
	set = set_scene_loader
	
	
func set_scene_loader(val):
	scene_loader = val
	
#var navigator:StateChart:
#	set = set_navigator
	
	
func set_level_mgr(new_level_mgr):
	level_mgr = new_level_mgr
	level_mgr_loaded.emit()

#func set_navigator(new_navigator:StateChart) -> void:
#	navigator = new_navigator


func _ready():
	var b:MarginContainer = button_template.instantiate()
	var btn_size = b.get_actual_size()
			
	var cols = int (size.x/btn_size.x)
	
	show_levels()
	
#	for i in cols:
#		var btn:LevelSelectButton = button_template.instantiate()
#		btn.text = str(i)
		
#		btn.position = Vector2(i * btn_size.x, 0)
#		btn.button_pressed.connect(on_button_pressed)
#		add_child(btn)
		
		
func show_levels():
	if !level_mgr:
		await level_mgr_loaded

	var b:MarginContainer = button_template.instantiate()
	var btn_size = b.get_actual_size()
			
	var cols = int (size.x/btn_size.x)		
	var levels = level_mgr.list_levels()
	var btn_pos = Vector2()
	
	for level_idx in range(levels.size()):
		var btn:LevelSelectButton = button_template.instantiate()
		btn.text = levels[level_idx]
		btn.level_idx = level_idx
		
		btn.position = btn_size * btn_pos
		btn.button_pressed.connect(on_button_pressed)
		add_child(btn)	
		btn_pos.x += 1
		if btn_pos.x >= cols:
			btn_pos.x = 0
			btn_pos.y += 1

func on_button_pressed(level_idx):
	level_mgr.load_level_by_id(level_idx)
	scene_loader.goto_game()
#	navigator.send_event("SelectLevel")
