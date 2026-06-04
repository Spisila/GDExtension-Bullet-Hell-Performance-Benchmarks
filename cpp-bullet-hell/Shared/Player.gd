class_name Player
extends CharacterBody2D

@onready var health_component: Node2D = $HealthComponent
@onready var input_movement: Node2D = $InputMovement

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $"../GUI/DamageVFX/AnimationPlayer"

var after_ready : bool = false

func _ready() -> void:
	Globals.player = self

func _process(_delta: float) -> void:
	
	if after_ready == false :
		Globals.bullet_manager.connect("player_hit", player_damage)
		after_ready = true

func player_damage() :
	health_component.take_damage(1)
	animation_player.play("damage")


func _on_bullet_manager_difficulty_up() -> void:
	input_movement.movement_speed += 100;
