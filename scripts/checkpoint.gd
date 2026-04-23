class_name Checkpoint
extends Node2D

@onready var enemies=$Enemies
@onready var detect=$detectionArea

var enemy_data:Array[EnemyData]=[]
var activado=false

func _ready() -> void:
	detect.body_entered.connect(on_player_enter.bind())
	for enemy in enemies.get_children():
		enemy_data.append(EnemyData.new(enemy.type, enemy.global_position))
		enemy.queue_free()

func _process(_delta: float) -> void:
	if activado and enemy_data.size()>0:
		var enemy=enemy_data.pop_front()
		EntityManager.spawnEnemy.emit(enemy)
	elif(activado):
		queue_free()
		
func on_player_enter(_player):
	if !activado:
		activado=true
