extends CharacterBody2D

class_name Character

@onready var _animated_sprite = $AnimatedSprite2D
@onready var hitbox = $piña
@onready var alomancy = $alomancy

const speed=300
const JUMP_VELOCITY = -400

var jumping=false
var hitting=false
var get_hit=false
var falling=false
var lying=false

var can_attack=true
var punch_cd=0.25
var hit_cd=0.5
var timer

var damage=50
var combo=0
var health =1000
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
	if(direction):
		dir=direction
	else:
		dir=looking
	if(!drained and pwr==null):
		velocity.x = -speed*dir
	elif pwr:
		print("hola")
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


func take_damage(dmg,direction,drained,char):
	get_hit=true
	combo+=2


	if direction==left and looking==left:
		scale.x=-1
		looking=right
	elif direction==right and looking==right:
		scale.x=-1
		looking=left
	_animated_sprite.play("damage")
	velocity.x=0
	velocity.y=0
	timer=get_tree().create_timer(hit_cd)
	timer.timeout.connect(animation_hit_cd)
	if drain:
		dmg*=2
	health-=dmg	
	if(combo>=3 and !drained and char is Enemy):
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
		var totaldamage=damage
		if(pwrUp):
			totaldamage+=power
			power-=5
		if(drain):
			totaldamage=damage/2
			power+=10
		for i in hitbox.get_overlapping_bodies():
			if(i is Character and i.getZIndex()<=z_index+30 and i.getZIndex()>=z_index-30):
				i.take_damage(totaldamage,looking,drain,i)
			
			
func getZIndex():
	return z_index
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
		for i in alomancy.get_overlapping_bodies():
			if(i is Enemy):
				i.fall(looking*-1,false,power)
				
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
		for i in alomancy.get_overlapping_bodies():
			if(i is Enemy):
				i.fall(looking,false, power)

func changeMode(choice):
	if choice==1:
		pwrUp=false
		drain=true
	elif choice==2:
		pwrUp=true
		drain=false
	else:
		pwrUp=false
		drain=false
		
func getPosition():
	return position
