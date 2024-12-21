extends Control

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://cenas/MainMenu.tscn")
