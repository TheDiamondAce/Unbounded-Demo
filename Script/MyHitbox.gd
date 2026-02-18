class_name MyHitbox
extends Area2D 

@export_range (1,32,1) var collisionLayer: int
@export_range(1,32,1) var collisionMask : int

@export var damage : float

func _ready() -> void:
	#Where the hit is from
	set_collision_layer_value(collisionLayer, true)
	#Where the hit is going to be detected
	set_collision_mask_value(collisionMask, true)
	pass
	
