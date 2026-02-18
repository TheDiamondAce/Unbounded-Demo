class_name MyHitbox
extends Area2D 

@export var damage : float

func _init() -> void:
	#Where the hit is from
	collision_layer = 2
	#Where the hit is going to be detected
	collision_mask = 0
	pass
	
