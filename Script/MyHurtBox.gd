class_name MyHurtBox extends Area2D

@export var base_health : float

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	collision_layer = 0
	collision_mask = 2
	
func _ready() -> void:
	#	connect("area_entered", self, _on_area_entered)
	self.area_entered.connect(_on_area_entered)
	owner.set_health(base_health)
	
func _on_area_entered(hitbox: MyHitbox) -> void:
	if hitbox == null:
		return
		
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
		
