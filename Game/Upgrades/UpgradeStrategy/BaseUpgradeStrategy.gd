class_name BaseUpgradeStrategy
extends Resource

############################################
# Strategy Relevan Code:
# This is the base strategy that all other
# upgrade strategies will inherit from.
############################################


@export var upgrade_text: String = "Upgrade"


# This is the function that we later call when applying an upgrade.
func apply_upgrade(target_stat: Variant) -> void:
	# This does nothing by default.
	pass
