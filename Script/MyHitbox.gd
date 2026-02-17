class_name MyHitbox
extends Area2D 

@export var damage : float

func _init() -> void:
	collision_layer = 2
	collision_mask = 0
	pass
	
