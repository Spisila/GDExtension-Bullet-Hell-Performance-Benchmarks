extends Node2D

@onready var take_benchmark: Timer = $TakeBenchmark

var GD_ONLY_CSV = "res://Benchmarks/gd_only.txt"
var OBJECT_POOLING = "res://Benchmarks/object_pooling.txt"
var OBJECT_POOLING_MULTIMESH = "res://Benchmarks/object_pooling_multimesh2d.txt"
var CPP_MULTIMESH2D = "res://Benchmarks/cpp_multimesh2d.txt"


@onready var bench_file = FileAccess.open(OBJECT_POOLING, FileAccess.WRITE)

func _on_warm_up_timer_timeout() -> void:
	take_benchmark.start()
	Globals.spawning = true
	bench_file.store_line("Projectiles,Frame_Time_ms,FPS")


func _on_take_benchmark_timeout() -> void:
	var frame_time = Performance.get_monitor(Performance.TIME_PROCESS)
	print(str(Globals.current_projectiles) + " | " + str(1 / frame_time) + "|" + str(Engine.get_frames_per_second()))
	bench_file.store_line(str(Globals.current_projectiles)+","+str(1 / frame_time)+","+str(Engine.get_frames_per_second()))
