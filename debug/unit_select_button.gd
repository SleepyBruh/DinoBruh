extends Button
class_name UnitSelectButton

var unit_type: String

func _pressed():
	Main.DEBUG_unit = unit_type
