class_name MyHurtBox extends Area2D

@export var base_health : float
@export var collisionLayer : int
@export var collisionMask : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#	connect("area_entered", self, _on_area_entered)
		#Layer where HurtBox Lives
	set_collision_layer_value(collisionLayer, true)
	#Layer to get hit on 
	set_collision_mask_value(collisionMask, true)
	self.area_entered.connect(_on_area_entered)
	owner.set_health(base_health)
	
func changeLayer(layer: int) -> void:
	collision_layer = layer
	
func _on_area_entered(hitbox: MyHitbox) -> void:
	if hitbox == null:
		return
		
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
		
