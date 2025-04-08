class_name Enemy extends Node

# currently only support melee enemies

@export var detection_radius: float = 100;

@export var attack_distance: float = 20;
@export var attack_cooldown: float = 1;
@export var attack_damage: float = 10;

var player_entity: Entity;

var attack_cooldown_timer: float = 0;

func _enter_tree() -> void:
	assert(owner is Entity);
	owner.set_meta(&"Enemy", self);
	player_entity = (owner as Entity).get_player_entity();
	
func can_attack() -> bool:
	return attack_cooldown_timer <= 0;

func _exit_tree() -> void:
	owner.remove_meta(&"Enemy");
	
func get_self_movement() -> PlainMovement:
	return (owner as Entity).get_component("PlainMovement") as PlainMovement;
	
func get_target_position() -> Vector2:
	return (player_entity.get_component("Transform") as Transform).get_transform().get_origin();

func get_target_health() -> Health:
	return player_entity.get_component("Health") as Health;

func get_self_position() -> Vector2:
	return ((owner as Entity).get_component("Transform") as Transform).get_transform().get_origin();	
	
func get_behavior() -> StringName:
	if !(owner as Entity).has_component("Transform"): return "idle";
	if !player_entity.has_component("Transform"): return "idle";
	var target_position = get_target_position();
	var self_position = get_self_position();
	var distance = target_position.distance_to(self_position);
	if distance < attack_distance:
		return "attack";
	elif distance < detection_radius:
		return "follow";
	else:
		return "idle";
		
func process_attack(delta: float):
	attack_cooldown_timer -= delta;
	if get_behavior() != "attack": return;
	if !can_attack(): return;
	attack_cooldown_timer = attack_cooldown;
	var health = get_target_health();
	if health == null: return;
	health.damage(attack_damage);
	
func process_follow(delta: float):
	if get_behavior() != "follow": return;
	var movement = get_self_movement();
	if movement == null: return;
	var target_position = get_target_position();
	movement.move(get_self_position().direction_to(target_position), delta);

func _physics_process(delta: float) -> void:
	process_attack(delta);
	process_follow(delta);
