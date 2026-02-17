extends CharacterBody2D

@onready var animSprite = $Rai_Animation 
@onready var animationPlayer =$VisualRoot/FightingFrameData
@onready var visualRoot = $VisualRoot
@onready var myHitbox =$Rai_Animation/MyHitbox
@onready var myHurtBox = $MyHurtBox

@export_category("Dash Variables")
@export var impVelocity : float
@export var dashTime = .3
@export var cooldownDuration : float

@export_category("Stats Variables")
@export var healthBar : ProgressBar

@export_category("Action Variables")
@export var isWeaving = false
@export var comboDuration : float
@export var attackArea : Area2D
#@onready var straightPunch = preload("res://FrameDataSystemV1/Rai/straight_punch.tscn")
#@export var hitbox_shape : CollisionShape2D
#@export var stats : Stats
 
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dash_duration = 0
var cooldown = 0
var isdashing = false
var isAttacking = false
var flipped = 1	
var isDucking = false
var isInAir = false
var isIdle = false
var canAirDash = true
var inputSequence = []	
var comboTimer = 0.0
var direction
var direction_offset = 7
var currentHealth

func _ready() -> void:
	take_damage(50)
	#to test out if healthbar works or not
func _physics_process(delta: float) -> void:
	healthBar.on_health_changed(currentHealth)
	#fix this ungodly hitbox thingy whatever ts is and make it more better. This is just to fix the fact that hitbox doesnt flip properly.
	if animSprite.flip_h == true:
		myHitbox.scale.x = -1
	if animSprite.flip_h == false:
		myHitbox.scale.x = 1
		
	if direction == -1:
		direction_offset = direction*7 - 9
	if direction == 1:
		direction_offset = direction*7
			
	if isAttacking:
		await get_tree().create_timer(.2).timeout
		isAttacking = false
	
	#TEMP TEMP TEMP REMOVE LATER
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_file("res://Scene/Level_0.tscn")
		
	if comboTimer >0:
		comboTimer -= delta
	animation()
	
	direction = Input.get_axis("left", "right")
		
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
	if !isAttacking:
		animationPlayer.play("idle")
	#attack animation
	if Input.is_action_just_pressed("attack") and is_on_floor():
		isAttacking = true
		animationPlayer.play("punch")
		animSprite.play("punch")
			

	#duck animations
	if Input.is_action_pressed("duck"):
		if Input.is_action_just_pressed("attack") and is_on_floor():
			isAttacking = true
			animSprite.play("hook")
			animationPlayer.play("hook")
		else: if Input.is_action_pressed("dodge_left") and !isAttacking:
			animSprite.play("duck_left")
		else: if Input.is_action_pressed("dodge_right") and !isAttacking:
			animSprite.play("duck_right")
		else:
			animSprite.play("duck")
		
	#weave animations		
	if Input.is_action_pressed("weave"):
		isWeaving = true	
		if Input.is_action_just_pressed("attack") and is_on_floor():
			isAttacking = true
			animSprite.play("kick")
			animationPlayer.play("kick")
		else: if Input.is_action_pressed("dodge_left") and !isAttacking:
			animSprite.play("weave_left")
		else: if Input.is_action_pressed("dodge_right") and !isAttacking:
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

func set_health(amount : float):
	currentHealth = amount
	healthBar.set_health(currentHealth)
	
func take_damage(amount: float):
	currentHealth -= amount

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
	if event.is_action_pressed("attack") and not event.is_echo() and is_on_floor():
		"if isWeaving:
			var hitbox = Hitbox.new(stats,straightPunch, direction_offset, 4, .15)
			add_child(hitbox)
		if isDucking:
			var hitbox = Hitbox.new(stats, straightPunch, direction_offset, 10, .15)
			add_child(hitbox)
		if  isIdle:
			var hitbox = Hitbox.new(stats, straightPunch, direction_offset, -6, .15)
			add_child(hitbox)"
	pass 
	
