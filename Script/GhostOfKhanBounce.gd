extends Area2D

@onready var ghostOfKhan = $"../../GhostOfKhan"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bouncer_area_entered(area: Area2D) -> void:
	if area.is_in_group("GhostOfKhan"):
		ghostOfKhan.emitFlip()
		return
	
		
