#StatCollection Autoload Script
extends Node

signal stat_added(stat_id: String, stat: Stats)
signal stat_removed(stat_id: String, stat: Stats)

#Key = statId, data = quantity
var _stats: Dictionary = {} 


func clear() -> void:
	_stats = {}


func add_stat(stat_id: String, new_stat: Stats) -> void:
	_stats[stat_id] = new_stat
	
	stat_added.emit(stat_id, _stats[stat_id])


func remove_stat(stat_id: String) -> void:
	if not stat_id in _stats:
		return
	
	var stat: Stats = _stats[stat_id]
	_stats.erase(stat_id)
	stat_removed.emit(stat_id, stat)
