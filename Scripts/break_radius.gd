extends Area2D

var tiles_this_frame = []

func _physics_process(_delta: float):
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
	
	if has_overlapping_bodies():
		var overlaps = get_overlapping_bodies()
		for o in overlaps:
			if o.is_in_group("Breakable"):
				var collision_shape = $CollisionShape2D
				var size = collision_shape.shape.size
				
				#reset the list of damaged tiles this frame
				tiles_this_frame = []
				
				#check 4 edges and middle#
				#middle
				collision_at_position(global_position)
				#left
				collision_at_position(Vector2(global_position.x - size.x/2, global_position.y))
				#right
				collision_at_position(Vector2(global_position.x + size.x/2, global_position.y))
				#top
				collision_at_position(Vector2(global_position.x, global_position.y - size.y/2))
				#bottom
				collision_at_position(Vector2(global_position.x, global_position.y + size.y/2))

#checks the overlap for a breakable layer
func dig_tile(object, pos):
	var local_pos = object.to_local(pos)
	var tile_pos = object.local_to_map(local_pos)
	#only do it if it has not been damaged this frame
	if !tiles_this_frame.has(tile_pos):
		object.get_parent().grid[tile_pos.y][tile_pos.x].dig()
		#add it to the list for this frame
		tiles_this_frame.append(tile_pos)

func collision_at_position(p: Vector2):
	var state_space = get_world_2d().direct_space_state
	
	#set up the query
	var q = PhysicsPointQueryParameters2D.new()
	q.position = p
	q.collide_with_areas = false
	q.collide_with_bodies = true
	
	#get all nodes that arent the tilemap to exclude them
	var exclude = []
	for node in get_tree().get_nodes_in_group("Breakable"):
		if node is CollisionObject2D:
			exclude.append(node.get_rid())
	q.exclude = exclude	
	
	#should get just the tilemap if anything
	var result = state_space.intersect_point(q)
	
	#makes sure its a tilemap and exists
	if result.size() > 0:
		#only run it if it finds the tilemap at the position
		var tilemap = result.get(0).get("collider")
		if tilemap is TileMapLayer:
			dig_tile(tilemap, p)
	
	pass
