extends Node2D


# Application entry point, by this time everything has loaded.
# We can now initialize the first AppState.
func _ready() -> void:
	Logger.hint(self, _ready, "Game boot time = %sms" % Time.get_ticks_msec())
	App.state.enter_state(AppStateBoot.new())
