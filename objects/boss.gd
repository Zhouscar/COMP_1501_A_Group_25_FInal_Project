extends Node2D

@onready var gun = $Gun
@onready var label = $Label
@export var laser_scene: PackedScene

var health := 200
var fire_rate := 1.5
var fire_timer := 0.0
var player: Node2D = null

func _ready():
	player = get_tree().get_root().find_node("Player", true, false)
	if not player:
		print("⚠️ Player not found by boss!")

func _process(delta):
	if not player:
		return

	look_at(player.global_position)
	label.text = "Boss HP: %s" % health

	fire_timer += delta
	if fire_timer >= fire_rate:
		fire_timer = 0
		shoot_laser()

func shoot_laser():
	if not laser_scene:
		return

	var laser = laser_scene.instantiate()
	laser.global_position = gun.global_position
	laser.rotation = gun.global_rotation
	laser.direction = Vector2.RIGHT.rotated(global_rotation)
	get_parent().add_child(laser)

func _on_Area2D_area_entered(area):
	if area.name == "Hitbox":
		health -= 50
		print("Boss hit! HP:", health)
		if health <= 0:
			queue_free()
