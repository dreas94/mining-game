class_name iIdentityButton
extends CheckButton

var id: String = ""

func _ready() -> void:
	toggled.connect(_on_identity_button_toggled)


func _init(parent: Control, btn_text: String, id_string: String) -> void:
	text = btn_text
	id = id_string
	parent.add_child(self)


func _on_identity_button_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		return
	
	BodyPartCollection.toggle_unlock(id)
