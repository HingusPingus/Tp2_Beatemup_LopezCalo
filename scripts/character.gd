extends CharacterBody2D

class_name Character

@onready var _animated_sprite = $AnimatedSprite2D
@onready var hitbox:Area2D = $piña
@onready var auch:Auch = $auch
var speed
const JUMP_VELOCITY = -400

var jumping=false
var hitting=false
var get_hit=false
var falling=false
var lying=false

var can_attack=true
var punch_cd
var hit_cd
var timer

var damage
var combo=0
var health
var power=0

var drain=false
var pwrUp=false

const right=1
const left=-1
var yPosition:float
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
	

func fall(direction,drained,pwr):
	var dir
	set_collision_mask_value(4,true)
	set_collision_mask_value(6,false)
	
	if(direction):
		dir=direction
	else:
		dir=looking
	if(!drained and pwr==null):
		velocity.x = -speed*dir
	elif pwr:
		velocity.x = (speed+pwr)*dir
	falling=true;
	yPosition = global_position.y + 1
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
			set_collision_mask_value(4,false)
			set_collision_mask_value(6,true)
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
		await get_tree().create_timer(hit_cd/2).timeout
		combo-=1

	if(combo==0):
		get_hit=false


func take_damage(dmg,drained,pj):
	get_hit=true
	combo+=2
	print("hit")

	_animated_sprite.play("damage")
	velocity.x=0
	velocity.y=0
	timer=get_tree().create_timer(hit_cd/2)
	timer.timeout.connect(animation_hit_cd)
	if drain:
		dmg*=2
	health-=dmg	
	if(combo>=3 and !drained and pj.get_parent() is Enemy):
		fall(null,drained,null)


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
			if (!jumping and !hitting and !get_hit):
				_animated_sprite.play("idle")
			velocity.x = move_toward(velocity.x, 0, speed)
			if(!jumping):
				velocity.y = move_toward(velocity.y, 0, speed)
	move_and_slide()
		
func punch():
	if  can_attack and !falling and !lying:
		timer=get_tree().create_timer(0.25)
		timer.timeout.connect(animation_cd)
		hitting=true
		if !jumping:
			_animated_sprite.play("punch")
		else:
			_animated_sprite.play("jump-punch")
		can_attack = false
		timer=get_tree().create_timer(punch_cd)
		timer.timeout.connect(cd_reset)
		var totaldamage
		if(pwrUp):
			totaldamage=power
			power-=5
		elif(drain):
			totaldamage=damage/2
			power+=10
		else:
			totaldamage=damage
		for i in hitbox.get_overlapping_areas():
			if(i is Auch and i.get_parent().getZIndex()<=z_index+30 and i.get_parent().getZIndex()>=z_index-30):
				i.get_parent().take_damage(totaldamage,drain,i)
			
			
func getZIndex():
	return z_index
