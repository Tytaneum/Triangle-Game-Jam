extends TextureProgressBar


var gigadrill

func _ready():
	gigadrill = Player.gigadrill
	value = 100

func _physics_process(_delta: float):	
	if gigadrill:
		decrement()

func increment():
	value += 2
	
func decrement():
	value -= 2
