class_name GhostOfKhan extends CharacterBody2D

@onready var animSprite = $KhanAnimations
@onready var animationPlayer = $KhanAnimation
@onready var arrowNode = $"../ArrowNode"
@onready var intro = $"../Intro"
@onready var youWin = preload("res://Scene/youWin.tscn")
@export var healthBar : HealthBar
@export var sfx : AudioStreamPlayer2D

@export_category("Sound Effect Audio Variables")
var walking = preload("res://Audio/horsewalking.mp3")
@export var walkTime : Timer

const SPEED = 900 
const JUMP_VELOCITY = -400.0
var currentHealth
var awaitingForControls = false
var isAttacking
signal Attacking
var selfFlip
var flipCountdown = 3
#Hurtbox for the boss is really big so you can actually hit, make 3 modes where one is easy, one is normal, one is hard, for now its easy for easier understanding.
func _ready() -> void:
	youWin = preload("res://Scene/youWin.tscn")
	if awaitingForControls:
		velocity.x =0
	currentHealth = currentHealth
	animSprite.play("Start")
func _physics_process(delta: float) -> void:
	if velocity.x < 0:
		animSprite.flip_h = false
	if velocity.x > 0:
		animSprite.flip_h = true
	if randf() < (1.0/300.0) && !awaitingForControls:
		emitFlip()
	if isAttacking && !awaitingForControls:
		if randf() < (1.0/250.0):
			emitFlip()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if animSprite.animation == "Dash" or animSprite.animation == "Attack":
		
		if walkTime.time_left <=0:
			sfx.pitch_scale = randf_range(0.8,1.2)
			sfx.play()
			walkTime.start(0.5)

	move_and_slide()

func set_health(amount : int):
	currentHealth = amount
	healthBar.set_health(currentHealth)
	healthBar.on_health_changed(currentHealth)

func take_damage(amount : float):
	#fix the fact that if you get hit spammed, boss gets stun locked and its impossible for him to move
	var lastAnimation
	var lastFrame
	var lastVelocity
	print("OW")
	if animSprite.animation != "Hurt":
		lastAnimation = animSprite.animation
	else: if animSprite.animation == "Hurt":
		lastAnimation = "Dash"
	lastFrame = animSprite.frame
	if velocity.x != 0:
		lastVelocity = velocity.x
	else: if velocity.x == 0:
		if animSprite.flip_h == false:
			lastVelocity = -SPEED
		if animSprite.flip_h == true:
			lastVelocity	= SPEED
	velocity.x = 0
	animationPlayer.play("hurt")
	await animationPlayer.animation_finished
	velocity.x = lastVelocity + 500
	animSprite.play(lastAnimation)
	await get_tree().create_timer(1.0)
	velocity.x -=500
	print("BACK ON!")
	animSprite.frame = lastFrame
	
	currentHealth-=amount
	if currentHealth <=0:
		get_tree().call_deferred("change_scene_to_packed", youWin)
		queue_free()
		
		
		
		
		
	healthBar.on_health_changed(currentHealth)
	
func awaitControls(yes : bool):
	if yes:
		awaitingForControls = true	
		animSprite.play("Start")
	if !yes:
		awaitingForControls =false
		animSprite.play("Dash")
		velocity.x = -SPEED
		
func emitFlip():
	velocity.x = -velocity.x
	if getChance():
		animSprite.play("Attack")
		arrowNode.start_attack()
		isAttacking = true
		await get_tree().create_timer(5.0).timeout
		isAttacking = false
	if !getChance() && !isAttacking:
		animSprite.play("Dash")
func getChance() -> bool:
	if !isAttacking:
		return randf() < (1.0/2.0)
	return false
		

	
