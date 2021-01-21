extends VBoxContainer

onready var titulo_label : Label = $Titulo
var array_items_component = load("res://UI/Componentes/ArrayItem.tscn")

func init(titulo : String, values : Array):
	titulo_label.text = titulo
	for value in values:
		var item = array_items_component.instance()
		self.add_child(item)
		item.init(value)
