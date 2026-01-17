extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_used_cells():
		print(str(i.x) + "," + str(i.y))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("debug")):
		var mouse_position = get_global_mouse_position()
		var local_position = to_local(mouse_position)
		var tile_coords = local_to_map(local_position)
		print_debug(tile_coords)
	pass
