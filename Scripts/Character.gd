class_name Character
extends CharacterBody3D


@export var max_hp: int = 10
@export var damage: int = 1
@export var speed: float = 1.

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var attack_area: Area3D = $AttackArea
@onready var label: Label3D = $Label
@onready var wait_timer: Timer = $WaitTimer
@onready var wander_timer: Timer = $WanderTimer

enum States {WAITING, CHASEING, ATTACKING}
var state: States = States.WAITING
var target: Character = null
var current_hp: int = max_hp
var max_wait_time: int = 5
var min_wait_time: int = 1


func _ready() -> void:
	animated_sprite.rotation.x = Game.camera.rotation.x


func _physics_process(_delta: float) -> void:
	handle_targeting()
	handle_state()
	
	handle_velocity()
	
	handle_animation()
	
	move_and_slide()
	update_label()


func handle_targeting() -> void:
	pass


func handle_state() -> void:
	if target == null:
		set_state(States.WAITING)
	elif state != States.ATTACKING:
		set_state(States.CHASEING)


func handle_velocity() -> void:
	if state == States.CHASEING:
		navigation_agent.target_position = target.global_position
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed
	else:
		velocity = Vector3.ZERO


func handle_animation() -> void:
	pass


func update_label() -> void:
	label.text = str(current_hp) + "\n" + (
		"WAITING" if state == States.WAITING
		else "CHASING" if state == States.CHASEING
		else "ATTACKING"
	)


func set_state(new_state: States) -> void:
	if state == new_state:
		return
	
	state = new_state


func search_for_target() -> void:
	pass


func damage_to(character: Character) -> void:
	character.take_damage(damage)


func take_damage(value: int) -> void:
	current_hp -= value
	
	if current_hp <= 0:
		die()


func die() -> void:
	Game.character_dead.emit(self)
	queue_free()


func sort_near(node_a: Node, node_b: Node) -> bool:
	return (
		global_position.distance_squared_to(node_a.global_position)
		< global_position.distance_squared_to(node_b.global_position)
	)


func nearest_cardinal_direction(direction: Vector2) -> Vector2:
	var rad: float = direction.angle()
	
	if direction == Vector2.ZERO:
		return Vector2.ZERO
	
	if -3*PI/4 <= rad and rad < -PI/4:
		return Vector2.UP
	
	if -PI/4 <= rad and rad < PI/4:
		return Vector2.RIGHT
	
	if PI/4 <= rad and rad < 3*PI/4:
		return Vector2.DOWN
	
	return Vector2.LEFT


func _on_attack_area_body_entered(_body: Node3D) -> void:
	set_state(States.ATTACKING)
