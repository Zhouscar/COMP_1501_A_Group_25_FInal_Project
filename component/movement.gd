class_name Movement extends Node

@export var body: CharacterBody2D
@export var speed: float = 200
@export var walk_sound: AudioStreamPlayer2D
@export var dash_speed = 200
@export var dash_duration = 0.2
@export var dash_cooldown = 1.0
@export var animator: AnimatedSprite2D

var direction = Vector2.ZERO
var dash_cooldown_timer: float = 0
var is_attacking = false

func state() -> StringName:
	if false:  # dash no longer needs a state timer
		return "dashing"
	elif is_attacking:
		return "attacking"
	elif body.velocity.length() > 0:
		return "moving"
	else:
		return "idle"

func can_move():
	if is_attacking:
		return false
	if (owner as Entity).has_component("Defense"):
		var defense = (owner as Entity).get_component("Defense") as Defense
		if defense.is_defending():
			return false
	return true

func can_dash():
	if is_attacking:
		return false
	if (owner as Entity).has_component("Defense"):
		var defense = (owner as Entity).get_component("Defense") as Defense
		if defense.is_defending():
			return false
	return dash_cooldown_timer <= 0

func _enter_tree() -> void:
	assert(owner is Entity)
	owner.set_meta(&"Movement", self)

func _exit_tree() -> void:
	owner.remove_meta(&"Movement")

func _impulse(vel) -> void:
	body.velocity = vel
	body.move_and_slide()

func _physics_process(delta):
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

func move(dir: Vector2):
	if !can_move():
		return
	direction = dir.normalized()
	var velocity = direction * speed
	_impulse(velocity)

	if animator and direction.x != 0:
		animator.flip_h = direction.x < 0

func dash():
	if !can_dash():
		return

	dash_cooldown_timer = dash_cooldown

	if direction == Vector2.ZERO:
		return  # No input, don't dash

	var dash_offset = direction.normalized() * dash_speed * 0.1  # Adjust dash distance factor
	body.global_position += dash_offset
