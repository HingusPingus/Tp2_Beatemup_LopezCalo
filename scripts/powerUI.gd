extends AnimatedSprite2D

var max_power

func _ready() -> void:
	Global.setPower.connect(setPower.bind())
	Global.setMaxPower.connect(setMaxPower.bind())
	
func setPower(power):
	print((power*100/max_power))
	match power*100/max_power:
		var x when x>=0 and x<20:
			play("0%")
		var x when x>=20 and x<40:
			play("20%")
		var x when x>=40 and x<60:

			play("40%")
		var x when x>=60 and x<80:
			play("60%")
		var x when x>=80 and x<100:
			play("80%")
		100:play("100%")
		
func setMaxPower(max_pwr):
	max_power=max_pwr
	print(max_power)
	play("0%")
