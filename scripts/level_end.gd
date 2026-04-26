extends Area2D

@export var nextscene:String

func _ready() -> void:
	body_entered.connect(on_player_enter.bind())
	
	
func on_player_enter(_player):
	if nextscene!="menu":
		Global.stage=nextscene
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://scenes/win_screen.tscn")

		
