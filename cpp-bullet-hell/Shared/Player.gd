class_name Player
extends CharacterBody2D

@onready var health_component: Node2D = $HealthComponent

func _ready() -> void:
	Globals.player = self
