class_name Defense extends Node

@export var defense_ratio: float = 0.5;

var defending = false;

func _enter_tree() -> void:
	assert(owner is Entity);
	owner.set_meta(&"Defense", self);

func _exit_tree() -> void:
	owner.remove_meta(&"Defense");
	
func is_defending():
	return defending;

func start_defend():
	defending = true;
	
func stop_defend():
	defending = false;
