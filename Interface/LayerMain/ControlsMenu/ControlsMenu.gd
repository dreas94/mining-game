class_name iControlsMenu
extends SubMenu

@export_group("Buttons")
@export var return_button: Button

func _ready() -> void:
	return_button.pressed.connect(_on_return_pressed)


func _on_return_pressed() -> void:
	App.settings.reset_to_stored()
	close()
