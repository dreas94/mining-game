class_name iItemInfo
extends HBoxContainer

@export var texture_rect: TextureRect
@export var label: Label

func fill_data(texture: Texture2D, value: int) -> void:
	texture_rect.texture = texture
	label.text = str(value)
