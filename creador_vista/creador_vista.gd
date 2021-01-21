extends Node

# Componentes
const menu_unidad = "menu_unidad"
const menu_lateral_mapa = "menu_lateral_mapa"
const info_unidad = "info_unidad"
const ataque = "ataque"

# Signals
signal mostrar_menu_unidad_signal(_configuracion)
signal mostrar_menu_lateral_mapa_signal(_configuracion)
signal configurar_ataque(_configuracion)

func build(escena):
	emit_signal("mostrar_menu_unidad_signal", escena[menu_unidad])
	emit_signal("mostrar_menu_lateral_mapa_signal", escena[menu_lateral_mapa])
	emit_signal("configurar_ataque", escena[ataque])
