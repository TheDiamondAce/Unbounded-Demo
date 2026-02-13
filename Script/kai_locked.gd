extends CharacterBody2D


@onready var Rai =$"../Rai"
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animSprite=$Kai
var isTracking = false
var isAttacking = false
var hp = 100000
@onready var velocityArrow =$velocity


# Rai variable refrences
@export var impVelocity : float
@export var dashTime = .3
@export var cooldownDuration = 0.6
@export var isWeaving = false
@export var lookCollider : CollisionShape2D
@export var arrow_scale: float = 0.25
@export var min_arrow_len: float = 10

var dash_duration = 0
var cooldown = 0
var isdashing = false
var flipped = 1	
var isDucking = false
var isInAir = false
var direction = 0


#Create a raycast or line2d tommorow displaying velocity so its easier to debug knockback etc.
#this script is to make it feel like your the worst at the game, both offensively and defensively.
func _physics_process(delta: float) -> void:
	## queue_redraw()
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
	if area.is_in_group("Player") or area.is_in_group("Player Attack") and !isAttacking:
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
		if area.is_in_group("Player") and area.is_in_group("Player Attack"):		
			isTracking = false	
			animSprite.play("chase")
			print("wait where did he go?")
			
			if !lookCollider.shape.radius <=4500:
				var subtractedRadius : float = lookCollider.shape.radius - 4500
				lookCollider.shape.radius -= subtractedRadius
			await get_tree().create_timer(5.0).timeout
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
	if area.is_in_group("Player Attack"):
		hp_remove(200.0, 1000,45)
	
	pass # Replace with function body.
	


func _on_attack_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		isAttacking = false	
		animSprite.play("chase")
		
		
	pass # Replace with function body.

func hp_remove(amount : float , knockback = null, angle = null, x_pos = null, y_pos = null):
	hp -= amount
	# This if statment is to check if angle and knockback is not being used and is to check if x pos and/or y pos is used
	if angle == null or knockback == null:
		if x_pos != null or y_pos !=null:
			if x_pos == null:
				x_pos = 0
			if y_pos == null:
				y_pos = 0
			velocity = Vector2(x_pos, y_pos)
		velocity == velocity
		
	# This if statment is to check to see if x pos and y pos is not being used and if so, whether angle and knockback is being used?
	else: if x_pos == null and y_pos == null:
		if angle !=null and knockback !=null:
			velocity = Vector2.from_angle(angle) * knockback
			print("DANG I GOT HIT!")
			print(velocity)
	return
	
""" func _draw():
	if velocity.length() <0.1:
		return
	var start_line := Vector2.ZERO
	var end_line := velocity * arrow_scale
	
	if end_line.length() < min_arrow_len:
		end_line = velocity.normalized() * min_arrow_len
	draw_line(start_line,end_line, Color.REBECCA_PURPLE, 3.)
	
	#This is for the head of the arrow so it looks like an arrow.
	var head_len := 12.0
	var head_angle := deg_to_rad(25)
	
	var dir := (end_line-start_line).normalized()
	var left := end_line - dir.rotated(head_angle) * head_len
	var right := end_line - dir.rotated(-head_angle) * head_len
	
	#This line of code is for the head of the arrow
	draw_line(end_line, left, Color.REBECCA_PURPLE, 3)
	draw_line(end_line, right, Color.REBECCA_PURPLE, 3)
	##
"""
	
