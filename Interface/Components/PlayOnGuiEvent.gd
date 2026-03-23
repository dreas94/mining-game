class_name PlayOnGUIEvent
extends Node
## Play on GUI Event
##
## Attach this node to Buttons and other Control nodes to play SoundEffects,
## when the node is hovered, focused, or pressed.

@export var focus_effect: SoundEffect
@export var hover_effect: SoundEffect
@export var pressed_effect: SoundEffect
@export var button_down_effect: SoundEffect
@export var button_up_effect: SoundEffect


func _ready() -> void:
	var parent: Node = get_parent()
	if parent is Control:
		parent.focus_entered.connect(_on_focus_entered)
		parent.mouse_entered.connect(_on_mouse_entered)
	if parent is BaseButton:
		parent.pressed.connect(_on_pressed)
		parent.button_down.connect(_on_button_down)
		parent.button_up.connect(_on_button_up)


func _on_focus_entered() -> void:
	if focus_effect:
		App.sfx.play(focus_effect)


func _on_mouse_entered() -> void:
	if hover_effect:
		App.sfx.play(hover_effect)


func _on_pressed() -> void:
	if pressed_effect:
		App.sfx.play(pressed_effect)


func _on_button_down() -> void:
	if button_down_effect:
		App.sfx.play(button_down_effect)


func _on_button_up() -> void:
	if button_up_effect and get_parent().is_hovered():
		App.sfx.play(button_up_effect)
