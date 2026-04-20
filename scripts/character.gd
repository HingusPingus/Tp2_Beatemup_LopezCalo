extends CharacterBody2D

class_name Character

@onready var _animated_sprite = $AnimatedSprite2D
@onready var hitbox = $piña
@onready var alomancy = $alomancy
const speed=300
var power=0
var drain=true
var pwrUp=false
const JUMP_VELOCITY = -400
var jumping=false
const right=1
const left=-1
var punch_cd=0.25
var can_attack=true
var hitting=false
var timer
var damage=50
var get_hit=false
var yPosition:float
var combo=0
var health =32493284382432
var hit_cd=0.5
var falling=false
var lying=false
var looking=right

func _physics_process(delta: float) -> void:
	if jumping or falling:
		velocity += get_gravity() * delta
	else:
		z_index=position.y
		yPosition=global_position.y

 
		
	if health<=0:
		queue_free()

func cd_reset():
	can_attack=true;
func animation_cd():
	hitting=false
	

func fall(direction,pos):
	if(direction):
		looking=direction
	if(!pos and drain):
		velocity.x = (-move_toward(global_position.x, global_position.x, power))*looking
	else:
		velocity.x = (-move_toward(global_position.x, pos, speed))*looking
	falling=true;
	_animated_sprite.play("fall_down")
	velocity.y =-200
func jump(wannaJump):
	if wannaJump and (global_position.y==yPosition):
		velocity.y = JUMP_VELOCITY
		jumping=true;
		set_collision_mask_value(4,true)
		set_collision_mask_value(5,false)

	elif global_position.y>=yPosition:
		if(falling):
			lying=true
			falling=false
			velocity.x=0
			velocity.y=0
			_animated_sprite.play("lying")

			await get_tree().create_timer(0.5).timeout
			lying=false

		jumping=false
		set_collision_mask_value(4,false)
		set_collision_mask_value(5,true)
	elif velocity.y>0 and jumping and !hitting:
		_animated_sprite.play("fall")
	elif jumping and !hitting:
		_animated_sprite.play("jump")
	
func animation_hit_cd():
	
	if(combo):
		combo-=1
		get_tree().create_timer(0.5).timeout
		combo-=1

	if(combo==0):
		get_hit=false


func take_damage(damage,direction):
	get_hit=true
	combo+=2
	looking=-direction
	scale.x=looking
		
	_animated_sprite.play("damage")
	velocity.x=0
	velocity.y=0
	timer=get_tree().create_timer(hit_cd)
	timer.timeout.connect(animation_hit_cd)
	if(pwrUp):
		health -=damage+(power/10)
		power-=20
	elif(drain):
		if(looking==right):
			power+=40
	else:
		health-=damage	
	if(combo>=3):
		fall(null,null)


func move(direction):
	if not(falling or lying):
		if direction and (!hitting or jumping):
			if(jumping):
				velocity.x=direction.x*speed
			else:
				velocity=direction*speed

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
	if  can_attack and !falling and !lying:
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
			i.take_damage(damage,looking)
			
			
func pull():
	if  can_attack and !falling and !lying:
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
	if(looking==left):
		for i in alomancy.get_overlapping_bodies():
			if(i is Enemy):
				i.fall(left,global_position.x)
	else:
		for i in alomancy.get_overlapping_bodies():
			if(i is Enemy):
				i.fall(right,global_position.x)
				
func push():
	if  can_attack and !falling and !lying:
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
	if(looking==left):
		for i in alomancy.get_overlapping_bodies():
			if(i is Enemy):
				i.fall(right,global_position.x)
	else:
		for i in alomancy.get_overlapping_bodies():
			if(i is Enemy):
				i.fall(left,global_position.x)
