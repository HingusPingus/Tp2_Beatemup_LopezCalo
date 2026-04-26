extends Character
class_name Boss

@onready var enemies=$Enemies
@export var player:Player
@onready var areaAgresion=$"piña"
@onready var alomancy=$"alomancy"
@onready var timerRand=$Timer

var direction
var enemy_data:Array[EnemyData]=[]
var doneFall=false
var movement:Moves
var spawneo=false
enum Moves{PULL,PUSH,PUNCH,MINIONS,IDLE}

func _ready() -> void:
	timerRand.timeout.connect(randomMove)
	timerRand.start()
	movement=Moves.PUNCH
	power=200

	for enemy in enemies.get_children():

		enemy_data.append(EnemyData.new(enemy.type, enemy.global_position))
		enemy.queue_free()


func _physics_process(delta: float) -> void:
	if jumping or falling:
		velocity += get_gravity() * delta
	else:
		z_index=position.y
		yPosition=global_position.y

 
		
	if health<=0:
		fall(null,false,null)

	super.jump(false)

	if(movement==Moves.PULL or movement==Moves.PUSH)and !doneFall:
		pushpull()
	elif(movement==Moves.MINIONS):
		spawnMinions()
	elif(movement==Moves.PUNCH or doneFall):
		punches()
	
	


	
	
	
func pushpull():
		direction=global_position.direction_to(player.global_position)

		if alomancy.has_overlapping_areas() or falling or lying:
			for i in alomancy.get_overlapping_areas():
				if(i is Auch and i.get_parent().getZIndex()<=z_index+30 and i.get_parent().getZIndex()>=z_index-30):
					direction=Vector2.ZERO
					if(movement==Moves.PULL):
						super.pull(alomancy)
					else:
						super.push(alomancy)
					power+=10
					doneFall=true


		var pos=player.global_position.x-global_position.x

		if(pos<0 and looking==right):
			scale.x=-1
			looking=left
		elif(pos>0 and looking==left):
			scale.x=-1
			looking=right

		super.move(direction)
		
func punches():
		direction=global_position.direction_to(player.global_position)

		if areaAgresion.has_overlapping_areas() or falling or lying:
			for i in areaAgresion.get_overlapping_areas():
				if(i is Auch and i.get_parent().getZIndex()<=z_index+30 and i.get_parent().getZIndex()>=z_index-30):
					direction=Vector2.ZERO
					super.punch()


		var pos=player.global_position.x-global_position.x

		if(pos<0 and looking==right):
			scale.x=-1
			looking=left
		elif(pos>0 and looking==left):
			scale.x=-1
			looking=right

		super.move(direction)
func spawnMinions():
	if !spawneo:
		for enemy in enemy_data:
			EntityManager.spawnEnemy.emit(enemy)
		spawneo=true


func randomMove():
		var random=randi()%4
		print (random)
		match random:
			0:movement=Moves.PULL
			1:movement=Moves.PUSH
			2:movement=Moves.PUNCH
			3:
				if !spawneo:
					movement=Moves.MINIONS
			_:
				pass
		spawneo=false
		doneFall=false
