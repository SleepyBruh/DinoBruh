extends Button
class_name ButtonUnit

var Un: String

func _on_pressed():
	var Unit: UnitType = UnitType.registry[Un]
	$"../Tab".text = "Health " + str(Unit.health) + '\n' + "Speed " + str(Unit.speed) + '\n' + "Cost " + str(Unit.cost)
	print(Un)
