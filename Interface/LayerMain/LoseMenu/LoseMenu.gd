class_name iLoseMenu
extends Menu

@export_group("Buttons")
@export var camp_button: Button
@export var main_menu_button: Button
@export var quit_button: Button
@export_group("Labels")
@export var lose_label: Label


func _ready() -> void:
	camp_button.pressed.connect(_on_camp_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	lose_label.modulate.a = 0.0
	camp_button.visible = false
	main_menu_button.visible = false
	quit_button.visible = false


func _enable() -> void:
	visible = true
	var tween: Tween = create_tween()
	tween.tween_property(lose_label, "modulate:a", 1.0, 2.0)
	tween.tween_interval(1.0)
	tween.tween_property(camp_button, "visible", true, 0.0)
	tween.tween_property(main_menu_button, "visible", true, 0.0)
	tween.tween_property(quit_button, "visible", true, 0.0)


func _disable() -> void:
	visible = false
	lose_label.modulate.a = 0.0
	camp_button.visible = false
	main_menu_button.visible = false
	quit_button.visible = false


func _on_camp_button_pressed() -> void:
	Game.state.enter_state(GameStateCamp.new())
	App.state.enter_state(AppStateGame.new())

func _on_main_menu_button_pressed() -> void:
	Game.state.enter_state(GameStateNone.new())
	
	await get_tree().create_timer(1.0).timeout
	
	App.state.enter_state(AppStateMainMenu.new())


func _on_quit_button_pressed() -> void:
	Game.state.enter_state(GameStateNone.new())
	
	await get_tree().create_timer(1.0).timeout
	
	App.state.enter_state(AppStateQuit.new())
