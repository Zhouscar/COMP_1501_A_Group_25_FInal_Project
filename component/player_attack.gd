class_name PlayerAttack extends Node

@export var weapon: Weapon

var attack_cooldown_timer = 0.0
var is_attacking = false

func get_melee_hitbox() -> Area2D:
	if weapon == null:
		return null
	return weapon.find_child("Hitbox") as Area2D

func is_melee():
	return get_melee_hitbox() != null

func can_attack():
	if is_attacking:
		return false
	if (owner as Entity).has_component("Defense"):
		var defense = (owner as Entity).get_component("Defense") as Defense
		if defense.is_defending():
			return false
	if (owner as Entity).has_component("Movement"):
		var movement = (owner as Entity).get_component("Movement") as Movement
		if movement.state() == "dashing":
			return false
	return attack_cooldown_timer <= 0.0

func _enter_tree() -> void:
	assert(owner is Entity)
	owner.set_meta(&"PlayerAttack", self)

func _exit_tree() -> void:
	owner.remove_meta(&"PlayerAttack")

func _physics_process(delta):
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer -= delta

func attack():
	if !can_attack():
		return

	attack_cooldown_timer = weapon.attack_cooldown;
	is_attacking = true

	# Notify movement system
	if (owner as Entity).has_component("Movement"):
		var movement = (owner as Entity).get_component("Movement") as Movement
		movement.is_attacking = true

	# Play animation and connect finished signal
	if owner.has_node("AnimatedSprite2D"):
		var sprite = owner.get_node("AnimatedSprite2D") as AnimatedSprite2D
		sprite.play("attack")

		# Ensure only one connection
		if sprite.is_connected("animation_finished", Callable(self, "_on_attack_animation_finished")):
			sprite.disconnect("animation_finished", Callable(self, "_on_attack_animation_finished"))

		sprite.connect("animation_finished", Callable(self, "_on_attack_animation_finished"), CONNECT_ONE_SHOT)

	# Deal damage
	if is_melee():
		var hitbox = get_melee_hitbox()
		var collisions = hitbox.get_overlapping_bodies()
		for collision in collisions:
			if collision == owner:
				continue
			if !(collision.get_parent() is Entity):
				continue
			var entity = collision.get_parent() as Entity;
			if !entity.has_component("Health"):
				continue
			var health = entity.get_component("Health") as Health
			health.damage(weapon.damage)

func _on_attack_animation_finished():
	if not owner.has_node("AnimatedSprite2D"):
		return

	var sprite = owner.get_node("AnimatedSprite2D") as AnimatedSprite2D

	# Only reset if animation is still set to attack (avoids conflicts)
	if sprite.animation == "attack":
		is_attacking = false
		if (owner as Entity).has_component("Movement"):
			var movement = (owner as Entity).get_component("Movement") as Movement
			movement.is_attacking = false
		sprite.play("idle")
