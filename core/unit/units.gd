extends Node
class_name Units

static var registry: Dictionary = {}
static var list: Array = []
static var teams: Dictionary = {}

static func add(unit: Unit):
	registry[unit.uuid] = unit
	list.append(unit)
	if not unit.team in teams:
		teams[unit.team] = []
	teams[unit.team].append(unit)

static func remove(unit: Unit):
	registry.erase(unit.uuid)
	list.erase(unit)
	teams[unit.team].erase(unit)

static func find_closest(unit: Unit, team: int = -1) -> Unit:
	var min_distance: float = 999_999_999
	var closest_unit: Unit = null
	if team == -1:
		for other_unit in list:
			if unit.uuid == other_unit.uuid:
				continue
			if unit.position.distance_to(other_unit.position) < min_distance:
				min_distance = unit.position.distance_to(other_unit.position)
				closest_unit = other_unit
		return closest_unit
	if not team in teams:
		return null
	for other_unit in teams[team]:
		if unit.uuid == other_unit.uuid:
			continue
		if unit.position.distance_to(other_unit.position) < min_distance:
			min_distance = unit.position.distance_to(other_unit.position)
			closest_unit = other_unit
	return closest_unit
