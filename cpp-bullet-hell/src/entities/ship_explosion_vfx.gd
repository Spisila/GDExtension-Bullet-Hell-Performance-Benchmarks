extends Node2D

@export var max_x : float
@export var min_x : float

@export var max_y : float
@export var min_y : float

@export var explosion_vfx : PackedScene


@onready var timer: Timer = $Timer


func _on_timer_timeout() -> void:
	
	var ran_x = randf_range(min_x, max_x)
	var ran_y = randf_range(min_y, max_y)
	
	var e = explosion_vfx.instantiate() as CPUParticles2D
	e.emitting = true
	e.position = Vector2(ran_x, ran_y)
	self.add_child(e)
	
