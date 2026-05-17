class_name Player
extends CharacterBody2D

@onready var health_component: Node2D = $HealthComponent
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	Globals.player = self
	
