extends Node

func calcular_danio(actor_activo : Node2D, actor_destino : Node2D):
	var danio = actor_activo.get_unidad().get_ataque() - actor_destino.get_unidad().get_defensa()
	return danio

