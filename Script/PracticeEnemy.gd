extends Node

@onready var animation_player := $AnimationPlayer
@onready var sprite = $"."
var isDamage=false
var current_health
@export var healthBar : HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = current_health
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isDamage == false:
		animation_player.play("idle")

	pass
	
func take_damage(amount: float) -> void:
	animation_player.play("hurt")
	print("Damage: ", amount)
	isDamage = true
	await get_tree().create_timer(0.25).timeout
	current_health -= amount
	healthBar.on_health_changed(current_health)
	animation_player.play("idle")
	if current_health <=0:
		queue_free()

func set_health(amount : float):
	current_health = amount
	healthBar.set_health(current_health)
