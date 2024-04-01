@tool
extends Node2D

@export var icon_group:IconGroup = null

@export var top_enabled:bool:
	set(value):
		top_enabled = value
		square.top.is_solid = value
	get:
		return top_enabled
		
		
@export var left_enabled:bool:
	set(value):
		left_enabled = value
		square.left.is_solid = value
	get:
		return left_enabled
		

@export var right_enabled:bool:
	set(value):
		right_enabled = value
		square.right.is_solid = value
	get:
		return right_enabled


@export var bottom_enabled:bool:
	set(value):
		bottom_enabled = value
		square.bottom.is_solid = value
	get:
		return bottom_enabled

var square:Square = Square.new('')

func _init():
	square.left = Line.new(left_enabled)
	square.right.is_solid = right_enabled
	square.top = Line.new(top_enabled)
	square.bottom.is_solid = bottom_enabled
	

func _ready():
	$Square.init(square)
	if icon_group && icon_group.has_signal("selection_changed"):
		icon_group.selection_changed.connect(_on_changed_icon_selection)
	


func _on_toggled(toggled_on):
	print("Toggled" + str(self))


func _on_square_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			
			if icon_group:
				icon_group.selected = self


func _on_changed_icon_selection(selected):
	$Square.set_as_target(selected == self)
