extends TextureProgressBar


#func _ready(): # for debug purposes
	#Global.gem_meter = 498

func _physics_process(_delta: float):
	increment(Global.gem_meter)
	
	if Global.gigadrill:
		decrement()
		if Global.gem_meter <= 0:
			Global.gem_meter = 0
			Global.gigadrill = false
			
	if Global.gem_meter >= 498 and !Global.gigadrill:
		#Global.gem_meter = 498
		Global.gigadrill = true
	

func increment(points):
	if Global.gem_meter <= 498:
		value = points
	else:
		Global.gem_meter = 498
	
func decrement():
	Global.gem_meter -= 1
