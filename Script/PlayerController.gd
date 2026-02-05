extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animSprite = $Rai_Animation 
@export var move:GUIDEAction


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	_animation()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

func _animation() -> void:
	if Input.is_action_pressed("duck") and is_on_floor(): 
		animSprite.play("duck")
	if Input.is_action_just_pressed("attack"):
		animSprite.play("punch")
	if Input.is_action_pressed("attack") && Input.is_action_pressed("duck"):
		animSprite.play("hook")
	if Input.is_action_pressed("weave"):
		animSprite.play("weave")
		
	if Input.is_action_pressed("attack") && Input.is_action_pressed("weave"):
		animSprite.play("kick")
	if !Input.is_anything_pressed():
		animSprite.play("idle")
		

	move_and_slide()
