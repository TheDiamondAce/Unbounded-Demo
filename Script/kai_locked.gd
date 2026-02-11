extends CharacterBody2D


@onready var Rai =$"../Rai"
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animSprite=$Kai
var isTracking = false
var isAttacking = false


# Rai variable refrences
@export var impVelocity : float
@export var dashTime = .3
@export var cooldownDuration = 0.6
@export var isWeaving = false
@export var lookCollider : CollisionShape2D

var dash_duration = 0
var cooldown = 0
var isdashing = false
var flipped = 1	
var isDucking = false
var isInAir = false
var direction = 0


#this script is to make it feel like your the worst at the game, both offensively and defensively.
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if isdashing:
		dash_duration -= delta
		velocity.x = direction * impVelocity 

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if isTracking:
		direction = (Rai.position-position).normalized().x
	if !isTracking:
		direction = 0
	
	animSprite.flip_h = direction<0
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

func _on_look_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player") and !isAttacking:
		if !lookCollider.shape.radius >= 6500:
			var addedRadius : float = 6500-lookCollider.shape.radius
			lookCollider.shape.radius +=addedRadius
		isTracking = true	
		animSprite.play("Locked")
		print("YOUR IN MY FIELD NOW!!!")
	else:
		isTracking = false
		animSprite.play("Idle")
	pass # Replace with function body.
	



func _on_look_area_exited(area: Area2D) -> void:
		if area.is_in_group("Player"):		
			isTracking = false	
			animSprite.play("chase")
			print("wait where did he go?")
			await get_tree().create_timer(5.0).timeout
			
			if !lookCollider.shape.radius <=4500:
				var subtractedRadius : float = lookCollider.shape.radius - 4500
				lookCollider.shape.radius -= subtractedRadius
			
			animSprite.play("Idle")
		else:
			isTracking = true	
			animSprite.play("Locked")
		pass # Replace with function body.


func _on_attack_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		isAttacking = true
		animSprite.play("Attack")
		print("DIE!! DIE!!")
	
	pass # Replace with function body.
	


func _on_attack_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		isAttacking = false	
		animSprite.play("chase")
		
	pass # Replace with function body.
