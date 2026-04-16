extends Character
class_name	Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("melee_attack"):
		super.punch()
	if  Input.is_action_pressed("ui_left") and lastAxis==1 and !Input.is_action_pressed("ui_right"):
		scale.x=-1
		lastAxis=-1
	elif Input.is_action_pressed("ui_right") and lastAxis==-1 and !Input.is_action_pressed("ui_left"):
		scale.x=-1
		lastAxis=1
	var direction=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	super.move(direction)
	var wannaJump=Input.is_action_just_pressed("ui_accept")
	super.jump(wannaJump)
