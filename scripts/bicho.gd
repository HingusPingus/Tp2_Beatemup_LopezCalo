extends Character

class_name Enemy




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale.x=-1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction
	super.move(direction)
