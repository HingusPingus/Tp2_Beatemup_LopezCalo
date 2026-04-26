extends ProgressBar

func _ready() -> void:
	Global.setHealthBar.connect(setHealthBar.bind())
	Global.setMaxValue.connect(setMaxValue.bind())
	var sb = StyleBoxFlat.new()
	add_theme_stylebox_override("fill", sb)
	sb.bg_color = Color("00ff00")


func setHealthBar(health):
	value=health
func setMaxValue(max_health):
	max_value=max_health
