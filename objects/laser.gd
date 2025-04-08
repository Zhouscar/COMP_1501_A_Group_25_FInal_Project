extends Node2D

@export var speed: float = 600
var direction: Vector2 = Vector2.ZERO

func _process(delta):
	position += direction * speed * delta
	
func _ready():
	$Area2D.body_entered.connect(_on_area_2d_body_entered)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_node("Health"):
		var health = body.get_node("Health") as Health
		health.damage(10)
		print(health.current_health)
		print("got damage")
		queue_free()
