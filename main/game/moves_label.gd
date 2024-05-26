extends Label

@export var moves:Moves

func _ready():
	moves.moves_changed.connect(_on_moves_changed)
	_on_moves_changed()
	

func _on_moves_changed():
	text = "Moves: %d" %moves.get_move_count()
