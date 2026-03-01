extends Node2D

var attacking = false
var gravitationalPull = 980
var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if attacking:
		velocity.y = 600
		position.y += velocity.y * delta 
		
func isAttacking(yes: bool):
	if yes:
		attacking = true
	if !yes:
		attacking= false
