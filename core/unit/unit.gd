extends CharacterBody2D
class_name Unit

var scene: Level_1
var uuid: String
var removed: bool = false
var type: UnitType
var team: int
var target_unit: Unit
var health: float
var attack_cooldown: float = 0

static var S_WAIT = 0
static var S_FOUND_ENEMY = 1
static var S_ATTACK_ENEMY = 2

static var AT_NONE = "none"
static var AT_DISTANT = "distant"

var state: int = S_WAIT

@onready var navigation_agent: NavigationAgent2D = find_child("NavigationAgent")

func _init():
	uuid = str(Level_1.random.randi_range(0, 9999999))

func move(direction: Vector2, speed: float, delta: float):
	velocity = direction * speed * delta
	var mirror = type.animations[find_child("Sprite").animation].mirror
	if not mirror:
		if velocity.x < 0:
			find_child("Sprite").flip_h = true
		else:
			find_child("Sprite").flip_h = false
	else:
		if velocity.x < 0:
			find_child("Sprite").flip_h = false
		else:
			find_child("Sprite").flip_h = true
	move_and_slide()

func remove():
	removed = true
	Units.remove(self)
	queue_free()

func  _physics_process(delta: float):
	type.on_update(scene, self, delta)

func _on_timer():
	type.on_soft_update(scene, self)
