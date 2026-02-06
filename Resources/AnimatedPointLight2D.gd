class_name AnimatedPointLight2D
extends PointLight2D

@export_category("Animation")
@export var images: Array[CompressedTexture2D] = []
@export var duration_per_image: float = 0.0

var index: int = 0
var time_elapsed_for_image = 0.0

func _process(delta: float) -> void:
	if images == null:
		return
	if images.is_empty():
		return
	
	time_elapsed_for_image += delta
	
	if time_elapsed_for_image < duration_per_image:
		return
	
	time_elapsed_for_image -= duration_per_image
	
	index += 1
	if index > images.size() - 1:
		index = 0
	
	texture = images[index]
