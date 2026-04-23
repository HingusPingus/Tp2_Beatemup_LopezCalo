extends Character

class_name Enemy
@onready var player
@onready var areaAgresion=$"piña"
var direction


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health=500
	speed=150
	punch_cd=1
	hit_cd=0.5
	damage=25

	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(player):
		direction=global_position.direction_to(player.global_position)

		if areaAgresion.has_overlapping_areas() or falling or lying:
			for i in areaAgresion.get_overlapping_areas():
				if(i is Auch and i.get_parent().getZIndex()<=z_index+30 and i.get_parent().getZIndex()>=z_index-30):
					direction=Vector2.ZERO
					super.punch()
		#elif areaPersonal.
			#for i in areaPersonal.get_overlapping_bodies():
				#if i is Character and i.getZIndex()<=z_index+30 and i.getZIndex()>=z_index-30 and i!=self:
					#print(pos*(i.global_position.x-global_position.x))

					#if(pos*(i.global_position.x-global_position.x)>0):
						#direction=Vector2.ZERO

		super.jump(false)
		var pos=player.global_position.x-global_position.x

		if(pos<0 and looking==right):
			scale.x=-1
			looking=left
		elif(pos>0 and looking==left):
			scale.x=-1
			looking=right

		super.move(direction)
	
	
	

	
