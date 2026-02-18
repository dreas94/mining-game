class_name iMainMenu
extends Menu

@export_group("Buttons")
@export var start_button: Button
@export var controls_button: Button
@export var quit_button: Button
@export_group("Menus")
@export var tab_container: TabContainer
@export var controls_menu: iControlsMenu
@export_group("Background")
@export var background: iBackground



func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	controls_button.pressed.connect(_on_controls_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	controls_menu.closed.connect(_on_controls_menu_closed)
	start_button.text = "Start"
	quit_button.text = "Quit"
	toggle_stuff(false)


func _enable() -> void:
	App.music.play(DefaultMusic.STOCKMAN, 1.0)
	toggle_stuff(true)


func _disable() -> void:
	toggle_stuff(false)


func toggle_stuff(toggle: bool) -> void:
	background.toggle_stuff(toggle)
	visible = toggle


func _on_start_button_pressed() -> void:
	var s: AppStateNewGame = AppStateNewGame.new() 
	App.state.enter_state(s)


func _on_controls_button_pressed() -> void:
	tab_container.current_tab = controls_menu.get_index()


func _on_quit_button_pressed() -> void:
	App.state.enter_state(AppStateQuit.new())


func _on_controls_menu_closed(_result: SubMenu.Result) -> void:
	tab_container.current_tab = 0
