extends RigidBody2D

@export var type: String
@export var size: String

signal fire_bullet(pos, rot)
signal split_asteroid(asteroid: RigidBody2D)

var move_speed: int = 350
var max_speed: int = 300
var offset: int = 10

var thrust = Vector2(move_speed,0)
var torque = 50000 # 132 deg/s

var can_fire: bool = true

var vert: bool = false
var hori: bool = false

func load_asteroid_texture():
	var folder = DirAccess.open("res://graphics/asteroids/")
	var possible_textures = Array()
	if folder:
		folder.list_dir_begin()
		var file_name = folder.get_next()
		while file_name != "":
			if size in file_name and "import" not in file_name:
				possible_textures.append(load("res://graphics/asteroids/" + file_name))
			file_name = folder.get_next()
	$AsteroidSprite.texture = possible_textures.pick_random()

func adjust_asteroid_collision_size():
	if size == "medium":
		$CollisionShape2D.scale = Vector2(1.0, 1.0)
	if size == "medium":
		$CollisionShape2D.scale = Vector2(0.5, 0.5)
	
	if size == "small":
		$CollisionShape2D.scale = Vector2(0.3, 0.3)

func teleport(state: PhysicsDirectBodyState2D):
	var tar = Transform2D(state.get_transform())
	
	if vert:
		var o = offset
		if tar.origin.y < 0:
			o = -offset
		tar.origin.y = -tar.origin.y + o
		vert = false
	
	if hori:
		var o = offset
		if tar.origin.x < 0:
			o = -offset
		tar.origin.x = -tar.origin.x + o
		hori = false
	
	state.set_transform(tar)

func input_player(state: PhysicsDirectBodyState2D):
	if Input.is_action_pressed("up"):
		state.apply_force(thrust.rotated(rotation))
		$AnimatedSprite2D.play("moving")
		$CPUParticles2D.set_emitting(true)
	else:
		state.apply_force(Vector2())
		$AnimatedSprite2D.play("idle")
		$CPUParticles2D.set_emitting(false)
	
	var rotation_direction = 0
	if Input.is_action_pressed("right"):
		rotation_direction += 1
	if Input.is_action_pressed("left"):
		rotation_direction -= 1
	
	state.apply_torque(rotation_direction * torque)
	
	if abs(state.get_linear_velocity().x) > max_speed or abs(state.get_linear_velocity().y) > max_speed:
		var new_speed: Vector2 = state.get_linear_velocity().normalized()
		new_speed *= max_speed
		state.set_linear_velocity(new_speed)
	
	if Input.is_action_pressed("action") and can_fire:
		can_fire = false
		$Timer.start()
		fire()

func fire():
	fire_bullet.emit($Gun.global_position, $Gun.global_rotation)

func hit():
#	print(self, " was hit!")
	if "asteroid" in type:
		print("asteroid hit!")
		split_asteroid.emit(self)

func die():
	queue_free()

func accelerate_asteroid():
	if "asteroid" in type:
		apply_impulse(Vector2(randf_range(-1,1), randf_range(-1,1)) * 100)
		apply_torque(randf() * 200e3)

func start_asteroid(t, s, pos):
	type = t
	size = s
	position = pos
	load_asteroid_texture()
	adjust_asteroid_collision_size()
	accelerate_asteroid()

func _ready():
	if "player" in type:
		$CPUParticles2D.set_emitting(false)
		$AnimatedSprite2D.play("idle")
	if "asteroid" in type:
		load_asteroid_texture()
		adjust_asteroid_collision_size()
		accelerate_asteroid()
	
func _process(_delta):
	pass

func _integrate_forces(state):
	if type == "player":
		input_player(state)
	
	if vert or hori:
		teleport(state)
	
func _on_timer_timeout():
	can_fire = true
