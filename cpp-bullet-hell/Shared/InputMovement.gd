extends Node2D

@onready var character : CharacterBody2D = self.get_parent()

@export var movement_speed : float

func _physics_process(_delta: float) -> void:
	
	var movement_vector : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	character.velocity = movement_vector * movement_speed
	
	character.move_and_slide()
