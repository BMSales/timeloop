extends Node2D
class_name Item

@export_category("Properties")
@export var item_name: String = "Empty_Name"
@export var cadeados: Array[Item] = []
@export var selecionavel: bool = false
@export var removivel: bool = false
@export var eh_letal: bool = false
@export_range(0.1, 0.1, 100.0) var distancia_interacao: float = 200.0
enum Tipo { SEM_TIPO, INVENTARIO, INTERACAO }
@export var tipo: Tipo = Tipo.SEM_TIPO 

@export var arte: Texture2D
@onready var sprite: Sprite2D = $Sprite

var interagivel: bool = false
var desenhar_contorno: bool = false
var colecionado: bool = false
var distancia_player: float = 0.0

func _ready() -> void:
	if arte:
		sprite.texture = arte
	
func interagir() -> void:
	match tipo:
		Tipo.SEM_TIPO:
			assert(false, "Invoked item should have type")
		Tipo.INVENTARIO:
			if Global.player.inventario.size() < Global.player.tamanho_inv and !colecionado:
				Global.player.inventario.append(self)
				print("Item Removido")
				visible = false
				colecionado = true
				print(Global.player.inventario)
		Tipo.INTERACAO:
			var missing: bool = false
			print(cadeados)
			for cadeado in cadeados:
				if !(cadeado in Global.player.inventario):
					missing = true
			if !missing:
				print("Item Aberto")
				queue_free()
				for cadeado in cadeados:
					if cadeado.removivel:
						Global.player.inventario.erase(cadeado)
			elif missing and eh_letal:
				Global.player.kill()
func _process(delta: float) -> void:
	if desenhar_contorno:
		#Chamar função a qual desenha o contorno do item
		pass


func _on_mouse_entered() -> void:
	print("Mouse")
	if selecionavel:
		assert(Global.player, "Sem player na cena atual. Item nao deveria ser selecionavel!")
		distancia_player = position.distance_to(Global.player.position)
		if distancia_player < distancia_interacao:
			assert(tipo != Tipo.SEM_TIPO, "Um item interagivel nao deveria ser SEM_TIPO!")
			print("In Distance")
			interagivel = true
		else:
			print(distancia_player)
			interagivel = false

func _input(event) -> void:
	if event.is_action_pressed("interact") and interagivel:
			interagir()
	
