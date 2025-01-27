class_name HUD
extends Control


@onready var mesh_instance: MeshInstance2D = $MeshInstance2D


func _physics_process(_delta: float) -> void:
	mesh_instance.rotation = 2*PI * (Game.single_day_timer.time_left / Game.single_day_timer.wait_time - 1)
