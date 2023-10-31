extends RigidBody2D

@export var move_speed: int = 350
@export var max_speed: int = 300
@export var offset = 30

var thrust = Vector2(move_speed,0)
var torque = 50000 # 132 deg/s

var can_fire: bool = true

var vert: bool = false
var hori: bool = false

func prepare_teleport(way):
	if way == "v":
		vert = true
	if way == "h":
		hori = true

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
		
func _ready():
	$CPUParticles2D.set_emitting(false)
	$AnimatedSprite2D.play("idle")

func _process(_delta):
	pass

func _integrate_forces(state):
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
	
	if vert or hori:
		teleport(state)
	
	
	


