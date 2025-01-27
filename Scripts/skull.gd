class_name Skull
extends StaticBody3D


@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D

var is_alive: bool = true


func _ready() -> void:
	animated_sprite.rotation.x = Game.camera.rotation.x


func _process(_delta: float) -> void:
	if is_alive or animated_sprite.is_playing():
		return
	queue_free()


func _on_life_timer_timeout() -> void:
	animated_sprite.play("despawn")
	is_alive = false
