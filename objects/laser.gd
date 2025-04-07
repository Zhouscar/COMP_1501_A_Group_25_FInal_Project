extends Node2D

@export var speed: float = 600
var direction: Vector2 = Vector2.ZERO

func _process(delta):
	position += direction * speed * delta
	
