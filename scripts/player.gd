extends CharacterBody2D


const SPEED = 300.0
var last_direction: Vector2 = Vector2.DOWN # set default player direction
@export var is_interacting: bool = false
# var hitbox_offset: Vector2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var plant_interact: AudioStreamPlayer2D = $PlantInteract
# @onready var hitbox: Area2D = $Hitbox

func _ready() -> void: # runs once when the game is started
	# initialize hitbox offset
	# hitbox_offset = hitbox.position
	pass

func _physics_process(_delta: float) -> void:
	# disable hitbox until an interaction is triggered 
	# hitbox.monitoring = false
	
	# skip movement if interacting
	if is_interacting:
		velocity = Vector2.ZERO
		return
	
	process_movement()
	process_animation()
	move_and_slide()

func process_movement() -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if (direction != Vector2.ZERO): # player moving in cardinal direction
		velocity = direction * SPEED
		last_direction = direction
		# update_hitbox_offset()
	else: # player is idle
		velocity = Vector2.ZERO

# --------------------------------------------------------
# MOVEMENT & ANIMATION
# --------------------------------------------------------

func process_animation() -> void:
	if is_interacting:
		return
	if velocity != Vector2.ZERO:
		play_animation("run", last_direction)
	else:
		play_animation("idle", last_direction)

func play_animation(prefix: String, dir: Vector2) -> void:
	if dir.x != 0:
		animated_sprite_2d.flip_h = dir.x > 0
		if dir.y != 0: # handle directional animation
			if dir.y < 0:
				animated_sprite_2d.play(prefix + "_upleft")
			else:
				animated_sprite_2d.play(prefix + "_downleft")
		else:
			animated_sprite_2d.play(prefix + "_left")
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + "_up")
	elif dir.y > 0:
		animated_sprite_2d.play(prefix + "_down")

# --------------------------------------------------------
# INTERACTING
# --------------------------------------------------------

func interact() -> void:
	is_interacting = true
	# hitbox.monitoring = true
	# play_animation("interact", last_direction) # no more interact animation.


#func _on_animated_sprite_2d_animation_finished() -> void:
	#if is_interacting:
		#is_interacting = false

# --------------------------------------------------------
# HITBOX
# --------------------------------------------------------

#func update_hitbox_offset() -> void:
	#var x := hitbox_offset.x
	#var y := hitbox_offset.y
	#
	#if last_direction.x != 0 and last_direction.y != 0:
		#var diag_x = y - 0.1
		#var diag_y = y - 0.1
		#if last_direction.x < 0: # facing right
			#diag_x *= -1
		#if last_direction.y < 0: # facing up
			#diag_y *= (-1)
		#hitbox.position = Vector2(diag_x, diag_y)
	#else:
		#match last_direction:
			#Vector2.LEFT:
				#hitbox.position = Vector2(-y, x)
			#Vector2.RIGHT:
				#hitbox.position = Vector2(y, x)
			#Vector2.UP:
				#hitbox.position = Vector2(x, -y)
			#Vector2.DOWN:
				#hitbox.position = Vector2(x, y)
#
#func _on_hitbox_body_entered(body: Node2D) -> void:
	#if is_interacting and body.name.begins_with("dialogue"):
		#plant_interact.play()

# --------------------------------------------------------
# DIALOGUE HANDLING
# --------------------------------------------------------
func _on_dialogue_trigger_dialogue_over() -> void:
	if is_interacting:
		is_interacting = false

func _on_dialogue_trigger_dialogue_start() -> void:
	if !is_interacting:
		is_interacting = true
