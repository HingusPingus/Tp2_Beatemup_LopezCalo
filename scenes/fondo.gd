extends Node2D

func _ready() -> void:
	if(Global.musica):
		$AudioStreamPlayer.play()
