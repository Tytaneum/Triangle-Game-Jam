extends Area2D

func _physics_process(delta: float):
	position= Vector2.ZERO
	if Input.is_action_pressed("right"):
		position.x = 40
		position.y = 0
	elif Input.is_action_pressed("left"):
		position.x = -40
		position.y = 0
	elif Input.is_action_pressed("up"):
		position.x = 0
		position.y = -40
	elif Input.is_action_pressed("down"):
		position.x = 0
		position.y = 40

func _process(delta: float) -> void:
	check_overlap()

#checks the overlap for a breakable layer
func check_overlap():
	if has_overlapping_bodies():
		var overlaps = get_overlapping_bodies()
		for o in overlaps:
			if o.is_in_group("Breakable"):
				var collider_position = global_position
				var local_pos = o.to_local(collider_position)
				var tile_pos = o.local_to_map(local_pos)
				print(tile_pos)
				o.erase_cell(Vector2i(tile_pos.x, tile_pos.y))
