class_name HealthComponent
extends Node2D

@export var max_health : float

var current_health : float

var can_take_damage : bool = true

@onready var parent : Node2D

signal damaged
signal died

@onready var animation_player: AnimationPlayer = $"../../GUI/DamageVFX/AnimationPlayer"

func _ready() -> void:
	current_health = max_health

func take_damage(damage : float) :
	
	if can_take_damage :
		animation_player.play("damage")
		current_health -= damage
		damaged.emit()
		if current_health <= 0 : 
			pass
			died.emit()
