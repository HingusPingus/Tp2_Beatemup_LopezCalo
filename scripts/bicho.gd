extends Character

class_name Enemy



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(is_inside_tree())
	var player=self.get_tree().get_root().get_node("res://scenes/character.tscn")

	var direction=(player.getPosition() - position)/50
	super.move(direction)
	super.jump(false)
	
