@abstract
class_name Character extends CharacterBody2D


@onready var _animated_sprite = $AnimatedSprite2D
@onready var hitbox:Area2D = $piña
@onready var auch:Auch = $auch
@export var speed:int
const JUMP_VELOCITY = -400
@export var type:Type



var jumping=false
var hitting=false
var get_hit=false
var falling=false
var lying=false
var dying=false

var can_attack=true
@export var punch_cd:float
@export var hit_cd:float
var timer

@export var damage:int
var combo=0
@export var max_health:int
@onready var health=max_health
@export var max_power:int
var power=0

var drain=false
var pwrUp=false
var healthy=false

const right=1
const left=-1
var yPosition:float
var looking=right

enum Type{PLAYER,ENEMY,BOSS,BIGENEMY}

func _physics_process(delta: float) -> void:
	if jumping or falling:
		velocity += get_gravity() * delta
	else:
		z_index=position.y
		yPosition=global_position.y

 
		
	if health<=0 and !dying:
		fall(null,false,null)
		dying=true

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
		changeHealth(pwr/2)
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

	elif global_position.y>yPosition-1 or is_on_floor():
		if(falling):
			lying=true
			falling=false
			velocity.x=0
			velocity.y=0

			_animated_sprite.play("lying")

			await get_tree().create_timer(0.5).timeout
			if(health<=0):
				die()
			set_collision_mask_value(4,false)
			set_collision_mask_value(6,true)
			lying=false

		jumping=false
		if(self is Player):
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

	_animated_sprite.play("damage")
	velocity.x=0
	velocity.y=0
	timer=get_tree().create_timer(hit_cd/2)
	timer.timeout.connect(animation_hit_cd)
	if drain:
		dmg*=2
	changeHealth(dmg)
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
		var totaldamage=damage
		if(pwrUp):
			totaldamage=power+damage
			setPower(-5)
		elif(drain):
			totaldamage=damage/2
			setPower(10)
		if hitbox.has_overlapping_areas():
			if healthy and health+damage/2<=max_health:
				changeHealth(-damage/2)
			$"piña/AudioStreamPlayer".play()

		for i in hitbox.get_overlapping_areas():
			if(i is Auch and i.get_parent().getZIndex()<=z_index+30 and i.get_parent().getZIndex()>=z_index-30):
				i.get_parent().take_damage(totaldamage,drain,i)
			
			
func getZIndex():
	return z_index
	
func changeHealth(dmg):
	health-=dmg

func setPower(pwer):
	if(power+pwer<=max_power and power+pwer>=0):
		power+=pwer
	elif( power+pwer>=0):
		power=max_power
	else:
		power=0
	Global.setPower.emit(power)
func pull(alomancy):
	if  can_attack and !falling and !lying and power>=10:
		setPower(-10)
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
				
func push(alomancy):
	if  can_attack and !falling and !lying and power>=10:
		setPower(-10)
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
				
func die():
	queue_free()
	return
