extends CanvasLayer

@onready var text_box = $container_text
@onready var label = $container_text/MarginContainer/HBoxContainer/text
@export var text: String
@export_range(0.0, 5.0, 0.001) var text_speed: float = 0.0

var is_showing: bool = false

func _ready() -> void:
	hide_textbox()

func hide_textbox() -> void:
	is_showing = false
	label.text = ""
	text_box.hide()

func show_textbox(new_text) -> void:
	is_showing = true
	label.text = new_text
	text_box.show()
	var tweener = get_tree().create_tween()
	tweener.tween_property(label, "visible_ratio", 1.0, text_speed).from(0)
