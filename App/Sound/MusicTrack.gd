class_name MusicTrack
extends Resource
## Music Track Resource
##
## Used to define configurations on a per track basis for the MusicPlayer.

@export var stream: AudioStream
@export var bus: String = "Music"
@export var volume_db: float = 0.0
