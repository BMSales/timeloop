extends Node2D
class_name Item

@export_category("Properties")
@export var nome: String = ""
@export var cadeados: Array[Item] = []
@export var removivel: bool = false
@export var letal: bool = false
@export var colidivel: bool = false
@export var disable: bool = false
@export_range(0, 500, 1) var distancia_interacao: float = 200.0
enum Tipo { SEM_TIPO, INVENTARIO, INTERACAO }
@export var tipo: Tipo = Tipo.SEM_TIPO 

@export var arte: Texture2D
@onready var sprite: Sprite2D = $Sprite
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var body_collision_shape: CollisionShape2D = $StaticBody2D/BodyCollisionShape

var interagivel: bool = false
var desenhar_contorno: bool = false
var colecionado: bool = false
var distancia_player: float = 0.0

func TurnCollisionOff() -> void:
	static_body_2d.collision_layer = 0
	static_body_2d.collision_mask = 0
func TurnCollisionOn() -> void:
	static_body_2d.collision_layer = 1
	static_body_2d.collision_mask = 1
func Colecionar() -> void:
	colecionado = true
	Disable()
func Enable() -> void:
	TurnCollisionOn()
	visible = true
func Disable() -> void:
	TurnCollisionOff()
	visible = false
func _ready() -> void:
	if arte:
		sprite.texture = arte
	if !colidivel:
		TurnCollisionOff()
	if disable:
		TurnCollisionOff()
		visible = false
func validarCadeados() -> bool:
	if cadeados.size() == 0:
		return true
	for cadeado in cadeados:
		if !(cadeado in Global.player.inventario):
			return false
	return true
func apagarItemsCadeados() -> void:
	for cadeado in cadeados:
		if cadeado.removivel:
			Global.player.inventario.erase(cadeado)
func interagir() -> void:
	match tipo:
		Tipo.SEM_TIPO:
			assert(false, "Invoked item should have type")
		Tipo.INVENTARIO:
			if Global.player.inventario.size() < Global.player.tamanho_inv and !colecionado and validarCadeados() and Global.hovered == self:
				Global.player.inventario.append(self)
				Colecionar()
		Tipo.INTERACAO:
			if validarCadeados():
				Disable()
				apagarItemsCadeados()
			elif !validarCadeados() and letal:
				Global.player.kill()
func _process(_delta: float) -> void:
	distancia_player = position.distance_to(Global.player.position)
	if distancia_player < distancia_interacao:
		interagivel = true
	else:
		interagivel = false
func _input(event) -> void:
	if event.is_action_pressed("interact") and interagivel:
			interagir()
func _on_mouse_entered() -> void:
	Global.hovered = self
func _on_mouse_exited() -> void:
	Global.hovered = null
