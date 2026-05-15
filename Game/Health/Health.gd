extends Node

signal current_changed(previous: float, current: float)
signal reset(amount: float)

const INITIAL: float = 100.0

var current: float:
	get(): return _current
var maximum: float:
	get():
		var health_addition: float = 0.0
		var health_mult: float = 0.0
		for upgrade_id: String in UpgradeCollection.get_upgrades():
			var template: UpgradeTemplate = Content.get_upgrade_template(upgrade_id)
			health_addition += template.health
		for upgrade_id: String in UpgradeCollection.get_upgrades():
			var template: UpgradeTemplate = Content.get_upgrade_template(upgrade_id)
			health_mult += template.health_mult
		return (INITIAL + health_addition) * (1.0 + health_mult)
# used to change how much of current health is 
# recovered when one lose maximum health
var _current: float = INITIAL
var _maximum: float = INITIAL


func add_health(ammount: float) -> void:
	var previous: float = _current
	_current = clamp_health(_current + ammount)
	if previous != _current:
		current_changed.emit(previous, _current)


func sub_health(ammount: float) -> void:
	var previous: float = _current
	_current = clamp_health(_current - ammount)
	if previous != _current:
		current_changed.emit(previous, _current)


func set_health(ammount: float) -> void:
	var previous: float = _current
	_current = clamp_health(ammount)
	if previous != _current:
		current_changed.emit(previous, _current)


func set_maximum(ammount: float) -> void:
	_maximum = ammount


func clamp_health(value: float) -> float:
	return clampf(value, 0, _maximum)


func reset_health(ammount: float = INITIAL) -> void:
	_maximum = ammount
	_current = clamp_health(ammount)
	reset.emit(ammount)
