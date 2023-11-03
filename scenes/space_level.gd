extends Node2D

var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

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
