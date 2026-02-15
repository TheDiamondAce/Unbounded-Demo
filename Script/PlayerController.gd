extends CharacterBody2D

@onready var animSprite = $Rai_Animation 

@export_category("Dash Variables")
@export var impVelocity : float
@export var dashTime = .3
@export var cooldownDuration : float

@export_category("Hurt Box Variables")
@export var hurtBox : Shape2D

@export_category("Action Variables")
@export var isWeaving = false
@export var comboDuration : float
@export var attackArea : Area2D
@export var hitbox_shape : Shape2D
@export var stats : Stats
 
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dash_duration = 0
var cooldown = 0
var isdashing = false
var flipped = 1	
var isDucking = false
var isInAir = false
var canAirDash = true
var inputSequence = []	
var comboTimer = 0.0

func _physics_process(delta: float) -> void:
	#TEMP TEMP TEMP REMOVE LATER
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_file("res://Scene/Level_0.tscn")
		
	if comboTimer >0:
		comboTimer -= delta
	animation()
	
	var direction := Input.get_axis("left", "right")
		
	if direction:
			velocity.x = direction * SPEED
			animSprite.flip_h =direction<0
			move_and_slide()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		isInAir = true	
	if is_on_floor():
		canAirDash = true
		
	if cooldown > 0:
		cooldown -=delta	
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		record_input("jump")
	if !isdashing and direction !=0:
		flipped = sign(direction)
	if Input.is_action_just_pressed("dash") and cooldown <= 0 and canAirDash:
		start_dash()
		if !is_on_floor() && canAirDash:
			start_dash()
			canAirDash = false
	if isdashing:
		dash_duration -= delta
		velocity.x = flipped * impVelocity
		velocity.y = 0
		
	if dash_duration <0 && isdashing == true:
		end_dash()
		
	else:	
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

		
func start_dash() -> void:
	isdashing = true
	dash_duration = dashTime
	cooldown = cooldownDuration
	
	#makes it more flat, instead of making dash have an arc when jumping.
	velocity.y = min(velocity.y,0)

	
func end_dash() -> void:
	isdashing = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

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
		isWeaving = true	
		if Input.is_action_just_pressed("attack"):
			animSprite.play("kick")
		else: if Input.is_action_pressed("dodge_left"):
			animSprite.play("weave_left")
		else: if Input.is_action_pressed("dodge_right"):
			animSprite.play("weave_right")
		else:
			animSprite.play("weave")
	#CODE IT IN LATER SO THAT IF YOUR WEAVING OR DODGING AND YOU PRESS DASH, IT WILL HAVE THE HOP ANIMATION OR DASH ANIMATION RESPECTIVELY, ELSE FOLLOW THIS CODE. MAKE IT GO THE DIRECTION THE WEAVE IS LEANING OR DUCK IS TOWARDS.
	if isdashing and animSprite.flip_h == true and velocity.x > 0 or isdashing and animSprite.flip_h ==false and velocity.x <0 and !isWeaving and !isDucking:
		animSprite.play("hop")	
		
	else: if isdashing and animSprite.flip_h == true and velocity.x < 0 or isdashing and animSprite.flip_h ==false and velocity.x > 0:
		animSprite.play("dash")	
	# idle animations
	else: if !Input.is_anything_pressed() and is_on_floor():
		animSprite.play("idle")
		
	if velocity.y < 0 and not is_on_floor() and !isdashing:
		animSprite.play("jumping")
	if velocity.y > 0 and not is_on_floor() and !isdashing:
		animSprite.play("falling")


func record_input(action):
	if comboTimer <= 0:
		inputSequence = []
		start_combo_timer()
		inputSequence.append(action)
		print(action)
		print(inputSequence)
		check_combos()
	else: if comboTimer > 0:
		inputSequence.append(action)
		print(action)
		print(inputSequence)
		check_combos()
		
func start_combo_timer():
	comboTimer = comboDuration
	
func check_combos() -> void:
	if inputSequence.size() == 4:
		inputSequence = []
	
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and not event.is_echo():
		var hitbox = Hitbox.new(stats, 0.5, hitbox_shape)
		add_child(hitbox)
	pass 
	
func collider_size():
	if animSprite.animation == "duck":
		hurtBox.scale.y = .68
		hurtBox.scale.x =1
		hurtBox.position= Vector2(-5,22)
		
	if animSprite.animation == "idle":
		hurtBox.position = Vector2(-5,9)
		hurtBox.scale.y = 1
		hurtBox.scale.x = 1
		
	if animSprite.animation == "weave":
		hurtBox.position = Vector2(-13,9)
		hurtBox.scale.x = .5
