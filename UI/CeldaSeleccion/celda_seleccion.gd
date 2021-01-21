extends Node2D

func _ready():
	self.position = Vector2(16,16)

func mover(posicion):
	self.position = posicion
	
