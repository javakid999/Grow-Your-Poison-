extends CharacterBody2D


const SPEED = 300.0
@export var camera: Camera2D

func _physics_process(delta: float) -> void:
	
	var mouse_pos = get_local_mouse_position()
	camera.offset = mouse_pos / 30
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis('ui_up', 'ui_down')
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	global_position = global_position
	move_and_slide()
