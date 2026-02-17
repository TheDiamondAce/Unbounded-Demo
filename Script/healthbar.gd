extends ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_health(amount: float):
	max_value = amount
	

func on_health_changed(_value: int) -> void:
	value = _value
