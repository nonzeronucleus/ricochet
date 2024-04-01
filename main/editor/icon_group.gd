class_name IconGroup
extends Node

signal selection_changed(node)

var selected:Node:
	set(value):
		selected = value
		selection_changed.emit(selected)
