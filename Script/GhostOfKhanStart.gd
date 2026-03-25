extends Node2D

@onready var gameplay:= $"."
@onready var intro_anim := $Intro/IntroAnimation
@onready var player =$Rai
@onready var ghostOfKhan = $GhostOfKhan
@onready var intro = $Intro
@onready var title = $Intro/RichTextLabel2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.awaitControls(true)
	ghostOfKhan.awaitControls(true)
	title.show()
	intro_anim.play("start")
	await intro_anim.animation_finished
	player.awaitControls(false)
	ghostOfKhan.awaitControls(false)
	title.hide()
	intro_anim.play("nothing")
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
