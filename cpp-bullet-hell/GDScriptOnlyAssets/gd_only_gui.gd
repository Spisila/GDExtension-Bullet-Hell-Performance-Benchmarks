extends CanvasLayer

@onready var projectile_counter: Label = $ProjectileCounter
@onready var fps: Label = $FPS

func _process(_delta: float) -> void:
	
	projectile_counter.text = "Projectiles: " + str(Globals.current_projectiles)
	fps.text = "FPS: " + str(Engine.get_frames_per_second())
