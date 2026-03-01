extends VideoStreamPlayer

@onready var button =$"../Start"
@onready var title = $"../RichTextLabel"
@onready var level0 =  preload("res://Scene/Ghost_Of_Khan.tscn")
@onready var startScene = $"."
@onready var auraScene = $"../Sprite2D"
@onready var startMusic = $"../StartScreenMusic"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	auraScene.show()
	startScene.stop()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene_to_packed(level0)	
		pass


func _on_button_pressed() -> void:
	button.hide()
	title.hide()
	auraScene.hide()
	startScene.play()
	startMusic.volume_db == -45
	
	pass # Replace with function body.
	


func _on_finished() -> void:
	get_tree().change_scene_to_packed(level0)
	pass # Replace with function body.
