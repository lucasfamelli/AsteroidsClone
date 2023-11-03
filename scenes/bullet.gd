extends Area2D

var speed = 500
var offset: int = 20
var vert: bool = false
var hori: bool = false


func start(pos, rot):
	global_position = pos
	global_rotation = rot

func prepare_teleport(way):
	if way == "v":
		vert = true
	if way == "h":
		hori = true

func teleport():
	var tar = get_transform()
	
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
	
	transform = tar

func _process(delta):
	position += transform.x * speed * delta
	
	if vert or hori:
		teleport()

func _on_self_destruct_timer_timeout():
	queue_free()


func _on_body_entered(body):
	print("Collided with ", body)
	if "hit" in body:
		body.hit()
	queue_free()
