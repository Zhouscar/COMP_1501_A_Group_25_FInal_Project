class_name Health extends Node

@export var current_health: float = 100;
@export var max_health: float = 100;

func is_dead():
	return current_health <= 0;

func get_damage_taken_ratio():
	var ratio = 1;
	if (owner as Entity).has_component("Defense"):
		var defense = (owner as Entity).get_component("Defense") as Defense;
		if defense.is_defending():
			ratio *= defense.defense_ratio;
	return ratio;

func _enter_tree() -> void:
	assert(owner is Entity);
	owner.set_meta(&"Health", self);

func _exit_tree() -> void:
	owner.remove_meta(&"Health");

func damage(amount: float):
	var true_amount = get_damage_taken_ratio() * amount;
	current_health = clamp(current_health - true_amount, 0, max_health);
