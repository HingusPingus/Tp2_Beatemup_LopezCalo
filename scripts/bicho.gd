extends Character

class_name Enemy
@onready var player=$"../player"
@onready var areaPersonal=$"piña"
var direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if areaPersonal.has_overlapping_bodies() or falling or lying:
		direction=Vector2.ZERO
		super.punch()
	else:
		direction=global_position.direction_to(player.global_position)
	super.jump(false)
	var pos=player.global_position.x-global_position.x
	if(pos<0 and looking==right):
		scale.x=-1
		looking=left
	elif(pos>0 and looking==left):
		scale.x=-1
		looking=right

	super.move(direction)
	
	
	

	
