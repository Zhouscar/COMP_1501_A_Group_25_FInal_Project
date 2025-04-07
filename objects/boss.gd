extends Node2D

var max_health: int = 1000
var health: int = max_health

@export var player: Node2D
@export var laser_scene: PackedScene  # Drag Laser.tscn here
@export var fire_radius: float = 400
@export var fire_cooldown: float = 1.5

var time_since_last_shot: float = 0

func _process(delta):
	if player:
		look_at(player.global_position)
		$Label.text = str(health)

		var distance_to_player = global_position.distance_to(player.global_position)
		time_since_last_shot += delta

		if distance_to_player <= fire_radius and time_since_last_shot >= fire_cooldown:
			fire_laser()
			time_since_last_shot = 0

func fire_laser():
	var laser = laser_scene.instantiate()
	var direction = (player.global_position - global_position).normalized()

	# spawn a little bit in front of the boss
	laser.global_position = global_position + direction * 20

	# pass direction and rotate it
	laser.direction = direction
	laser.rotation = direction.angle()

	get_tree().current_scene.add_child(laser)
