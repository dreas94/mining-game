class_name iUpgrade
extends PanelContainer

@export var _cost_gauge: ProgressBar
@export var _header_label: Label
@export var _information_rich_text_label: RichTextLabel
@export var _upgrade_rich_text_label: RichTextLabel
@export var _cost_label: Label
@export var _buy_button: Button

var _id: String = ""

func _ready() -> void:
	_buy_button.pressed.connect(_on_buy_button_pressed)
	ItemCollection.item_added.connect(_on_item_count_altered_in_item_collection)
	ItemCollection.item_removed.connect(_on_item_count_altered_in_item_collection)


func fill_data(template: UpgradeTemplate) -> void:
	_id = template.get_upgrade_id()
	_header_label.text = template.upgrade_name
	_information_rich_text_label.text = template.information
	_upgrade_rich_text_label.text = get_stats_text(template)
	
	_cost_gauge.max_value = 0.0
	_cost_label.text = ""
	for index: int in range(template.number_of_costs):
		var id: String = template.cost_id[index]
		var cost: int = template.cost_value[index]
		_cost_gauge.max_value += cost
		_cost_gauge.value = _cost_gauge.max_value
		var quantity: int = ItemCollection.get_number_of_items_by_id(id)
		var new_value: float = _cost_gauge.max_value - quantity
		_cost_gauge.value = clampf(new_value, 0.0, _cost_gauge.max_value)
		_cost_label.text = Content.get_item_template(id).item_name + ": " + str(quantity) + " / " + str(cost)


func _on_item_count_altered_in_item_collection(item_id: String, _new_quantity: int) -> void:
	var template: UpgradeTemplate = Content.get_upgrade_template(_id)
	if not item_id in template.cost_id:
		return
	
	var new_total_value: int = 0
	var first: bool = true
	
	for index: int in range(template.cost_id.size()):
		if not first:
			_cost_label.text += "\n"
		var id: String = template.cost_id[index]
		var cost: int = template.cost_value[index]
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
	var template: UpgradeTemplate = Content.get_upgrade_template(_id)
	for index: int in range(template.cost_id.size()):
		var id: String = template.cost_id[index]
		var cost: int = template.cost_value[index]
		if ItemCollection.check_has_equal_or_more_quantity(id, cost):
			continue
		return
	for index: int in range(template.cost_id.size()):
		var id: String = template.cost_id[index]
		var cost: int = template.cost_value[index]
		ItemCollection.remove_exact_quantity(id, cost)
	
	UpgradeCollection.add_upgrade(_id)
	
	visible = false


func get_stats_text(template: UpgradeTemplate) -> String:
	var stats_text: String = ""
	if template.mining_power != 0.0:
		stats_text += "Mining Power"
		if template.mining_power > 0.0:
			stats_text += " +"
		else:
			stats_text += " -"
		stats_text += str(template.mining_power) + "   "
	if template.mining_power_mult != 0.0:
		stats_text += "Mining Power"
		if template.mining_power_mult > 0.0:
			stats_text += " +"
		else:
			stats_text += " -"
		stats_text += str(template.mining_power_mult * 100.0) + "%   "
	if template.mining_speed != 0.0:
		stats_text += "Mining Speed"
		if template.mining_speed > 0.0:
			stats_text += " +"
		else:
			stats_text += " -"
		stats_text += str(template.mining_speed) + "   "
	if template.mining_speed_mult != 0.0:
		stats_text += "Mining Speed"
		if template.mining_speed_mult > 0.0:
			stats_text += " +"
		else:
			stats_text += " -"
		stats_text += str(template.mining_speed_mult * 100.0) + "%   "
	if template.health != 0.0:
		stats_text += "Health"
		if template.health > 0.0:
			stats_text += " +"
		else:
			stats_text += " -"
		stats_text += str(template.health) + "   "
	if template.health_mult != 0.0:
		stats_text += "Health"
		if template.health_mult > 0.0:
			stats_text += " +"
		else:
			stats_text += " -"
		stats_text += str(template.health_mult * 100.0) + "%   "
	if template.durability != 0.0:
		stats_text += "Durability"
		if template.durability > 0.0:
			stats_text += " +"
		else:
			stats_text += " -"
		stats_text += str(template.durability) + "   "
	if template.durability_mult != 0.0:
		stats_text += "Durability"
		if template.durability_mult > 0.0:
			stats_text += " +"
		else:
			stats_text += " -"
		stats_text += str(template.durability_mult * 100.0) + "%   "
	if template.jump_height != 0.0:
		stats_text += "Jump Height"
		if template.jump_height > 0.0:
			stats_text += " +"
		else:
			stats_text += " -"
		stats_text += str(template.jump_height) + "   "
	if template.jump_height_mult != 0.0:
		stats_text += "Jump Height"
		if template.jump_height_mult > 0.0:
			stats_text += " +"
		else:
			stats_text += " -"
		stats_text += str(template.jump_height_mult * 100.0) + "%   "
	
	return stats_text
