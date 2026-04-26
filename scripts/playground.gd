extends Node2D
class_name Playground

const SCENE_MAP :={
	"stage1":preload("res://scenes/stage_1.tscn"),
	"stage2":preload("res://scenes/stage_2.tscn")
}
const ENEMY_MAP :={
	Character.Type.ENEMY:preload("res://scenes/enemy.tscn"),
	Character.Type.BIGENEMY:preload("res://scenes/big_enemy.tscn"),
	Character.Type.BOSS:preload("res://scenes/boss.tscn")

}
@export var player:Player
func _ready() -> void:

	var scene=SCENE_MAP[Global.stage].instantiate()
	scene.position=Vector2(452.0,-285.0)
	
	add_child(scene)
	move_child(scene,0)
	EntityManager.spawnEnemy.connect(onSpawnEnemy.bind())


func onSpawnEnemy(enemyData):

	var enemy=ENEMY_MAP[enemyData.type].instantiate()
	enemy.global_position=enemyData.global_position
	add_child(enemy)
	enemy.player=player
	

	
