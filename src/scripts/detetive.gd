extends CharacterBody2D
class_name Player

@export_category("Variables")
@export var _move_speed: float = 64.0
@export var tamanho_inv: int = 8

@onready var sprite_2d: Sprite2D = $Sprite2D

var inventario: Array[Item] = []

func _ready() -> void:
	Global.player = self

func _physics_process(_delta: float) -> void:
	move()

func move() -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	velocity = _direction.normalized() * _move_speed
	
	if _direction != Vector2.ZERO:
		sprite_2d.rotation = _direction.angle()
	
	move_and_slide()
	
func kill() -> void:
	Global.map.restart()
