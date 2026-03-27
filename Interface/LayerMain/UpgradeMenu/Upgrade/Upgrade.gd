class_name iUpgrade
extends PanelContainer

@export var _cost_gauge: ProgressBar
@export var _header_label: Label
@export var _information_rich_text_label: RichTextLabel
@export var _upgrade_rich_text_label: RichTextLabel
@export var _cost_label: Label
@export var _buy_button: Button

var _id: String = ""
var _upgrade_name: String = "Upgrade"
var _information: String = "Information"
var _upgrades: Array[Upgrade] = []
var _cost: int = 20

func _ready() -> void:
	_buy_button.pressed.connect(_on_buy_button_pressed)
	ItemCollection.item_added.connect(_on_item_added_to_item_collection)
	ItemCollection.item_removed.connect(_on_item_added_to_item_collection)


func fill_data(template: UpgradeTemplate) -> void:
	_id = template.get_upgrade_id()
	_upgrade_name = template.upgrade_name
	_header_label.text = _upgrade_name
	_information = template.information
	_information_rich_text_label.text = _information
	for index: int in range(template.number_of_upgrade):
		_upgrades.append(Upgrade.new(template.upgrade_type[index], template.upgrade_value_type[index], template.upgrade_value[index]))
	_upgrade_rich_text_label.text = ""
	for upgrade: Upgrade in _upgrades:
		_upgrade_rich_text_label.text += upgrade.get_upgrade_as_string() + "   "
	_cost = template.cost
	_cost_gauge.max_value = _cost
	
	_cost_gauge.value = _cost_gauge.max_value
	var new_value: float = _cost_gauge.max_value - ItemCollection.get_number_of_items_by_id("ore1")
	_cost_gauge.value = clampf(new_value, 0.0, _cost_gauge.max_value)
	
	_cost_label.text = "Cost: " + str(_cost)


func _on_item_added_to_item_collection(item_id: String, new_quantity: int) -> void:
	if item_id != "Ore1":
		return
	
	var new_value: float = _cost_gauge.max_value - new_quantity
	_cost_gauge.value = clampf(new_value, 0.0, _cost_gauge.max_value)
	
	if new_quantity >= _cost_gauge.max_value:
		_buy_button.disabled = false


func _on_item_removed_from_item_collection(item_id: String, new_quantity: int) -> void:
	if item_id != "Ore1":
		return
	
	var new_value: float = _cost_gauge.max_value - new_quantity
	_cost_gauge.value = clampf(new_value, 0.0, _cost_gauge.max_value)
	
	if new_quantity <= _cost_gauge.max_value:
		_buy_button.disabled = true


func _on_buy_button_pressed() -> void:
	if not ItemCollection.remove_exact_quantity("Ore1", _cost):
		return
	
	var index: int = 0
	for upgrade: Upgrade in _upgrades:
		UpgradeCollection.add_upgrade(_id + "_" + str(index), upgrade)
	
	visible = false
