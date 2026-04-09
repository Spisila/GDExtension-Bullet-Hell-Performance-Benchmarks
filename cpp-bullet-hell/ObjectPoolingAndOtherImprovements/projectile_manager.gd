extends Node2D

var projectiles : Array[Sprite2D]

var active_projectiles_indexes : PackedInt32Array

var timeout_time : float = 20
var timeout_timers : PackedFloat32Array

@export var max_projectiles : int = 30000

var projectile_speed : float = 10
var projectile_radius : float = 50

var projectiles_per_spawn : int = 50

var pool_index : int = 0

@onready var left_border: Marker2D = $LeftBorder
@onready var right_border: Marker2D = $RightBorder

const OBJECT_POOLING_PROJECTILE = preload("uid://dlubjexkqbd4c")

func create_projectiles() :
	for i in range(max_projectiles) : 
		var o : Sprite2D = OBJECT_POOLING_PROJECTILE.instantiate()
		
		o.set_process(false)
		o.visible = false
		
		self.add_child(o)
		projectiles.push_back(o)
		
		timeout_timers.push_back(timeout_time)

func activate_projectile(position_ : Vector2) :
	
	var p : Sprite2D = projectiles[pool_index]
	
	p.global_position = position_
	p.set_process(true)
	p.visible = true
	
	active_projectiles_indexes.push_back(pool_index)
	
	Globals.current_projectiles += 1
	
	pool_index = wrapi(pool_index + 1, 0, max_projectiles)

func deactivate_projectile(projectile_index : int) :
	
	projectiles[projectile_index].global_position = Vector2(9000,9000)
	timeout_timers[projectile_index] = timeout_time
	projectiles[projectile_index].set_process(false)
	projectiles[projectile_index].visible = false
	
	active_projectiles_indexes.erase(projectile_index)
	
	Globals.current_projectiles -= 1

func check_collisions() : 
	
	for i in active_projectiles_indexes :
		if projectiles[i].global_position.distance_to(Globals.player.global_position) < projectile_radius :
			Globals.player.health_component.take_damage(10)
			deactivate_projectile(i)

func update_positions() :
	
	for i in active_projectiles_indexes :
		projectiles[i].position += Vector2.DOWN * projectile_speed

func count_down_timers(delta : float) :
	
	for i in active_projectiles_indexes :
		timeout_timers[i] -= delta

func check_should_disable() :
	
	for i in active_projectiles_indexes :
		if timeout_timers[i] <= 0 :
			deactivate_projectile(i)

func _ready() -> void: 
	create_projectiles()

func _process(delta: float) -> void:
	
	if Globals.spawning == true : 
	
		for i in range(projectiles_per_spawn) :
			
			if active_projectiles_indexes.size() < max_projectiles :
			
				var rand_pos_x = randf_range(left_border.global_position.x, right_border.global_position.x)
				
				activate_projectile(Vector2(rand_pos_x, self.global_position.y))
	
	if active_projectiles_indexes.is_empty() == false :
		check_collisions()
		update_positions()
		count_down_timers(delta)
		check_should_disable()
