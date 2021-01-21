extends Control
#onready var texture : TextureProgress = $TextureProgress
var texture : TextureProgress 

func _ready():
	pass 

func iniciar(unidad):
	texture = $TextureProgress
	texture.max_value = unidad.vida
	self.rect_position = Vector2(-16,8)
	self.actualizar_vida(unidad)
	

func actualizar_vida(unidad):
	texture.value = unidad.vida
	if texture.value < (texture.max_value*0.33):
		texture.tint_progress = "f41d1d"
	elif texture.value < (texture.max_value*0.66) and texture.value > (texture.max_value*0.33):
		texture.tint_progress = "f6ff00"
	else:
		texture.tint_progress = "38ff00"

