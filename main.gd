extends Node2D
class_name Main

static func find_by_class(root: Node, class_name_ : String) -> Array:
	var found: Array = []
	if root.is_class(class_name_):
		found.append(root)
	for child in root.get_children():
		found.append_array(find_by_class(child, class_name_))
	return found

static var T_UNKNOWN: int = -1
static var T_PLAYER: int = 1
static var T_ENEMIES: int = 2

static func find_enemy_team(team: int) -> int:
	if team == T_PLAYER:
		return T_ENEMIES
	if team == T_ENEMIES:
		return T_PLAYER
	return T_UNKNOWN

static var U_DINO: UnitType = UnitType.load("dino")
static var U_RAPTOR: UnitType = UnitType.load("raptor")

@onready var scene: Node2D = get_node(".")
@onready var camera: Camera2D = get_node("Camera")
static var random: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	var unit_index = 0
	for unit_id in UnitType.registry:
		var unit_button: Button = Button.new()
		unit_button.text = unit_id
		unit_button.position.x = 152
		unit_button.position.y = 56 * unit_index
		find_child("UI").add_child(unit_button)
		unit_index += 1
		unit_button.set

var DEBUG_team = T_PLAYER
var DEBUG_unit = "dino"

func _on_switch_player_team_button_down():
	DEBUG_team = T_PLAYER
	find_child("SwitchPlayerTeam").disabled = true
	find_child("SwitchEnemyTeam").disabled = false


func _on_switch_enemy_team_button_down():
	DEBUG_team = T_ENEMIES
	find_child("SwitchPlayerTeam").disabled = false
	find_child("SwitchEnemyTeam").disabled = true
