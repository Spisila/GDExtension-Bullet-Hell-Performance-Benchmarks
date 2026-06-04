class_name InputMovement
extends Node2D

@onready var character : CharacterBody2D = self.get_parent()

@export var movement_speed : float

var can_move : bool = true

func _physics_process(_delta: float) -> void:
	
	if can_move :
		var movement_vector : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		character.velocity = movement_vector * movement_speed
		
		character.move_and_slide()
