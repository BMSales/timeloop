extends Node2D
class_name Map

func _ready() -> void:
	Global.map = self

func restart() -> void:
	get_tree().reload_current_scene()
