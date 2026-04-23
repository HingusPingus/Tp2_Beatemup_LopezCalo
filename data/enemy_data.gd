class_name EnemyData
extends Resource

@export var type:Character.Type
@export var global_position:Vector2

func _init(characterType= Character.Type.ENEMY, position=Vector2.ZERO) -> void:
	type=characterType
	global_position=position	
