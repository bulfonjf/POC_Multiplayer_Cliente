extends TextEdit

signal updatear_nombre
var _ignore
func _ready() -> void:
	self.text = "nombre_text_edit"
	emit_signal("updatear_nombre", self.text)
	pass

func obtener_texto():
	return self.get_text()

func _on_nombre_edit_text_changed():
	emit_signal("updatear_nombre", self.text)