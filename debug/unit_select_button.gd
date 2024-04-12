extends Button
class_name UnitSelectButton

var unit_type: String

func _pressed():
	Level_1.DEBUG_unit = unit_type
