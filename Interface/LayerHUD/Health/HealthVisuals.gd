class_name iHealthVisuals
extends Control

@export var health_bar: ProgressBar
@export var damage_bar: ProgressBar
@export var timer: Timer


func _ready() -> void:
	World.health.current_changed.connect(_on_current_health_changed)
	timer.timeout.connect(_on_timer_timeout)
	health_bar.max_value = World.health.maximum
	health_bar.value = World.health.current
	damage_bar.max_value = World.health.maximum
	damage_bar.value = World.health.current


func _on_current_health_changed(previous: float, current: float) -> void:
	health_bar.value = current
	
	if current < previous:
		timer.start()


func _on_timer_timeout() -> void:
	damage_bar.value = health_bar.value
