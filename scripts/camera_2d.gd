extends Camera2D
@onready var player=$"../player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(get_parent().get_child_count()<=3 and is_instance_valid(player) and position.x<player.global_position.x):
		position.x=player.global_position.x
	
