class_name Tree_
extends StaticBody3D


@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D


func _ready() -> void:
	animated_sprite.rotation.x = Game.camera.rotation.x
	animated_sprite.flip_h = randi_range(0, 1)
