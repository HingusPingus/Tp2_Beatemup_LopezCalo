extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
var speed=300
const JUMP_VELOCITY = -400.0
var jumping


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping=true;

		
		if velocity.y>0:
			_animated_sprite.play("fall")
		else:
			_animated_sprite.play("jump")
	var direction := Input.get_axis("ui_left","ui_right")
	if is_on_floor():
		jumping=false;

	if direction:
		if !jumping:
			_animated_sprite.play("run")
		_animated_sprite.flip_h = direction < 0

			
		velocity.x=direction*speed
	else:
		if is_on_floor():
			_animated_sprite.play("idle")
			
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
