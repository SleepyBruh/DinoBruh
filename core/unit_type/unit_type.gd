extends Node
class_name UnitType

static var registry = {}

var id: String
var animations: Dictionary
var default_animation: String

var cost: int
var health: float
var speed: float
var attack: Dictionary
var display_name: String

static func load(id: String) -> UnitType:
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("content/units/{id}/{id}.json".format({"id": id})))
	return UnitType.new(data)

func _init(data: Dictionary):
	self.id = data.id
	registry[self.id] = self
	self.animations = {}
	for animation_name: String in data.animations:
		var animation_data: Dictionary = data.animations[animation_name]
		self.animations[animation_name] = {}
		if "default" in animation_data:
			if animation_data.default:
				self.default_animation = animation_name
		if "mirror" in animation_data:
			animations[animation_name].mirror = animation_data.mirror
		else:
			animations[animation_name].mirror = false
		self.animations[animation_name].speed = animation_data.speed
		self.animations[animation_name].frames = []
		for frame_index: int in range(animation_data.frames):
			self.animations[animation_name].frames.append(ImageTexture.create_from_image(Image.load_from_file("content/units/" + id + "/" + animation_name + "-" + str(frame_index) + ".png")))
	
	cost = data.cost
	health = data.health
	speed = data.speed
	attack = data.attack
	display_name = data.display_name
	if attack.type == Unit.AT_DISTANT:
		attack.bullet = BulletType.load(attack.bullet_type)
		

func spawn(scene: Node2D, x: float, y: float, team: int) -> Unit:
	var unit: Unit = load("res://core/unit/Unit.tscn").instantiate()
	unit.scene = scene
	# Данные
	unit.type = self
	unit.team = team
	unit.health = health
	# Позиция
	unit.position = Vector2(x, y)
	# Текстура
	var sprite: AnimatedSprite2D = unit.find_child("Sprite")
	var sprite_frames: SpriteFrames = SpriteFrames.new()
	sprite.sprite_frames = sprite_frames
	for animation_name: String in self.animations:
		var animation_data: Dictionary = self.animations[animation_name]
		sprite_frames.add_animation(animation_name)
		sprite_frames.set_animation_speed(animation_name, animation_data.speed)
		for frame: ImageTexture in animation_data.frames:
			sprite_frames.add_frame(animation_name, frame)
	sprite.play(self.default_animation)
	# Добавление
	scene.add_child(unit)
	Units.add(unit)
	self.on_spawn(scene, unit)
	return unit
	
func on_spawn(scene: Node2D, unit: Unit):
	pass

func on_update(scene: Node2D, unit: Unit, delta: float):
	if unit.health <= 0:
		unit.remove()
		return
	unit.attack_cooldown -= delta
	if unit.state == Unit.S_FOUND_ENEMY:
		if unit.target_unit == null:
			unit.state = Unit.S_WAIT
			return
		if unit.target_unit.removed:
			unit.state = Unit.S_WAIT
			return
		if unit.position.distance_to(unit.target_unit.position) <= attack.min_distance:
			unit.state = Unit.S_ATTACK_ENEMY
			return
		if attack.lock_movement and unit.attack_cooldown > 0:
			return
		var direction = unit.position.direction_to(unit.navigation_agent.get_next_path_position())
		unit.move(direction, speed, delta * 60)
	if unit.state == Unit.S_ATTACK_ENEMY:
		if unit.target_unit == null:
			unit.state = Unit.S_WAIT
			return
		if unit.target_unit.removed:
			unit.state = Unit.S_WAIT
			return
		if unit.position.distance_to(unit.target_unit.position) >= attack.min_distance:
			unit.state = Unit.S_WAIT
			return
		if unit.attack_cooldown <= 0:
			unit.attack_cooldown = attack.cooldown
			attack_unit(scene, unit, unit.target_unit, delta)

func attack_unit(scene: Node2D, unit: Unit, target: Unit, delta: float):
	if attack.type == Unit.AT_DISTANT:
		attack.bullet.spawn(scene, unit.position.x, unit.position.y, unit.team, target.position)

func on_soft_update(scene: Node2D, unit: Unit):
	var enemy: Unit = Units.find_closest(unit, Level_1.find_enemy_team(unit.team))
	if enemy == null:
		unit.state = Unit.S_WAIT
		return
	unit.state = Unit.S_FOUND_ENEMY
	unit.target_unit = enemy
	unit.navigation_agent.target_position = enemy.position
