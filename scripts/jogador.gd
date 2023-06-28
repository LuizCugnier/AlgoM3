extends CharacterBody2D


const SPEED = 250.0
const AIR_SPEED = 150.0
const JUMP_FORCE = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping := false
var double_jump := true

@onready var animation := $anim as AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false
		double_jump = true
	elif Input.is_action_just_pressed("ui_accept") and not is_on_floor() and is_jumping and double_jump:
		velocity.y = JUMP_FORCE
		double_jump = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction and is_on_floor():
		velocity.x = direction * SPEED
		animation.play("idle")
	elif is_jumping:
		velocity.x = direction * AIR_SPEED
		animation.play("pulo")
	elif not is_on_floor():
		velocity.x = direction * AIR_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	move_and_slide()
