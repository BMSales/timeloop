extends CanvasLayer

@onready var text_box = $container_text
@onready var label = $container_text/MarginContainer/HBoxContainer/text
@export var text: String
@export_range(0.0, 5.0, 0.001) var text_speed: float = 0.0

var is_showing: bool = false
var show_timer: float = text_speed
var can_disable: bool = false

func _ready() -> void:
	hide_textbox()

func hide_textbox() -> void:
	is_showing = false
	label.text = ""
	text_box.hide()

func _process(delta) -> void:
	if show_timer < 0.0:
		can_disable = true
		show_timer = 0.0
	show_timer -= delta

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("interact") and is_showing and can_disable:
		print("disable")
		hide_textbox()

func show_textbox(new_text, speed) -> void:
	can_disable = false
	show_timer = speed
	is_showing = true
	label.text = new_text
	text_box.show()
	var tweener = get_tree().create_tween()
	if speed:
		tweener.tween_property(label, "visible_ratio", 1.0, speed).from(0)
	else:
		tweener.tween_property(label, "visible_ratio", 1.0, text_speed).from(0)
