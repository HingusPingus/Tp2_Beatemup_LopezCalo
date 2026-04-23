extends Character
class_name	Player
@onready var alomancy = $alomancy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.setMaxValue.emit(max_health)
	Global.setHealthBar.emit(health)

	pass # Replace with function body.


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
		pull()
	if(Input.is_action_just_pressed("alomancy_push")):
		push()
	if(Input.is_action_just_pressed("switch_drain")):
		changeMode(1)
	if(Input.is_action_just_pressed("switch_power")):
		changeMode(2)
	if(Input.is_action_just_pressed("switch_normal")):
		changeMode(3)
		
		
func pull():
	if  can_attack and !falling and !lying and power>=10:
		power-=10
		timer=get_tree().create_timer(punch_cd)
		timer.timeout.connect(animation_cd)
		hitting=true
		if !jumping:
			_animated_sprite.play("alomancy_pull")
		else:
			_animated_sprite.play("jump_alomancy_pull")
		can_attack = false
		timer=get_tree().create_timer(punch_cd)
		timer.timeout.connect(cd_reset)
		for i in alomancy.get_overlapping_areas():
			if(i is Auch):
				i.get_parent().fall(looking*-1,false, power)
				
func push():
	if  can_attack and !falling and !lying and power>=10:
		power-=10
		timer=get_tree().create_timer(punch_cd)
		timer.timeout.connect(animation_cd)
		hitting=true
		if !jumping:
			_animated_sprite.play("alomancy_push")
		else:
			_animated_sprite.play("jump_alomancy_push")
		can_attack = false
		timer=get_tree().create_timer(punch_cd)
		timer.timeout.connect(cd_reset)
		for i in alomancy.get_overlapping_areas():
			if(i is Auch):
				i.get_parent().fall(looking,false, power)
func changeMode(choice):
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
