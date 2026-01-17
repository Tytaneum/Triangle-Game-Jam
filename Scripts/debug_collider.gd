extends Node2D

@onready var area: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_overlap()
	pass

#checks the overlap for a breakable layer
func check_overlap():
	if area.has_overlapping_bodies():
		var overlaps = area.get_overlapping_bodies()
		for o in overlaps:
			if o.is_in_group("Breakable"):
				var collider_position = get_global_mouse_position()
				var local_pos = o.to_local(collider_position)
				var tile_pos = o.local_to_map(local_pos)
				print(tile_pos)
				o.erase_cell(Vector2i(tile_pos.x, tile_pos.y))

func _on_body_shape_entered(body, body_shape_index, area_shape_index):
	print("A")

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("debug")):
		var mouse_position = get_global_mouse_position()
		position = mouse_position
	pass
