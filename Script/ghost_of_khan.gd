class_name GhostOfKhan extends CharacterBody2D

@onready var animSprite = $KhanAnimations
@onready var animationPlayer = $KhanAnimation

@export var healthBar : HealthBar
const SPEED = 0
const JUMP_VELOCITY = -400.0
var currentHealth
var awaitingForControls = false

#Hurtbox for the boss is really big so you can actually hit, make 3 modes where one is easy, one is normal, one is hard, for now its easy for easier understanding.
func _ready() -> void:
	if awaitingForControls:
		velocity.x =0
	currentHealth = currentHealth
	animSprite.play("Start")
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func set_health(amount : int):
	currentHealth = amount
	healthBar.set_health(currentHealth)
	healthBar.on_health_changed(currentHealth)

func take_damage(amount : float):
	animationPlayer.play("hurt")
	currentHealth-=amount
	if currentHealth <=0:
		queue_free()
	healthBar.on_health_changed(currentHealth)
	
func awaitControls(yes : bool):
	if yes:
		awaitingForControls = true	
		animSprite.play("Start")
	if !yes:
		awaitingForControls =false
		animSprite.play("Dash")
		velocity.x = -600
		
func emitFlip():
	velocity.x = -velocity.x
	animSprite.flip_h = !animSprite.flip_h
