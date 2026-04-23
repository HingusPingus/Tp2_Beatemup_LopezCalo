extends ProgressBar

func _ready() -> void:
	Global.setHealthBar.connect(setHealthBar.bind())
	Global.setMaxValue.connect(setMaxValue.bind())


func setHealthBar(health):
	value=health
func setMaxValue(max_health):
	max_value=max_health
