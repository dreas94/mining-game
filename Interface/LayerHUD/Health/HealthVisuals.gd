class_name iHealthVisuals
extends Control

@export var health_bar: ProgressBar
@export var damage_bar: ProgressBar


func _ready() -> void:
	visible = false
	Game.state.changed.connect(_on_game_state_changed)
	Mines.health.current_changed.connect(_on_current_health_changed)
	health_bar.max_value = Mines.health.maximum
	health_bar.value = Mines.health.current
	damage_bar.max_value = Mines.health.maximum
	damage_bar.value = Mines.health.current


func _physics_process(delta: float) -> void:
	if health_bar.value == damage_bar.value:
		return
	
	var reduction: float = clampf(damage_bar.value - health_bar.value, 0.0, 20.0 * delta)
	
	damage_bar.value -= reduction


func _on_game_state_changed(_old: SimpleState, new: SimpleState) -> void:
	visible = false
	if new.get_script() in [GameStateMines, GameStateCamp]:
		visible = true
		health_bar.max_value = Mines.health.maximum
		health_bar.value = Mines.health.current
		damage_bar.max_value = Mines.health.maximum
		damage_bar.value = Mines.health.current


func _on_current_health_changed(_previous: float, current: float) -> void:
	health_bar.value = current
