class_name Warrior
extends Character


func handle_targeting() -> void:
	if state != States.ATTACK:
		search_for_target()


func handle_animation() -> void:
	if state == States.ATTACK:
		var dir: Vector3 = global_position.direction_to(target.global_position)
		var cardinal_dir: Vector2 = nearest_cardinal_direction(Vector2(dir.x, dir.z))
		
		match cardinal_dir:
			Vector2.UP:
				animated_sprite.play("front_attack")
			
			Vector2.DOWN:
				animated_sprite.play("back_attack")
			
			_:
				animated_sprite.play("side_attack")
		
		animated_sprite.flip_h = dir.x < 0
		animation_player.play("attack")
	
	else:
		animation_player.stop()
		
		if velocity:
			animated_sprite.play("walk")
			animated_sprite.flip_h = velocity.x < 0
		else:
			animated_sprite.play("idle")


func attack() -> void:
	damage_to(target)
