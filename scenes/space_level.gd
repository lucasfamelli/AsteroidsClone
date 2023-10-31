extends Node2D

func _on_up_limit_body_entered(body):
	print("up limit entered")
	if "prepare_teleport" in body:
		body.prepare_teleport("v")

func _on_down_limit_body_entered(body):
	print("down limit entered")
	if "prepare_teleport" in body:
		body.prepare_teleport("v")

func _on_left_limit_body_entered(body):
	print("left limit entered")
	if "prepare_teleport" in body:
		body.prepare_teleport("h")

func _on_right_limit_body_entered(body):
	print("right limit entered")
	if "prepare_teleport" in body:
		body.prepare_teleport("h")
