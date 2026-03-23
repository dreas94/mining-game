class_name Stats
extends RefCounted

var stats_type: StatsConstants.TYPE
var stats_value_type: StatsConstants.VALUE_TYPE
var value: float

func _init(new_stats_type: StatsConstants.TYPE, new_stats_value_type: StatsConstants.VALUE_TYPE, new_value: float) -> void:
	stats_type = new_stats_type
	stats_value_type = new_stats_value_type
	value = new_value


func get_stats_as_string() -> String:
	var string_name: String = ""
	match stats_type:
		StatsConstants.TYPE.DAMAGE:
			string_name = "Damage"
		StatsConstants.TYPE.HEALTH:
			string_name = "Health"
	
	var post_value_string: String = ""
	
	match stats_value_type:
		StatsConstants.VALUE_TYPE.PERCENTAGE:
			post_value_string = "%"
		_:
			post_value_string = ""
	if value > 0:
		return string_name + " +" + str(value) + post_value_string
	else:
		return string_name + " -" + str(value) + post_value_string
