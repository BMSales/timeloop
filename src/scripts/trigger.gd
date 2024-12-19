extends Area2D

@export var target: Item = null 
@export var single_use: bool = false
var used: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if single_use and !used:
			target.Enable()
			monitoring = false
		elif !single_use:
			target.Enable()
			monitoring = false
