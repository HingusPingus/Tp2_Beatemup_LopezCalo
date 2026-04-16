extends CharacterBody2D

class_name Character

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
var get_hit=false
var yPosition:float
var combo=0
var health =200
var hit_cd=0.5


func _physics_process(delta: float) -> void:
	if jumping:
		velocity += get_gravity() * delta
	else:
		z_index=position.y
 
		
	if health<=0:
		queue_free()

func cd_reset():
	can_attack=true;
func animation_cd():
	hitting=false

func jump(wannaJump):
	if wannaJump and (position.y==     yPosition):
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
	
func animation_hit_cd():
	if(combo==0):
		get_hit=false
	else:
		combo-=1
func take_damage(damage):
	if (get_hit):
		combo+=1
	get_hit=true
	_animated_sprite.play("damage")

	timer=get_tree().create_timer(hit_cd)
	timer.timeout.connect(animation_hit_cd)
	health -=damage
	print(damage)


func move(direction):
	if direction and (!hitting or jumping):
		if(jumping):
			velocity.x=direction.x*speed
		else:
			velocity=direction*speed
			yPosition=global_position.y


		if !jumping:
			_animated_sprite.play("run")
	else:
		if !jumping and !hitting and !get_hit:
			_animated_sprite.play("idle")
			
		velocity.x = move_toward(velocity.x, 0, speed)
		if(!jumping):
			velocity.y = move_toward(velocity.y, 0, speed)
		
	move_and_slide()
func punch():
	if  can_attack:
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
			i.take_damage(damage)
