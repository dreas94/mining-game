class_name AppStateQuit
extends AppState
## Quit State
##
## Entered just before the app quits.
## Useful for cleaning up memory or automatically saving the game.


func enter(_previous_state: SimpleState) -> void:
	scene_tree.quit()
	entered.emit()
