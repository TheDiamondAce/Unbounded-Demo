extends VideoStreamPlayer 

@onready var button =$"../Start"
@onready var title = $"../RichTextLabel"
@onready var level0 =  preload("res://Scene/Ghost_Of_Khan.tscn")
@onready var startScene = $"."
@onready var auraScene = $"../Sprite2D"
@onready var startMusic = $"../StartScreenMusic"
@onready var skipProgress = $"../Skip"

var percentage = 0
var percentageFinal = 2
var started = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	auraScene.show()
	startScene.stop()
	percentage = 0
	skipProgress.hide()
	skipProgress.max_value = percentageFinal
	started = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	skipProgress.value = percentage
	if Input.is_action_pressed("ui_accept") && started:
		skipProgress.show()
		percentage += delta 
	if Input.is_action_just_released("ui_accept"):
		skipProgress.hide()
		percentage = 0
	if skipProgress.value == percentageFinal && started:			
		get_tree().change_scene_to_packed(level0)	
		pass


func _on_button_pressed() -> void:
	button.hide()
	title.hide()
	auraScene.hide()
	startScene.play()
	startMusic.volume_db == -45
	started = true
	
	pass # Replace with function body.
	


func _on_finished() -> void:
	get_tree().change_scene_to_packed(level0)
	pass # Replace with function body.
