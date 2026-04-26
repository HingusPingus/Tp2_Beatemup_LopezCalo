extends Node2D




func _on_reintentar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/playground.tscn")


func _on_volver_al_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
