class_name Knight
extends Warrior


func search_for_target() -> void:
	var enemies = Game.get_goblins() as Array[Goblin]
	
	if enemies.is_empty():
		target = null
	else:
		enemies.sort_custom(sort_near)
		target = enemies.front()
