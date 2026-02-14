class_name ComboCreator extends Node2D

var inputSequence = []
@onready var lastButtonPressed = $ButtonPressed
@onready var comboList = $ComboList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("left"):
		record_input("left")
	if Input.is_action_just_pressed("right"):
		record_input("right")
	if Input.is_action_just_pressed("jump"):
		record_input("jump")
	if Input.is_action_just_pressed("dash"):
		record_input("dash")
	if Input.is_action_just_pressed("attack"):
				record_input("punch")

	#duck animations
	if Input.is_action_pressed("duck"):
		if Input.is_action_just_pressed("attack"):
			record_input("hook")
		else: if Input.is_action_just_pressed("dodge_left"):
			record_input("duck_left")
		else: if Input.is_action_just_pressed("dodge_right"):
			record_input("duck_right")
		else: if Input.is_action_just_pressed("duck"):
			record_input("duck")
		
	#weave animations		
	if Input.is_action_pressed("weave"):
		if Input.is_action_just_pressed("attack"):
			record_input("kick")
		else: if Input.is_action_just_pressed("dodge_left"):
			record_input("weave_left")
		else: if Input.is_action_just_pressed("dodge_right"):
			record_input("weave_right")
		else: if Input.is_action_just_pressed("weave"):
			record_input("weave")
		pass
		
		
func record_input(action):
		inputSequence.append(action)
		print(action)

		print(inputSequence)
		if inputSequence.size() == 4:
			var joined_string := "+ ".join(inputSequence) 
			joined_string = "  [" + joined_string + "]  "
			comboList.text += " " + joined_string
			inputSequence =  []
