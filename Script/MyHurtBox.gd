class_name MyHurtBox extends Area2D

@export var base_health : float
@export var collisionLayer : int
@export var collisionMask : int
var isSelf
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#	connect("area_entered", self, _on_area_entered)
		#Layer where HurtBox Lives
	set_collision_layer_value(collisionLayer, true)
	#Layer to get hit on 
	set_collision_mask_value(collisionMask, true)
	self.area_entered.connect(_on_area_entered)
	owner.set_health(base_health)
	
	
func _on_area_entered(hitbox: Area2D) -> void:
	if hitbox == null:
		return
		
	if hitbox.owner == self.owner:
		return 
		
	for group in self.owner.get_groups():
		if hitbox.owner.is_in_group(group):
			return
	if hitbox.collision_layer != self.collision_layer:
		return

	if hitbox is MyHitbox || hitbox.collision_mask == self.collisionMask:
		if owner.has_method("take_damage"):
			owner.take_damage(hitbox.damage)
		
func changeLayer(CollisionLayer : int, CollisionMask : int) -> void:
	set_collision_layer_value(collisionLayer, false)
	set_collision_mask_value(collisionMask,false)
	collisionLayer = CollisionLayer
	collisionMask = CollisionMask
	set_collision_layer_value(CollisionLayer, true)
	set_collision_mask_value(CollisionMask, true)
