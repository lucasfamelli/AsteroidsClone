extends RigidBody2D

@export var move_speed: int = 200

var thrust = Vector2(move_speed,0)
var torque = 50000 # 132 deg/s

var can_fire: bool = true
var seconds = 0


func _process(_delta):
	pass

func _integrate_forces(state):
	if Input.is_action_pressed("up"):
		state.apply_force(thrust.rotated(rotation))
		$AnimatedSprite2D.play("moving")
	else:
		state.apply_force(Vector2())
		$AnimatedSprite2D.play("idle")
		
	var rotation_direction = 0
	if Input.is_action_pressed("right"):
		rotation_direction += 1
	if Input.is_action_pressed("left"):
		rotation_direction -= 1
	
	state.apply_torque(rotation_direction * torque)


func _on_timer_timeout():
	seconds += 1
	print(linear_velocity, ' - ', seconds, "s")
