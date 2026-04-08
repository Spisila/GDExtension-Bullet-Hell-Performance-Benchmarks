extends Node2D

@export var max_health : float

var current_health : float

@onready var parent : Node2D

func _ready() -> void:
	current_health = max_health

func take_damage(damage : float) :
	current_health -= damage
	
	if current_health <= 0 : 
		pass
		#parent.queue_free()
