extends Area2D

@export var target: Item = null 
@export var single_use: bool = false
var used: bool = false

@export_category("Dialogo")
@export var dialogo: bool = false
@export var single_use_dialogue: bool = false
var used_dialogue: bool = false
@export var texto: String = ""
@export var timing: float = 0.0

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if dialogo and !single_use_dialogue:
			Global.player.show_dialogue(texto, timing)
		elif single_use_dialogue and !used_dialogue:
			used_dialogue = !used_dialogue
			Global.player.show_dialogue(texto, timing)
		if single_use and !used:
			target.Enable()
			used = !used
			monitoring = false
		elif !single_use:
			target.Enable()
			monitoring = false
