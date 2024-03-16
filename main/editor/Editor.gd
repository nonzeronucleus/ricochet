extends Node2D

@onready var left_check:CheckBox = $left_check
@onready var right_check:CheckBox = $right_check
@onready var top_check:CheckBox = $top_check
@onready var bottom_check:CheckBox = $bottom_check
@onready var target_check:CheckBox = $target_check
@onready var board = $board

var selected_square:SquareView

signal go_to_game()


func _ready():
	$board.square_selected.connect(_on_square_selected)
	load_all()
	var level_mgr = LevelMgr.new()
	
	level_mgr.load_level(1)

	
func _on_board_setup_complete():
	load_all()
	
	
func _on_square_selected(_square):
	selected_square = _square
	left_check.disabled = _square.left.is_border
	right_check.disabled = _square.right.is_border
	top_check.disabled = _square.top.is_border
	bottom_check.disabled = _square.bottom.is_border

	left_check.visible = !_square.left.is_border
	right_check.visible = !_square.right.is_border
	top_check.visible = !_square.top.is_border
	bottom_check.visible = !_square.bottom.is_border
	
	left_check.button_pressed = _square.left.is_solid
	right_check.button_pressed = _square.right.is_solid
	top_check.button_pressed = _square.top.is_solid
	bottom_check.button_pressed = _square.bottom.is_solid
	target_check.button_pressed = _square.is_target


func _on_left_check_pressed():
	if selected_square:
		selected_square.left.is_solid = left_check.button_pressed
		board.get_edge_text()



func _on_top_check_pressed():
	if selected_square:
		selected_square.top.is_solid = top_check.button_pressed
		board.get_edge_text()


func _on_right_check_pressed():
	if selected_square:
		selected_square.right.is_solid = right_check.button_pressed
		board.get_edge_text()


func _on_bottom_check_pressed():
	if selected_square:
		selected_square.bottom.is_solid = bottom_check.button_pressed
		board.get_edge_text()


func _on_target_check_pressed():
	if selected_square:
		board.set_target(selected_square)


func save():
	var file = FileAccess.open("user://level1.dat", FileAccess.WRITE)
	file.store_var(board.target.pos)
	file.store_var(board.get_edges())
	file.close()


func load_all():
	var file = FileAccess.open("user://level1.dat", FileAccess.READ)
	var target_pos = file.get_var()
	board.set_target_pos(target_pos)
	var edges = file.get_var()
	board.parse_edge_layout(edges)
	file.close()


func _on_save_button_pressed():
	save()


func _on_load_button_pressed():
	load_all()


func _on_button_pressed():
	go_to_game.emit()
