extends CanvasLayer

@onready var projectile_counter: Label = $ProjectileCounter
@onready var fps: Label = $FPS
@onready var health: Label = $Health

func _process(_delta: float) -> void:
	
	projectile_counter.text = "Projectiles: " + str(Globals.current_projectiles)
	fps.text = "FPS: " + str(Engine.get_frames_per_second())
	health.text = "Health " + str(Globals.player.health_component.current_health)
