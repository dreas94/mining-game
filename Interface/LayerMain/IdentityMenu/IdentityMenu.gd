class_name iIdentityMenu
extends Control
const IDENTITY_SCENE: PackedScene = preload("uid://btwucrs8x1cep")

@export var _vbox_container: VBoxContainer


func _ready() -> void:
	visible = false


func enable() -> void:
	visible = true


func disable() -> void:
	visible = false
