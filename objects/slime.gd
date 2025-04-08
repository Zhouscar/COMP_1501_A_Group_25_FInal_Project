extends Node2D


@export var walk_radius: float = 200.0
@export var speed: float = 100.0

var start_position: Vector2
var target_position: Vector2
var reached_target: bool = true

func _ready():
	start_position = global_position
	pick_new_target()

func _process(delta):
	if reached_target:
		pick_new_target()

	var direction = (target_position - global_position)
	if direction.length() < 5.0:
		reached_target = true
	else:
		direction = direction.normalized()
		global_position += direction * speed * delta
		reached_target = false

func pick_new_target():
	var angle = randf() * TAU # to have random anbgle 0 to 2pi
	var distance = randf() * walk_radius
	var offset = Vector2.RIGHT.rotated(angle) * distance
	target_position = start_position + offset


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_node("Health"):
		var health = body.get_node("Health") as Health
		health.damage(5)
		print(health.current_health)
		print("slime damage")
		
