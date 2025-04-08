class_name PlayerControls extends Node

@export var body: CharacterBody2D;
@export var collision: CollisionObject2D;

var attack_in_progress = false

func _enter_tree() -> void:
	assert(owner is Entity);
	owner.set_meta(&"PlayerControls", self);

func _exit_tree() -> void:
	owner.remove_meta(&"PlayerControls");

func _process_movement():
	if (!(owner as Entity).has_component("Movement")):
		return;
	var movement = (owner as Entity).get_component("Movement") as Movement;
	
	var direction = getInputDirection();
	movement.move(direction);
	
	if Input.is_key_pressed(KEY_SPACE):
		movement.dash();

func _process_defense():
	if (!(owner as Entity).has_component("Defense")):
		return;
	var defense = (owner as Entity).get_component("Defense") as Defense;
	
	if Input.is_key_pressed(KEY_SHIFT):
		defense.start_defend();
	else:
		defense.stop_defend();

func _process_attack():
	if !(owner as Entity).has_component("PlayerAttack"):
		return;
	
	var attack = (owner as Entity).get_component("PlayerAttack") as PlayerAttack;
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not attack_in_progress:
		attack.attack();
		print("attacked") 
		$"../AnimatedSprite2D".play("attack")
		print($"../AnimatedSprite2D")
		attack_in_progress = true;
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		attack_in_progress = false;

func _physics_process(delta: float) -> void:
	_process_movement();
	_process_defense();
	_process_attack();

func _process(delta: float) -> void:
	_update_player_stats_ui();

func _update_player_stats_ui():
	var stats_label = get_tree().get_current_scene().find_child("PlayerStatsLabel", true, false)
	if stats_label:
		var current_health = 0
		var speed = 0
		var damage = 0

		if owner.has_component("Health"):
			current_health = owner.get_component("Health").current_health

		if owner.has_component("Movement"):
			speed = owner.get_component("Movement").speed

		if owner.has_component("PlayerAttack"):
			var weapon = owner.get_component("PlayerAttack").weapon
			if weapon:
				damage = weapon.damage

		stats_label.text = "Health: %s  |  Speed: %s  |  Damage: %s" % [current_health, speed, damage]

func getInputDirection() -> Vector2:
	var direction = Vector2.ZERO;
	if Input.is_key_pressed(KEY_W):
		direction += Vector2(0, -1);
	if Input.is_key_pressed(KEY_A):
		direction += Vector2(-1, 0);
	if Input.is_key_pressed(KEY_S):
		direction += Vector2(0, 1);
	if Input.is_key_pressed(KEY_D):
		direction += Vector2(1, 0);
		
	if direction.length() > 0:
		return direction.normalized();
	else:
		return Vector2.ZERO;
