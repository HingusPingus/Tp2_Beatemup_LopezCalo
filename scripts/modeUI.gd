extends AnimatedSprite2D

func _ready() -> void:
	Global.changeMode.connect(changeMode.bind())


func changeMode(mode):
	match mode:
		1:play("1")
		2:play("2")
		3:play("3")
