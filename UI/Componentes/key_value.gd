extends HBoxContainer

onready var key_label : Label = $Key
onready var value_label : Label = $Value

func init(key : String, value : String):
	key_label.text = key
	value_label.text = value

func _ready():
	pass
