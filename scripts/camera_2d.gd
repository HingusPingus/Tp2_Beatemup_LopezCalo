extends Camera2D
@onready var player=$"../player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(position.x>1000 and get_parent().get_child_count()>3):
		pass
	elif position.x<player.global_position.x:
		position.x=player.global_position.x
