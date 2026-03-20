extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("restart"):
		var scene = load("res://Scene/Ghost_Of_Khan.tscn")
		if scene:
			get_tree().change_scene_to_packed(scene)
		else:
			print("Scene not loading!")
	pass
