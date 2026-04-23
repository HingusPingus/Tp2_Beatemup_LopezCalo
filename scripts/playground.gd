extends Node2D

const ENEMY_MAP :={
	Character.Type.ENEMY:preload("res://scenes/enemy.tscn")
}
@export var player:Player
func _ready() -> void:
	EntityManager.spawnEnemy.connect(onSpawnEnemy.bind())


func onSpawnEnemy(enemyData):

	var enemy=ENEMY_MAP[enemyData.type].instantiate()
	enemy.global_position=enemyData.global_position
	add_child(enemy)
	enemy.player=player
