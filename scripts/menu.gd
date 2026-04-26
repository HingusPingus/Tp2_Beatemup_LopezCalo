extends Node2D


func _on_jugar_pressed() -> void:
	Global.stage="stage2"

	get_tree().change_scene_to_file("res://scenes/playground.tscn")

func _on_configuracion_pressed() -> void:
	$CenterContainer/Botones.visible =false
	$CenterContainer/Config.visible=true

func _on_salir_pressed() -> void:
	get_tree().quit()

func _on_atras_pressed() -> void:
	$CenterContainer/Botones.visible =true
	$CenterContainer/Config.visible=false
	

func _on_musica_toggled(toggled_on: bool) -> void:
	Global.musica=toggled_on
