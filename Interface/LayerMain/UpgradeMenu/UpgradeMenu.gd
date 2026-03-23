class_name iUpgradeMenu
extends Control
const UPGRADE_SCENE: PackedScene = preload("uid://btwucrs8x1cep")

@export var _vbox_container: VBoxContainer


func _ready() -> void:
	visible = false
	for key: String in Content.upgrade_templates.get_names():
		var upgrade_template: UpgradeTemplate = Content.get_upgrade_template(key)
		var upgrade: iUpgrade = UPGRADE_SCENE.instantiate()
		upgrade.fill_data(upgrade_template)
		_vbox_container.add_child(upgrade)


func enable() -> void:
	visible = true


func disable() -> void:
	visible = false
