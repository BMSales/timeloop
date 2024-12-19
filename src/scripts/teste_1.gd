extends Node2D
class_name Map

func _ready() -> void:
	Global.player.show_dialogue("hello")
	Global.map = self

func restart() -> void:
	get_tree().reload_current_scene()
