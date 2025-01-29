class_name Goblin
extends Warrior


func get_enemies() -> Array:
	return Game.get_knights() as Array[Knight]
