class_name MusicPlayer
extends Node
## Simple Music Player
##
## Supports fading between 2 tracks.

var _player_one: AudioStreamPlayer
var _player_two: AudioStreamPlayer
var _current: int = 0


func _init(parent: Node) -> void:
	parent.add_child(self)
	
	_player_one = AudioStreamPlayer.new()
	_player_two = AudioStreamPlayer.new()
	add_child(_player_one)
	add_child(_player_two)


func play(track: MusicTrack, fade_time: float = 0.5) -> void:
	if _current == 0:
		_fade_to_stop(_player_one, fade_time)
		_fade_to_start(_player_two, fade_time, track)
		_current = 1
	else:
		_fade_to_stop(_player_two, fade_time)
		_fade_to_start(_player_one, fade_time, track)
		_current = 0


func _fade_to_stop(player: AudioStreamPlayer, fade_time: float) -> void:
	var t: Tween = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_SINE)
	t.tween_property(player, "volume_db", -100.0, fade_time)


func _fade_to_start(player: AudioStreamPlayer, fade_time: float, track: MusicTrack) -> void:
	player.volume_db = -100.0
	player.bus = track.bus
	player.stream = track.stream
	
	if not player.playing:
		player.play()
	
	var t: Tween = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_SINE)
	t.tween_property(player, "volume_db", track.volume_db, fade_time)
