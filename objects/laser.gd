extends Area2D

@export var direction: Vector2 = Vector2.ZERO
@export var speed: float = 400
@export var damage: int = 50

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("get_component"):
		var health = body.get_component("Health")
		if health:
			health.damage(damage)
	queue_free()
