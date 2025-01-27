class_name CharacterSpawner
extends Marker3D


@export var spawnable_scene: PackedScene
@export var spawn_path: NodePath


func spawn() -> void:
	var chara: Character = spawnable_scene.instantiate()
	get_node(spawn_path).add_child(chara)
	chara.global_position = global_position
