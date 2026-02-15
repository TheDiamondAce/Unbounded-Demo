extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if owner.get("stats"):
		owner.stats.health_changed.connect(_on_health_changed)
		_on_health_changed(owner.stats.current_health, owner.stats.health)
	pass # Replace with function body.


func _on_health_changed(_value: int, _max_value: int) -> void:
	max_value = _max_value
	value = _value
