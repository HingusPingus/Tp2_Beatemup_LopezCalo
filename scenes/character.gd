extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var hitbox = $piña
var speed=300
const JUMP_VELOCITY = -400.0
var jumping
var hit_cd=0.25
var can_attack=true
var hitting=false
var timer
var damage=50
var lastAxis=1
var yPosition:float

func _physics_process(delta: float) -> void:
	if position.y>yPosition:
		velocity += get_gravity() * delta
		
	if Input.is_action_pressed("melee_attack") and can_attack:
		timer=get_tree().create_timer(hit_cd)
		timer.timeout.connect(animation_cd)
		hitting=true
		if !jumping:
			_animated_sprite.play("punch")
		else:
			_animated_sprite.play("jump-punch")
		can_attack = false
		timer=get_tree().create_timer(hit_cd)
		timer.timeout.connect(cd_reset)
		for i in hitbox.get_overlapping_bodies():
			if i is Enemy:
				i.take_damage(damage)
	# Handle jump.
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping=true;
	elif is_on_floor():
		jumping=false;
		
	if Input.is_action_just_pressed("ui_left") and lastAxis==1:
		scale.x=-1
		lastAxis=-1
		
	if Input.is_action_just_pressed("ui_right") and lastAxis==-1:
		scale.x=-1
		lastAxis=1
		
	elif velocity.y>0 and jumping and !hitting:
		_animated_sprite.play("fall")
	elif jumping and !hitting:
		_animated_sprite.play("jump")
	var directiony := Input.get_axis("ui_up", "ui_down")
	var directionx := Input.get_axis("ui_left","ui_right")
	
	if directiony and(!hitting):
		velocity.y=directiony*speed
		yPosition=position.y
	
	if directionx and (!hitting or jumping):
		if !jumping:
			_animated_sprite.play("run")
		velocity.x=directionx*speed
	else:
		if is_on_floor() and !hitting:
			_animated_sprite.play("idle")
			
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
	
func cd_reset():
	can_attack=true;
func animation_cd():
	hitting=false
