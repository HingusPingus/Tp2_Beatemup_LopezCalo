extends Node2D

func _process(delta: float) -> void:
	if(Global.musica and !$AudioStreamPlayer.playing):
		$AudioStreamPlayer.play()
