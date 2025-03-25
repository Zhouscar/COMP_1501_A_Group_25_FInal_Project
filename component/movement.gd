class_name Movement extends Node

@export var body: CharacterBody2D;
@export var speed: float = 200;

@export var walk_sound: AudioStreamPlayer2D;

@export var dash_speed = 200;
@export var dash_duration = 0.2;
@export var dash_cooldown = 1.0;

var direction = Vector2.ZERO;

var dash_cooldown_timer: float = 0;
var dash_duration_timer: float = 0;

func state() -> StringName:
	if dash_duration_timer > 0:
		return "dashing";
	elif body.velocity.length() > 0:
		return "moving";
	else:
		return "idle";

func can_move():
	if (owner as Entity).has_component("Defense"):
		var defense = (owner as Entity).get_component("Defense") as Defense;
		if defense.is_defending():
			return;
	return state() != "dashing";
	
func can_dash():
	if (owner as Entity).has_component("Defense"):
		var defense = (owner as Entity).get_component("Defense") as Defense;
		if defense.is_defending():
			return;
	return dash_cooldown_timer <= 0;

func _enter_tree() -> void:
	assert(owner is Entity);
	owner.set_meta(&"Movement", self);

func _exit_tree() -> void:
	owner.remove_meta(&"Movement");
	
func _impulse(vel) -> void:
	body.velocity.x = vel.x;
	body.velocity.y = vel.y;
	body.move_and_slide();

func move(dir: Vector2):
	if !can_move(): return;
	
	direction = dir;
	var velocity = direction * speed;
	_impulse(velocity)
	
func move_to(position: Vector2):
	# used for enemies to target
	if !can_move(): return;

	pass;
	
func dash():
	if !can_dash(): return;
	dash_cooldown_timer = dash_cooldown;
	dash_duration_timer = dash_duration;
	
func _process_walksound():
	walk_sound.position = body.position;
	
	if state() == "moving" && !walk_sound.playing:
		walk_sound.play();
	elif !state() == "moving" && walk_sound.playing:
		walk_sound.stop();
			
func _process_dodge(delta: float):
	dash_cooldown_timer -= delta;
	dash_duration_timer -= delta;

	if state() == "dashing":
		_impulse(direction);
		
func _physics_process(delta: float) -> void:	
	_process_walksound();
	_process_dodge(delta);
