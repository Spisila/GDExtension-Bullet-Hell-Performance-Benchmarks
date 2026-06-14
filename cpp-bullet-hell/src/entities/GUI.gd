extends CanvasLayer

@onready var projectile_counter: Label = $ProjectileCounter
@onready var fps: Label = $FPS
@onready var health_bar: ProgressBar = $ProgressBar
@onready var distance: Label = $Distance


func _process(_delta: float) -> void:
	
	projectile_counter.text = "Projectiles: " + str(Globals.current_projectiles)
	fps.text = "FPS: " + str(Engine.get_frames_per_second())
	health_bar.value = Globals.player.health_component.current_health
	distance.text = "Distance: " + str(Globals.distance)
	
	if Globals.spawning :
		Globals.distance += 1
