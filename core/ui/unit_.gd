extends Button
class_name ButtonUnit

var Un: String

static var click: bool = false

func _on_pressed():
	var Unit: UnitType = UnitType.registry[Un]
	$"../Tab".text = "Здоровье: " + str(Unit.health) + '\n' + "Скорость: " + str(Unit.speed) + '\n' + "Стоимость: " + str(Unit.cost)
	Level_1.DEBUG_unit = Unit.id
	self.text = Unit.display_name

func _on_mouse_entered():
	click = true


func _on_mouse_exited():
	click = false
