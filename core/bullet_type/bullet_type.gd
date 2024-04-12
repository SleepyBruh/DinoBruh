extends Node
class_name BulletType

var id: String
var animations: Dictionary
var default_animation: String
var speed: float
var movement_type: String
var damage: float
var lifetime: float

static func load(id: String) -> BulletType:
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("content/bullets/{id}/{id}.json".format({"id": id})))
	return BulletType.new(data)

func _init(data: Dictionary):
	self.id = data.id
	self.animations = {}
	for animation_name: String in data.animations:
		var animation_data: Dictionary = data.animations[animation_name]
		self.animations[animation_name] = {}
		if "default" in animation_data:
			if animation_data.default:
				self.default_animation = animation_name
		self.animations[animation_name].speed = animation_data.speed
		self.animations[animation_name].frames = []
		for frame_index: int in range(animation_data.frames):
			self.animations[animation_name].frames.append(ImageTexture.create_from_image(Image.load_from_file("content/bullets/" + id + "/" + animation_name + "-" + str(frame_index) + ".png")))
	speed = data.speed
	movement_type = data.movement_type
	damage = data.damage
	lifetime = data.lifetime

func spawn(scene: Node2D, x: float, y: float, team: int, target: Vector2) -> Bullet:
	var bullet: Bullet = load("res://core/bullet/Bullet.tscn").instantiate()
	bullet.scene = scene
	# Данные
	bullet.type = self
	bullet.team = team
	bullet.target = target
	bullet.lifetime = lifetime
	# Позиция
	bullet.position = Vector2(x, y)
	bullet.direction = bullet.position.direction_to(target)
	# Текстура
	var sprite_frames: SpriteFrames = SpriteFrames.new()
	bullet.sprite_frames = sprite_frames
	for animation_name: String in self.animations:
		var animation_data: Dictionary = self.animations[animation_name]
		sprite_frames.add_animation(animation_name)
		sprite_frames.set_animation_speed(animation_name, animation_data.speed)
		for frame: ImageTexture in animation_data.frames:
			sprite_frames.add_frame(animation_name, frame)
	bullet.play(self.default_animation)
	# Добавление
	scene.add_child(bullet)
	Bullets.add(bullet)
	on_spawn(scene, bullet)
	return bullet

func on_spawn(scene: Node2D, bullet: Bullet):
	pass

func on_update(scene: Node2D, bullet: Bullet, delta: float):
	bullet.lifetime -= delta
	if bullet.lifetime <= 0:
		bullet.destroy(Bullet.DR_LIFETIME)
		return
	if movement_type == Bullet.MT_BULLET:
		bullet.position += bullet.direction * speed * delta
		var tile_map: TileMap = scene.find_child("Tiles")
		var tile_data: TileData = tile_map.get_cell_tile_data(0, Vector2i(bullet.position.x / 32, bullet.position.y / 32))
		if tile_data != null:
			if tile_data.get_collision_polygons_count(0) > 0:
				bullet.destroy(Bullet.DR_BLOCK)
				return
		for unit: Unit in Units.list:
			if unit.removed:
				continue
			if unit.team == bullet.team:
				continue
			var bx = bullet.position.x
			var by = bullet.position.y
			var ux = unit.position.x
			var uy = unit.position.y
			var ur = unit.find_child("CollisionShape").shape.radius
			if sqrt((bx - ux) * (bx - ux) + (by - uy) * (by - uy)) <= ur:
				unit.health -= damage
				bullet.destroy(Bullet.DR_UNIT)
				return
