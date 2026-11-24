class_name AppStateNewGame
extends AppState
## New Game State
##
## Creates a new Save game, then moves to the Game State.
## This is like loading an empty savegame using the Load State.


func enter(_previous_state: SimpleState) -> void:
	# 1. Initialize a Save
	App.save.clear()
	App.save.stage_int("playthrough_start_time", int(Time.get_unix_time_from_system()))
	
	
	BodyPartCollection.add_unlock("GoblinArms", BodyPartConstants.TYPE.ARMS)
	BodyPartCollection.add_unlock("GoblinHead", BodyPartConstants.TYPE.HEAD)
	BodyPartCollection.add_unlock("GoblinLegs", BodyPartConstants.TYPE.LEGS)
	BodyPartCollection.add_unlock("GoblinTorso", BodyPartConstants.TYPE.TORSO)
	
	# 2. Proceed to game state.
	App.state.enter_state(AppStateGame.new())
	entered.emit()
