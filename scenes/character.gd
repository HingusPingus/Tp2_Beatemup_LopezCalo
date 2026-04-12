extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var hitbox = $piña
var speed=300
const JUMP_VELOCITY = -400.0
var jumping
var can_attack=true
var hitting=false
var timer

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_pressed("melee_attack") and can_attack:
		timer=get_tree().create_timer(0.3)
		timer.timeout.connect(animation_cd)
		hitting=true
		if !jumping:
			_animated_sprite.play("punch")
		else:
			_animated_sprite.play("jump-punch")
		can_attack = false
		timer=get_tree().create_timer(0.5)
		timer.timeout.connect(cd_reset)
		for i in hitbox.get_overlapping_bodies():
			if i.is_in_group("Enemies"):
				i.take_damage(20)
	# Handle jump.
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping=true;
	elif is_on_floor():
		jumping=false;
		
	elif velocity.y>0 and jumping and !hitting:
		_animated_sprite.play("fall")
	elif jumping and !hitting:
		_animated_sprite.play("jump")
	
	var direction := Input.get_axis("ui_left","ui_right")

	if direction and (!hitting or jumping):
		if !jumping:
			_animated_sprite.play("run")
		_animated_sprite.flip_h = direction < 0

			
		velocity.x=direction*speed
	else:
		if is_on_floor() and !hitting:
			_animated_sprite.play("idle")
			
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
	
func cd_reset():
	can_attack=true;
func animation_cd():
	hitting=false
