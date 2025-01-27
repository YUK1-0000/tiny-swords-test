class_name Goblin
extends Warrior


func search_for_target() -> void:
	var enemies = Game.get_knights() as Array[Knight]
	
	if enemies.is_empty():
		target = null
	else:
		enemies.sort_custom(sort_near)
		target = enemies.front()
