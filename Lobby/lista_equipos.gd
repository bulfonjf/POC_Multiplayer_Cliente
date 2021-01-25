extends OptionButton


func _ready() -> void:
	
	pass # Replace with function body.

func aniadir_equipos(_equipos):
	for equipo in _equipos:
		self.add_item(equipo)
