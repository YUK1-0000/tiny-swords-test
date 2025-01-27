extends Node


signal character_dead


const SKULL_SCENE: PackedScene = preload("res://Scenes/skull.tscn")
const VIEWPOINT_SPEED: float = 10
const DAYTIME: int = 15
const NIGHTTIME: int = 15
const TIME_OF_DAY: int = DAYTIME + NIGHTTIME

@onready var main: Node = get_tree().root.get_node("Main")
@onready var navigation_region: NavigationRegion3D = main.get_node("NavigationRegion3D")
@onready var camera: Camera3D = main.get_node("Camera3D")
@onready var knight_warrior_spawners: Node = main.get_node("KnightWarriorSpawners")
@onready var goblin_torch_spawners: Node = main.get_node("GoblinTorchSpawners")
@onready var knights: Node = main.get_node("Knights")
@onready var goblins: Node = main.get_node("Goblins")
@onready var skulls: Node = main.get_node("Skulls")
@onready var happy_sheeps: Node = main.get_node("HappySheeps")
@onready var trees: Node = main.get_node("Trees")
@onready var decorations: Node = main.get_node("Decorations")
@onready var single_day_timer: Timer = main.get_node("SingleDayTimer")
@onready var day_timer: Timer = main.get_node("DayTimer")


func _ready() -> void:
	character_dead.connect(_on_character_dead)
	
	single_day_timer.timeout.connect(sunrise)
	day_timer.timeout.connect(sunset)
	
	single_day_timer.wait_time = DAYTIME + NIGHTTIME
	day_timer.wait_time = DAYTIME
	
	sunrise()


func _physics_process(delta: float) -> void:
	apply_incline()
	
	if Input.is_action_just_pressed("spawn_knight_warrior"):
		spawn_knight_warrior()
	if Input.is_action_just_pressed("spawn_goblin_torch"):
		spawn_goblin_torch()
	
	var input_vec: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_backward"
	)
	
	camera.global_position += Vector3(input_vec.x, 0, input_vec.y) * VIEWPOINT_SPEED * delta


func apply_incline() -> void:
	for obj: Node in get_characters() + skulls.get_children() + trees.get_children():
		obj.animated_sprite.rotation.x = camera.rotation.x
	for deco in decorations.get_children():
		deco.get_node("Sprite3D").rotation.x = camera.rotation.x


func sunrise() -> void:
	day_timer.start()
	
	for spawner in knight_warrior_spawners.get_children():
		spawner.spawn()


func sunset() -> void:
	for spawner in goblin_torch_spawners.get_children():
		spawner.spawn()


func spawn_knight_warrior() -> void:
	knight_warrior_spawners.get_children().pick_random().spawn()


func spawn_goblin_torch() -> void:
	goblin_torch_spawners.get_children().pick_random().spawn()


func get_characters() -> Array:
	return get_knights() + get_goblins() + get_happy_sheeps()


func get_knights() -> Array:
	return knights.get_children()


func get_goblins() -> Array:
	return goblins.get_children()


func get_happy_sheeps() -> Array:
	return happy_sheeps.get_children()


func _on_character_dead(character: Character) -> void:
	var skull: Skull = SKULL_SCENE.instantiate()
	skulls.add_child(skull)
	skull.global_position = character.global_position
	skull.animated_sprite.flip_h = character.animated_sprite.flip_h
