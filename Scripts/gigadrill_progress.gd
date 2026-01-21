extends TextureProgressBar


func _ready():
	value = 100

func _physics_process(_delta: float):	
	if Global.gigadrill:
		decrement()
		if value <= 0:
			Global.gigadrill = false
			
	if value >= 100:
		Global.gigadrill = true

func increment(points):
	value += points
	
func decrement():
	value -= .6
	print(value)
