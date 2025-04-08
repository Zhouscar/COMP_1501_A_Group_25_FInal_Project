extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var area: Area2D = $Area2D


@export var player: Node

func _ready():
	area.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$".".visible = true
		print("player entered")



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$".".visible = false


func _on_add_health_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("health pressed")
		if player and player.has_node("Health"):
			var health = player.get_node("Health") as Health
			health.heal(20)

func _on_add_damage_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("damage pressed")


func _on_add_speed_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("speed pressed")
