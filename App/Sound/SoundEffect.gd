class_name SoundEffect
extends Resource
## Sound Effect Resource
##
## Used to define configurations on a per effect basis for the SFXPlayer.
const INVALID: float = -1.0
@export var stream: AudioStream
@export var bus: String = "Effects"
@export var volume_db: float = 0.0
@export var pitch_scale: float = 1.0
@export var fade_start: float = INVALID
@export var fade_time: float = INVALID
