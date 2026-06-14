extends Node2D

func _ready() -> void:
	Globals.bullet_manager = $BulletManager


func _on_warm_up_timer_timeout() -> void:
	Globals.spawning = true
