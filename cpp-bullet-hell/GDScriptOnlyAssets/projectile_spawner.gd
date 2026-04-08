extends Marker2D

@onready var left_border: Marker2D = $LeftBorder
@onready var right_border: Marker2D = $RightBorder

const GD_ONLY_PROJECTILE = preload("uid://barf1fbrq84tc")

@export var max_projectiles : int 

var GD_ONLY_CSV = "res://Benchmarks/gd_only.txt"

@onready var bench_file = FileAccess.open(GD_ONLY_CSV, FileAccess.WRITE)

var spawning = false

func _ready() -> void:
	# Add warm up period for benchmarks
	bench_file.store_line("Projectiles, Frame Time ms, FPS")

func _process(_delta: float) -> void:
	
	if spawning == true :
	
		if Globals.current_projectiles < max_projectiles : 
			
			for i in range(10) :
			
				var ran_x = randf_range(left_border.global_position.x, right_border.global_position.x)
				
				var p = GD_ONLY_PROJECTILE.instantiate() as Area2D
				p.global_position = Vector2(ran_x, self.global_position.y)
				p.global_rotation_degrees = self.global_rotation_degrees
				
				get_tree().root.add_child(p)
				
				Globals.current_projectiles += 1


func _on_save_benchmark_timer_timeout() -> void:
	var frame_time = Performance.get_monitor(Performance.TIME_PROCESS)
	print(str(Globals.current_projectiles) + " | " + str(1 / frame_time) + "|" + str(Engine.get_frames_per_second()))
	bench_file.store_line(str(Globals.current_projectiles)+","+str(1 / frame_time)+","+str(Engine.get_frames_per_second()))


func _on_warm_up_timer_timeout() -> void:
	spawning = true
