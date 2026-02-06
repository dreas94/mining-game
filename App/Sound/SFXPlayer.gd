class_name SFXPlayer
extends Node
## Simple SFX Player
##
## Supports up to MAXIMUM_STREAMS simultaneous sounds.

const MAXIMUM_STREAMS: int = 64

var _streams: Array[Node] = []

func _init(parent: Node) -> void:
	parent.add_child(self)


func play(effect: SoundEffect, pitch_scale: float = 0, fade_start: float = SoundEffect.INVALID, fade_time: float = SoundEffect.INVALID) -> void:
	if _streams.size() == MAXIMUM_STREAMS:
		return
	
	var s: AudioStreamPlayer = AudioStreamPlayer.new()
	_streams.append(s)
	s.finished.connect(_on_stream_finished.bind(s))
	s.volume_db = effect.volume_db
	s.pitch_scale = effect.pitch_scale if pitch_scale == 0 else pitch_scale
	s.stream = effect.stream
	s.bus = effect.bus
	add_child(s)
	s.play()
	var _fade_start: float = fade_start if fade_start != SoundEffect.INVALID else effect.fade_start
	var _fade_time: float = fade_time if fade_time != SoundEffect.INVALID else effect.fade_time
	
	if _fade_start != SoundEffect.INVALID and _fade_time != SoundEffect.INVALID:
		var fade_tween: Tween = create_tween()
		fade_tween.set_ease(Tween.EASE_OUT)
		fade_tween.set_trans(Tween.TRANS_SINE)
		fade_tween.tween_property(s, "volume_db", -100.0, _fade_time).set_delay(_fade_start)
		s.set_meta("tween", fade_tween)


func play_2D(effect: SoundEffect, global_position: Vector2) -> void:
	if _streams.size() == MAXIMUM_STREAMS:
		return
	
	var s: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	_streams.append(s)
	s.finished.connect(_on_stream_finished.bind(s))
	s.volume_db = effect.volume_db
	s.stream = effect.stream
	s.bus = effect.bus
	add_child(s)
	s.global_position = global_position
	s.play()


func play_3D(effect: SoundEffect, global_position: Vector3) -> void:
	if _streams.size() == MAXIMUM_STREAMS:
		return
	
	var s: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	_streams.append(s)
	s.finished.connect(_on_stream_finished.bind(s))
	s.volume_db = effect.volume_db
	s.stream = effect.stream
	s.bus = effect.bus
	add_child(s)
	s.global_position = global_position
	s.play()


func _on_stream_finished(s: Node) -> void:
	if s.has_meta("tween"):
		s.get_meta("tween").kill()
		s.remove_meta("tween")
	if s in _streams:
		_streams.erase(s)
	s.queue_free()
