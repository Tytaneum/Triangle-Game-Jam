extends Label

func _ready() -> void:
	Global.restart.connect(_on_restart)
	visible = false

func _on_restart():
	visible = true

func _physics_process(delta: float) -> void:
	if visible:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
		elif Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()
