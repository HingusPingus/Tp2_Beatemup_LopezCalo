extends Character
class_name	Player
@onready var alomancy = $alomancy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	Global.setMaxValue.emit(max_health)
	Global.setMaxPower.emit(max_power)

	Global.setHealthBar.emit(health)
	pass
	pwrUp=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:


	if Input.is_action_just_pressed("melee_attack"):
		super.punch()
	if  Input.is_action_pressed("ui_left") and looking==1 and !Input.is_action_pressed("ui_right") and !hitting:
		scale.x=-1
		looking=left
	elif Input.is_action_pressed("ui_right") and looking==-1 and !Input.is_action_pressed("ui_left") and !hitting:
		scale.x=-1
		looking=right
	var wannaJump=Input.is_action_just_pressed("ui_accept")
	super.jump(wannaJump)
	var direction=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	super.move(direction)
	if(Input.is_action_just_pressed("alomancy_pull")):
		pull(alomancy)
	if(Input.is_action_just_pressed("alomancy_push")):
		push(alomancy)
	if(Input.is_action_just_pressed("switch_drain")):
		changeMode(1)
	if(Input.is_action_just_pressed("switch_power")):
		changeMode(2)
	if(Input.is_action_just_pressed("switch_normal")):
		changeMode(3)
		
		

func changeMode(choice):
	Global.changeMode.emit(choice)
	if choice==1:
		pwrUp=false
		drain=true
		healthy=false
	elif choice==2:
		pwrUp=true
		drain=false
		healthy=false
	else:
		pwrUp=false
		drain=false
		healthy=true

func changeHealth(dmg):
	health-=dmg
	Global.setHealthBar.emit(health)
	
func die():
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
