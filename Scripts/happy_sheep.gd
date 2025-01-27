class_name HappySheep
extends Character


func handle_animation() -> void:
	if velocity:
		animated_sprite.play("bouncing")
		animated_sprite.flip_h = velocity.x < 0
	else:
		animated_sprite.play("idle")
