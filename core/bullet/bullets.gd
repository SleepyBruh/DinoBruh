extends Node
class_name Bullets

static var registry: Dictionary = {}
static var list: Array = []
static var teams: Dictionary = {}

static func add(bullet: Bullet):
	registry[bullet.uuid] = bullet
	list.append(bullet)
	if not bullet.team in teams:
		teams[bullet.team] = []
	teams[bullet.team].append(bullet)

static func remove(bullet: Bullet):
	registry.erase(bullet.uuid)
	list.erase(bullet)
	teams[bullet.team].erase(bullet)
