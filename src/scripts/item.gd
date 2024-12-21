extends Area2D
class_name Item

@export_category("Properties")
@export var cadeados: Array[Item] = []
@export var triggerables: Array[Item] = []
@export var removivel: bool = false
@export var letal: bool = false
@export var colidivel: bool = false
@export var disable: bool = false
@export var destroy: bool = false
@export_range(0, 500, 1) var distancia_interacao: float = 200.0
enum Tipo { SEM_TIPO, INVENTARIO, INTERACAO }
@export var tipo: Tipo = Tipo.SEM_TIPO 
@export var arte: Texture2D

@export_category("Dialogo")
@export var dialogo: bool = false
@export var texto: String = ""
@export var timing: float = 0.0

@onready var sprite: Sprite2D = $Sprite
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var body_collision_shape: CollisionShape2D = $StaticBody2D/BodyCollisionShape

var interagivel: bool = false
var desenhar_contorno: bool = false
var colecionado: bool = false
var distancia_player: float = 0.0

func Trigger() -> void:
	for item in triggerables:
		item.Enable()
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
	monitoring = true
	visible = true
func Disable() -> void:
	TurnCollisionOff()
	monitoring = false
	visible = false
func DisableKeepVisual() -> void:
	monitoring = false
	TurnCollisionOff()
func _ready() -> void:
	#print("Locks array:", cadeados)
	#print("Is lethal:", letal)
	if arte:
		sprite.texture = arte
	if !colidivel:
		TurnCollisionOff()
	if disable:
		TurnCollisionOff()
		visible = false
func validarCadeados() -> bool:
	if cadeados.is_empty() or cadeados.size() == 0:
		#print("No locks on this item.")
		return true
	for cadeado in cadeados:
		if !(cadeado in Global.player.inventario):
			#print("Invalid lock:", cadeado.nome)
			return false
	#print("All locks are valid.")
	return true

func apagarItemsCadeados() -> void:
	for cadeado in cadeados:
		if cadeado.removivel:
			Global.player.inventario.erase(cadeado)
func interagir() -> void:
	#print("Clicked on: ", name)
	match tipo:
		Tipo.SEM_TIPO:
			assert(false, "Invoked item should have type")

		Tipo.INVENTARIO:
			if !validarCadeados() and letal:
				# Handle lethal behavior, but don't restart the scene immediately
				#print("Player killed due to invalid locks!")
				Global.player.kill()
				return  # Stop further execution

			if Global.player.inventario.size() < Global.player.tamanho_inv and !colecionado and validarCadeados() and Global.hovered == self:
				#print("Adding item to inventory")
				Global.player.inventario.append(self)
				Colecionar()
				Trigger()

		Tipo.INTERACAO:
			if validarCadeados():
				#print("Interacting and disabling item")
				Trigger()
				if destroy:
					Disable()
				else:
					DisableKeepVisual()
				apagarItemsCadeados()
			elif !validarCadeados() and letal:
				#print("Player killed during interaction!")
				Global.player.kill()
	
func _process(_delta: float) -> void:
	distancia_player = position.distance_to(Global.player.position)
	if distancia_player < distancia_interacao:
		interagivel = true
	else:
		interagivel = false
func _input(event) -> void:
	if event.is_action_pressed("interact") and interagivel and Global.hovered == self:
		if dialogo:
			Global.player.show_dialogue(texto, timing)
		interagir()
func _on_mouse_entered() -> void:
	Global.hovered = self
	#print("Hovered item set to:", self.nome)
func _on_mouse_exited() -> void:
	#print("Exited hover from:", self.nome)
	if Global.hovered == self:
		Global.hovered = null
