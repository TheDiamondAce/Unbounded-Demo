extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animSprite = $Rai_Animation 


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		print("moving")
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	animation()
	move_and_slide()	

func animation() -> void:
	#attack animation
	if Input.is_action_just_pressed("attack"):
			animSprite.play("punch")

	#duck animations
	if Input.is_action_pressed("duck"):
		if Input.is_action_just_pressed("attack"):
			animSprite.play("hook")
		else: if Input.is_action_pressed("dodge_left"):
			animSprite.play("duck_left")
		else: if Input.is_action_pressed("dodge_right"):
			animSprite.play("duck_right")
		else:
			animSprite.play("duck")
		
	#weave animations		
	if Input.is_action_pressed("weave"):
		if Input.is_action_just_pressed("attack"):
			animSprite.play("kick")
		else: if Input.is_action_pressed("dodge_left"):
			animSprite.play("weave_left")
		else: if Input.is_action_pressed("dodge_right"):
			animSprite.play("weave_right")
		else:
			animSprite.play("weave")		
	# idle animations
	else: if !Input.is_anything_pressed():
		animSprite.play("idle")
	 
	
