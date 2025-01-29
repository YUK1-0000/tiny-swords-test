class_name Character
extends CharacterBody3D


@export var max_hp: int = 10
@export var damage: int = 1
@export var speed: float = 1.
@export var max_wait_time: int = 5
@export var min_wait_time: int = 0
@export var max_wander_time: int = 5
@export var min_wander_time: int = 0

@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var label: Label3D = $Label
@onready var wait_timer: Timer = $WaitTimer
@onready var wander_timer: Timer = $WanderTimer

enum States {IDLE, WANDER, CHASE, ATTACK}
var state: States = States.IDLE
var target: Character = null
var current_hp: int = max_hp


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
		set_state(States.WANDER)
	
	elif state != States.ATTACK:
		set_state(States.CHASE)


func handle_velocity() -> void:
	if state != States.WANDER:
		wait_timer.stop()
		wander_timer.stop()
	
	match state:
		States.WANDER:
			if wander_timer.is_stopped() and wait_timer.is_stopped():
				var dir: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
				velocity = Vector3(dir.x, 0, dir.y) * speed
				wander_timer.wait_time = randf_range(min_wander_time, max_wander_time)
				wander_timer.start()
			
			elif not wait_timer.is_stopped():
				velocity = Vector3.ZERO
		
		States.CHASE:
			navigation_agent.target_position = target.global_position
			velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed
			velocity.y = 0
		
		_:
			velocity = Vector3.ZERO


func handle_animation() -> void:
	pass


func apply_gravity() -> void:
	velocity += get_gravity()


func update_label() -> void:
	label.text = str(current_hp) + "\n" + (
		"IDLE" if state == States.IDLE
		else "CHASING" if state == States.CHASE
		else "ATTACK" if state == States.ATTACK
		else "WANDER" if state == States.WANDER
		else ""
	) + "\n" + str(wait_timer.time_left) + "\n" + str(wander_timer.time_left)
	
	#label.text = ""


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


func _on_wait_timer_timeout() -> void:
	pass


func _on_wander_timer_timeout() -> void:
	wait_timer.wait_time = randf_range(min_wait_time, max_wait_time)
	wait_timer.start()
