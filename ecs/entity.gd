class_name Entity extends Node

func _enter_tree() -> void:
	add_to_group(&"Entity");
	
func _exit_tree() -> void:
	remove_from_group(&"Entity");

func get_component(component: StringName) -> Node:
	return get_meta(component, null)

func has_component(component: StringName) -> bool:
	return has_meta(component)
