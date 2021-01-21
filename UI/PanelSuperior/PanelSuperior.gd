extends Panel
onready var panel_superiorHbox: Control = $HBoxPanelSuperior

func _on_BtnPanelSuperior_pressed():
	Ronda.terminar_turno()
	var faccion_activa = Ronda.obtener_faccion_activa()
	panel_superiorHbox.actualizar_panel(faccion_activa)

func _ready() -> void:
	pass 


