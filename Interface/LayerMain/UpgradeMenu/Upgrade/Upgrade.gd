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
var _costs: Dictionary[String, int] = {}

func _ready() -> void:
	_buy_button.pressed.connect(_on_buy_button_pressed)
	ItemCollection.item_added.connect(_on_item_count_altered_in_item_collection)
	ItemCollection.item_removed.connect(_on_item_count_altered_in_item_collection)


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
	
	_cost_gauge.max_value = 0.0
	_cost_label.text = ""
	for index: int in range(template.number_of_costs):
		var id: String = template.cost_id[index]
		var cost: int = template.cost_value[index]
		_costs[template.cost_id[index]] = cost
		_cost_gauge.max_value += cost
		_cost_gauge.value = _cost_gauge.max_value
		var quantity: int = ItemCollection.get_number_of_items_by_id(id)
		var new_value: float = _cost_gauge.max_value - quantity
		_cost_gauge.value = clampf(new_value, 0.0, _cost_gauge.max_value)
		_cost_label.text = Content.get_item_template(id).item_name + ": " + str(quantity) + " / " + str(cost)


func _on_item_count_altered_in_item_collection(item_id: String, _new_quantity: int) -> void:
	if not item_id in _costs:
		return
	
	var new_total_value: int = 0
	var first: bool = true
	
	for key: String in _costs:
		if not first:
			_cost_label.text += "\n"
		var id: String = key
		var cost: int = _costs[key]
		var quantity: int = ItemCollection.get_number_of_items_by_id(id)
		var new_value: float = _cost_gauge.max_value - quantity
		new_total_value = clampf(new_value, 0.0, float(cost))
		_cost_label.text = Content.get_item_template(id).item_name + ": " + str(quantity) + " / " + str(cost)
	
	_cost_gauge.value = new_total_value
	
	if _cost_gauge.value > 0.0:
		_buy_button.disabled = true
		_cost_gauge.get_parent().visible = true
	else:
		_buy_button.disabled = false
		_cost_gauge.get_parent().visible = false


func _on_buy_button_pressed() -> void:
	for key: String in _costs:
		if not ItemCollection.check_has_equal_or_more_quantity(key, _costs[key]):
			return
	for key: String in _costs:
		ItemCollection.remove_exact_quantity(key, _costs[key])
	
	var index: int = 0
	for upgrade: Upgrade in _upgrades:
		UpgradeCollection.add_upgrade(_id + "_" + str(index), upgrade)
	
	visible = false
