extends CharacterBody2D
class_name Player

@export_category("Variables")
@export var _move_speed: float = 64.0
@export var tamanho_inv: int = 8

var inventario: Array[Item] = []

func _ready() -> void:
	Global.player = self

func _physics_process(delta: float) -> void:
	_move()

func _move() -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	velocity = _direction.normalized() * _move_speed
	move_and_slide()
	
func kill() -> void:
	print("Player morreu")
	pass
