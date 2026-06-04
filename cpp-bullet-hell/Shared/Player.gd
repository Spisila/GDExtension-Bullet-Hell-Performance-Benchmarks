class_name Player
extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var input_movement: Node2D = $InputMovement

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $"../GUI/DamageVFX/AnimationPlayer"


@onready var ship_explosion_vfx: Node2D = $VFX/ShipExplosionVFX
@onready var thruster_main: CPUParticles2D = $VFX/ThrusterMain
@onready var thruster_main_2: CPUParticles2D = $VFX/ThrusterMain2
@onready var thruster_main_3: CPUParticles2D = $VFX/ThrusterMain3
@onready var shield: Sprite2D = $VFX/Shield

@onready var defeat_fade_animation: AnimationPlayer = $"../GUI/DefeatFadeOut/DefeatFadeAnimation"
@onready var defeat_timer: Timer = $"../DefeatTimer"

var after_ready : bool = false

func _ready() -> void:
	Globals.player = self
	

func _process(_delta: float) -> void:
	
	if after_ready == false :
		Globals.bullet_manager.connect("player_hit", player_damage)
		after_ready = true
	


func player_damage() :
	health_component.take_damage(1)


func _on_bullet_manager_difficulty_up() -> void:
	input_movement.movement_speed += 100;

func _on_health_component_died() -> void:
	Globals.spawning = false
	health_component.can_take_damage = false
	ship_explosion_vfx.timer.start()
	
	input_movement.can_move = false
	
	thruster_main.queue_free()
	thruster_main_2.queue_free()
	thruster_main_3.queue_free()
	shield.queue_free()
	
	defeat_fade_animation.play("defeat_fade_out")
	
	defeat_timer.start()
	
	if Globals.distance > Globals.high_score :
		Globals.high_score = Globals.distance


func _on_defeat_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Shared/DefeatScene.tscn")
