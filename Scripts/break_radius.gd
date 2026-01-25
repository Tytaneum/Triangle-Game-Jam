extends Area2D

var tiles_this_frame = []

func _physics_process(_delta: float):
	if Input.is_action_pressed("right") and !Global.cutscene:
		position.x = 40
		position.y = 0
	elif Input.is_action_pressed("left") and !Global.cutscene:
		position.x = -40
		position.y = 0
	#elif Input.is_action_pressed("up") and !Global.cutscene:
		#position.x = 0
		#position.y = -40
	elif Input.is_action_pressed("down") and !Global.cutscene:
		position.x = 0
		position.y = 40
	elif !Global.cutscene:
		position = Vector2.ZERO
	
	if has_overlapping_bodies():
		var overlaps = get_overlapping_bodies()
		for o in overlaps:
			#means its the terrain
			if o.is_in_group("Breakable"):
				#reset the list of damaged tiles this frame
				tiles_this_frame = []
				
				#run the collision
				dig_tiles(o, global_position)

#checks the overlap for a breakable layer
func dig_tiles(object, pos):
	#get the 4 corners to work with
	var x_min = floor(global_position.x - $CollisionShape2D.shape.size.x/2)
	var x_max = ceil(global_position.x + $CollisionShape2D.shape.size.x/2)
	var y_min = floor(global_position.y - $CollisionShape2D.shape.size.y/2)
	var y_max = ceil(global_position.y + $CollisionShape2D.shape.size.y/2)
	
	#translate them to local
	var min = object.local_to_map(object.to_local(Vector2(x_min,y_min)))
	var max = object.local_to_map(object.to_local(Vector2(x_max,y_max)))
	
	for x in range(min.x, max.x + 1):
		for y in range(min.y, max.y + 1):
			#only do it if it has not been damaged this frame
			if !tiles_this_frame.has(Vector2i(x,y)):
				if x - object.get_parent().grid[0].size() < 0 and y - object.get_parent().grid.size() < 0:
					object.get_parent().grid[y][x].dig()
					#add it to the list for this frame
					tiles_this_frame.append(Vector2i(x,y))
