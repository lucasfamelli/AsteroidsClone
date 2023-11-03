extends Area2D

func prepare_teleport(way):
	if way == "v":
		$"..".vert = true
	if way == "h":
		$"..".hori = true

	
