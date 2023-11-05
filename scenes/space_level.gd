extends Node2D

var asteroid_scene: PackedScene = preload("res://scenes/asteroid.tscn")
var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

var score = 0

func add_score(size):
	if "large" in size:
		score += 50
	if "medium" in size:
		score += 75
	if "small" in size:
		score += 100

func spawn_asteroid(size: String, pos: Vector2):
	var a = asteroid_scene.instantiate()
	a.start_asteroid("asteroid", size, pos)
	$Asteroids.call_deferred("add_child", a)
	connect_asteroid(a)
	

func split_asteroid(asteroid: RigidBody2D):
	print("splitting ", asteroid, ": ", asteroid.size)
	var original_size = asteroid.size
	var new_size
	if "small" in original_size:
		asteroid.die()
	else:
		if "large" in original_size:
			new_size = "medium"
			add_score(original_size)	
		if "medium" in original_size:
			new_size = "small"
		spawn_asteroid(new_size, asteroid.position)
		spawn_asteroid(new_size, asteroid.position)
		asteroid.die()
	
	add_score(original_size)
	print("Score: ", score)
	

func connect_asteroid(asteroid):
	asteroid.connect("split_asteroid", _on_asteroid_split_asteroid)
	
	
func _ready():
	for a in get_tree().get_nodes_in_group("Asteroids"):
		connect_asteroid(a)

func _on_player_fire_bullet(pos, rot):
	var b = bullet_scene.instantiate()
	$Projectiles.call_deferred("add_child", b)
	b.start(pos, rot)


func _on_up_limit_area_entered(area):
#	print("up limit entered", area)
	if "prepare_teleport" in area:
		area.prepare_teleport("v")


func _on_down_limit_area_entered(area):
#	print("down limit entered", area)
	if "prepare_teleport" in area:
		area.prepare_teleport("v")


func _on_right_limit_area_entered(area):
#	print("right limit entered", area)
	if "prepare_teleport" in area:
		area.prepare_teleport("h")


func _on_left_limit_area_entered(area):
#	print("left limit entered", area)
	if "prepare_teleport" in area:
		area.prepare_teleport("h")


func _on_asteroid_split_asteroid(asteroid):
	print("asteroid split!")
	split_asteroid(asteroid)
