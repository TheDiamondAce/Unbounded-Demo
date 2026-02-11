extends CharacterBody2D


@onready var animSprite = $Rai_Animation 
@export var impVelocity = 1500
@export var dashTime = .3
@export var cooldownDuration = 0.6

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dash_duration = 0
var cooldown = 0
var isdashing = false
var flipped = 1	
var reload =preload("res://Scene/Level_0.tscn")
@export var isWeaving = false
var isDucking = false
var isInAir = false

func _physics_process(delta: float) -> void:
	#TEMP TEMP TEMP REMOVE LATER
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_packed(reload)
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
		
		
	if cooldown > 0:
		cooldown -=delta	
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if !isdashing and direction !=0:
		flipped = sign(direction)
	if Input.is_action_just_pressed("dash") and cooldown <= 0:
		start_dash()
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
