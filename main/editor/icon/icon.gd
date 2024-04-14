@tool
extends ColorRect

@export var selected_color:Color
@export var icon_group:IconGroup

var initial_color:Color

func _ready():
	initial_color = color
	
	if icon_group:
		icon_group.selection_changed.connect(on_selection_changed)
	for child in get_children():
		if child.has_signal("icon_selected"):
			child.icon_selected.connect(on_icon_selected)


func on_selection_changed(new_selection:Node):
	if new_selection == self:
		color = selected_color
	else:
		color = initial_color


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			select()


func on_icon_selected(icon):
	select()

func select():
	if icon_group:
		icon_group.selected = self
		
		
func apply(square):
	for child in get_children():
		if child.has_method("apply"):
			child.apply(square)
