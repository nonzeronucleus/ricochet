extends Node2D

@onready var left_check:CheckBox = $left_check
@onready var right_check:CheckBox = $right_check
@onready var top_check:CheckBox = $top_check
@onready var bottom_check:CheckBox = $bottom_check
@onready var target_check:CheckBox = $target_check
@onready var board = $board
@onready var level_combo = $level_combo
@onready var confirmation_dialog = $Control/CenterContainer/confirmation_dialog

#var current_level:Level

var level_mgr:LevelMgr:
	set = set_level_mgr
var navigator:StateChart:
	set = set_navigator
	
var next_level:Level

var selected_square:SquareView
var selected_level_listbox_id:int

func _ready():
	$board.square_selected.connect(_on_square_selected)
	confirmation_dialog.move_to_center()
	confirmation_dialog.position = Vector2(0,0)
	confirmation_dialog.yes_pressed.connect(on_confirm_yes_pressed)
	confirmation_dialog.no_pressed.connect(on_confirm_no_pressed)
	confirmation_dialog.cancel_pressed.connect(on_confirmation_cancelled)
	selected_level_listbox_id = 0


func set_level_mgr(new_level_mgr:LevelMgr):
	level_mgr = new_level_mgr
	board.level = level_mgr.current_level
	for level_name in level_mgr.level_names:
		level_combo.add_item(level_name)
	level_mgr.level_changed.connect(_on_level_changed)


func set_navigator(new_navigator:StateChart) -> void:
	navigator = new_navigator


func _on_level_changed(level):
	board.set_level(level)	


func _on_board_setup_complete():
	load_all()


func switch_to_level_idx(idx):
	board.level.dirty = false
	var next_level = level_mgr.load_level_by_idx(idx)
	board.set_level(next_level)	
	


func on_confirm_yes_pressed(selected_idx):
	level_mgr.save(board.level)
	switch_to_level_idx(selected_idx)


func on_confirm_no_pressed(selected_idx):
	switch_to_level_idx(selected_idx)
#	board.set_level(next_level)	
	

	
func on_confirmation_cancelled(selected_idx):
	next_level = board.level
	level_combo.select(selected_level_listbox_id)

	
func _on_square_selected(_square):
	selected_square = _square
	
	left_check.button_pressed = _square.left.is_solid
	right_check.button_pressed = _square.right.is_solid
	top_check.button_pressed = _square.top.is_solid
	bottom_check.button_pressed = _square.bottom.is_solid
	target_check.button_pressed = _square.is_target


func _on_left_check_pressed():
	if selected_square:
		selected_square.left.is_solid = left_check.button_pressed



func _on_top_check_pressed():
	if selected_square:
		selected_square.top.is_solid = top_check.button_pressed


func _on_right_check_pressed():
	if selected_square:
		selected_square.right.is_solid = right_check.button_pressed


func _on_bottom_check_pressed():
	if selected_square:
		selected_square.bottom.is_solid = bottom_check.button_pressed


func _on_target_check_pressed():
	if selected_square:
		board.set_target(selected_square)


func save():
	var file = FileAccess.open("user://level1.dat", FileAccess.WRITE)
	file.store_var(board.target.pos)
	file.store_var(board.get_edges())
	file.close()


func load_all():
	level_mgr.load_level(level_mgr.current_level.level_id)


func _on_save_button_pressed():
	level_mgr.save(board.level)


func _on_load_button_pressed():
	load_all()


func _on_button_pressed():
	navigator.send_event("GoToGame")


func _on_new_button_pressed():
	level_mgr.new_level()


func _on_level_combo_item_selected(index):	
	if board.level.dirty:
		confirmation_dialog.visible = true
		confirmation_dialog.data = index
	else:
		switch_to_level_idx(index)

#	selected_level_listbox_id = level_combo.get_selected_id()
	
	
#	var level_name = level_combo.get_item_text(index)
#	level_mgr.select_level(level_name)


func _on_back_button_pressed():
	navigator.send_event("Back")
