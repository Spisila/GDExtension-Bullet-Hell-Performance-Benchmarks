extends Camera2D

var mult_factor = 2.5

func _ready() -> void:
	var viewport_max = get_viewport_rect().size
	
	Globals.max_left = float(-viewport_max.x) * mult_factor
	Globals.max_right = float(viewport_max.x) * mult_factor
	Globals.max_up = float(-viewport_max.y) * mult_factor
	Globals.max_down = float(viewport_max.y) * mult_factor
