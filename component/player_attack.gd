class_name PlayerAttack extends Node

@export var attack_cooldown = 0;
@export var weapon: Weapon;

var attack_cooldown_timer = 0;

func get_melee_hitbox() -> Area2D:
	if weapon == null: return null;
	return weapon.find_child("Hitbox") as Area2D;

func is_melee():
	return get_melee_hitbox() != null;

func can_attack():
	if (owner as Entity).has_component("Defense"):
		var defense = (owner as Entity).get_component("Defense") as Defense;
		if defense.is_defending():
			return false;
	
	if (owner as Entity).has_component("Movement"):
		var movement = (owner as Entity).get_component("Movement") as Movement;
		if movement.state() == "dashing":
			return false;
			
	return attack_cooldown_timer <= 0;

func _enter_tree() -> void:
	assert(owner is Entity);
	owner.set_meta(&"PlayerAttack", self);

func _exit_tree() -> void:
	owner.remove_meta(&"PlayerAttack");

func attack():
	if !can_attack(): return;
	attack_cooldown_timer = attack_cooldown;
	
	if is_melee():
		var hitbox = get_melee_hitbox();
		var collisions = hitbox.get_overlapping_bodies();
		for collision in collisions:
			if collision == owner: continue;
			if !(collision is Entity): continue;
			var entity = collision as Entity;
			if !entity.has_component("Health"): continue;
			var health = entity.get_component("Health") as Health;
			health.damage(weapon.damage);
	
func _process(delta: float) -> void:
	attack_cooldown_timer -= delta;
	
	
