class_name PlainMovement extends Node

@export var body: Node2D
@export var speed: float = 20
@export var walk_sound: AudioStreamPlayer2D
@export var animator: AnimatedSprite2D

func _enter_tree() -> void:
	assert(owner is Entity)
	owner.set_meta(&"PlainMovement", self)

func _exit_tree() -> void:
	owner.remove_meta(&"PlainMovement");

func move(dir: Vector2, delta: float):
	var direction = dir.normalized()
	var velocity = direction * speed
	body.global_position += velocity * delta;
	if animator and direction.x != 0:
		animator.flip_h = direction.x < 0
