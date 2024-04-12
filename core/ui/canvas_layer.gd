extends CanvasLayer

func _ready():
	var unit_index = 0
	for unit_id in UnitType.registry:
		var unit_button: ButtonUnit = load("res://core/ui/unit_.tscn").instantiate()
		unit_button.text = unit_id
		unit_button.Un = unit_id
		unit_button.position.x = 190 * unit_index + 20
		unit_button.position.y = -120
		add_child(unit_button)
		unit_index += 1
