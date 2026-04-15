extends CharacterBody2D

class_name Enemy

var health =200
var hit_cd=0.1
var get_hit=false
var timer
@onready var _animated_sprite = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale.x=-1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health<=0:
		queue_free()
	if !get_hit:
		_animated_sprite.play("idle")

func take_damage(damage):
	get_hit=true
	_animated_sprite.play("damage")
	timer=get_tree().create_timer(hit_cd)
	timer.timeout.connect(animation_cd)
	health -=damage
	print(damage)

func animation_cd():
	get_hit=false
