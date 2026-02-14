class_name Hurtbox extends Area2D

@onready var owner_stats: Stats = owner.stats

func _ready() -> void:
	monitoring = false
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	match owner_stats.team:
		Stats.Team.PLAYER:
			set_collision_layer_value(1,true)
		Stats.Team.ENEMY:
			set_collision_layer_value(2,true)
			
func recieve_hit(damage: int) -> void:
	owner_stats.take_damage(damage)
