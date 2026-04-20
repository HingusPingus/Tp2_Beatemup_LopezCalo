extends Character
class_name	Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("melee_attack"):
		super.punch()
	if  Input.is_action_pressed("ui_left") and looking==1 and !Input.is_action_pressed("ui_right"):
		scale.x=-1
		looking=left
	elif Input.is_action_pressed("ui_right") and looking==-1 and !Input.is_action_pressed("ui_left"):
		scale.x=-1
		looking=right
	var wannaJump=Input.is_action_just_pressed("ui_accept")
	super.jump(wannaJump)
	var direction=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	super.move(direction)
	if(Input.is_action_just_pressed("alomancy_pull")):
		super.pull()
	if(Input.is_action_just_pressed("alomancy_push")):
		super.push()
	
