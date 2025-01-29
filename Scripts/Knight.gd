class_name Knight
extends Warrior


func get_enemies() -> Array:
	return Game.get_goblins() as Array[Goblin]
