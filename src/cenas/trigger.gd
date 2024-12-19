extends Area2D

@export var target: Item = null 

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		target.Activate()
		monitoring = false
