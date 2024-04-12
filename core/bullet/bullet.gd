extends AnimatedSprite2D
class_name Bullet

var scene: Main
var uuid: String
var removed: bool = false
var type: BulletType
var team: int
var target: Vector2
var direction: Vector2
var lifetime: float

static var MT_BULLET = "bullet"
static var MT_ARROW = "arrow"

static var DR_BLOCK = "block"
static var DR_UNIT = "unit"
static var DR_LIFETIME = "lifetime"

func _init():
	uuid = str(Main.random.randi_range(0, 9999999))

#func move(direction: Vector2, speed: float, delta: float):
	#velocity = direction * speed * delta
	#if velocity.x < 0:
		#find_child("Sprite").flip_h = true
	#else:
		#find_child("Sprite").flip_h = false
	#move_and_slide()

func remove():
	removed = true
	Bullets.remove(self)
	queue_free()

func destroy(destory_reason: String):
	# type.on_destroy(destory_reason)
	remove()

func  _physics_process(delta: float):
	type.on_update(scene, self, delta)
