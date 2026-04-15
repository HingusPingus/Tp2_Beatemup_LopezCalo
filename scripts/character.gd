extends CharacterBody2D

class_name Player
@onready var _animated_sprite = $AnimatedSprite2D
@onready var hitbox = $piña
const speed=300
const JUMP_VELOCITY = -400.0
var jumping
var punch_cd=0.25
var can_attack=true
var hitting=false
var timer
var damage=50
var lastAxis=1
var yPosition:float

func _physics_process(delta: float) -> void:
	if jumping:
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("melee_attack") and can_attack:
		timer=get_tree().create_timer(punch_cd)
		timer.timeout.connect(animation_cd)
		hitting=true
		if !jumping:
			_animated_sprite.play("punch")
		else:
			_animated_sprite.play("jump-punch")
		can_attack = false
		timer=get_tree().create_timer(punch_cd)
		timer.timeout.connect(cd_reset)
		for i in hitbox.get_overlapping_bodies():
			if i is Enemy:
				i.take_damage(damage)
	# Handle jump.
	
	
		
	if  Input.is_action_pressed("ui_left") and lastAxis==1 and !Input.is_action_pressed("ui_right"):
		scale.x=-1
		lastAxis=-1
	elif Input.is_action_pressed("ui_right") and lastAxis==-1 and !Input.is_action_pressed("ui_left"):
		scale.x=-1
		lastAxis=1
		
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		jumping=true;
		set_collision_mask_value(4,true)
		set_collision_mask_value(5,false)

	elif global_position.y>=yPosition:
		jumping=false;
		set_collision_mask_value(4,false)
		set_collision_mask_value(5,true)
	elif velocity.y>0 and jumping and !hitting:
		_animated_sprite.play("fall")
	elif jumping and !hitting:
		_animated_sprite.play("jump")
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if direction and (!hitting or jumping):
		if(jumping):
			velocity.x=direction.x*speed
		else:
			velocity=direction*speed
			yPosition=global_position.y


		if !jumping:
			_animated_sprite.play("run")
	else:
		if !jumping and !hitting:
			_animated_sprite.play("idle")
			
		velocity.x = move_toward(velocity.x, 0, speed)
		if(!jumping):
			velocity.y = move_toward(velocity.y, 0, speed)
		
	move_and_slide()
	
func cd_reset():
	can_attack=true;
func animation_cd():
	hitting=false
