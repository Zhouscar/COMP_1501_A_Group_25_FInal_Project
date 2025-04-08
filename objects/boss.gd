extends Node2D

@export var laser_scene: PackedScene
@export var shooting_speed: float = 600
@export var player_path: NodePath
var player: Node2D

@export var detection_radius: float = 200
@export var fire_cooldown: float = 1.0

var can_shoot: bool = true

var player_was_in_radius = false

func _process(delta):
	if player:
		var direction_to_player = player.global_position - global_position
		var distance_to_player = direction_to_player.length()

		$AnimatedSprite2D.flip_h = direction_to_player.x < 0

		if distance_to_player <= detection_radius:
			
			if not player_was_in_radius:
				$RockCrushing.play()
				player_was_in_radius = true

			if can_shoot:
				$AnimatedSprite2D.play("changing")
				shoot_laser_to_player(direction_to_player)

		else:
			player_was_in_radius = false
			$AnimatedSprite2D.play("idle")

func _ready():
	player = get_node(player_path)
	$RayCast2D/ReloadTimer.timeout.connect(_on_reload_timer_timeout)
	$RayCast2D/ReloadTimer.start()


func _on_reload_timer_timeout():
	can_shoot = true


func shoot_laser_to_player(direction_to_player: Vector2):
	
	var distance_to_player = direction_to_player.length()
	if distance_to_player <= detection_radius and can_shoot:
		
		shoot_laser(direction_to_player.normalized())
		can_shoot = false
		
		
		$RayCast2D/ReloadTimer.start()

func shoot_laser(direction: Vector2):
	var laser = laser_scene.instantiate()
	get_parent().add_child(laser)
	laser.global_position = global_position
	laser.direction = direction
	laser.speed = shooting_speed
	
	$LaserSound.play()
