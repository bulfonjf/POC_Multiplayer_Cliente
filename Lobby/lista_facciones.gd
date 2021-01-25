extends OptionButton


func _ready() -> void:
	pass 

func aniadir_facciones(_facciones):
	for faccion in _facciones:
		self.add_item(faccion)
