extends Node2D

@onready var instance_2d: MultiMeshInstance2D = $MultiMeshInstance2D
@onready var multi : MultiMesh = instance_2d.multimesh

@export var max_projectiles : int = 2

@export var projectiles_per_spawn : int = 2

@onready var right_border: Marker2D = $RightBorder
@onready var left_border: Marker2D = $LeftBorder

var instances_transforms : Array[Transform2D]
var instances_positions : Array[Vector2]
var instances_timers : PackedFloat32Array

var projectile_speed : float = 500
var projectile_radius : float = 50
var projectile_timout_time : float = 20

var multi_id : int = 0

var active_projectiles_indexes : Array[int]

func _ready() -> void: 
	
	var quad : QuadMesh = multi.mesh
	quad.size = instance_2d.texture.get_size() * 0.2
	
	multi.instance_count = max_projectiles
	
	for i in range(max_projectiles) :
		var t : Transform2D = Transform2D()
		
		t.origin = Vector2(9000,9000)
		instances_transforms.push_back(t)
		instances_positions.push_back(Vector2(9000,9000))
		instances_timers.push_back(projectile_timout_time)


func _process(delta: float) -> void:
	
	if Globals.spawning == true :
		
		if Globals.current_projectiles < max_projectiles :
			
			for i in range(projectiles_per_spawn) :
				
				var rand_pos_x = randf_range(left_border.global_position.x, right_border.global_position.x)
				var new_pos = Vector2(rand_pos_x, -2000)
				
				instances_transforms[multi_id].origin = new_pos
				instances_positions[multi_id] = new_pos
				
				multi.set_instance_transform_2d(multi_id, instances_transforms[multi_id])
				active_projectiles_indexes.push_back(multi_id)
				
				multi_id = wrapi(multi_id + 1, 0, max_projectiles)
				
				Globals.current_projectiles += 1
	
	for i in active_projectiles_indexes :
		update_projectile_position(i, delta)
		check_collision(i)
		count_down_timer(i, delta)
		check_should_disable(i)

func deactivate_projectile(index : int ) :
	active_projectiles_indexes.erase(index)
	var reset_pos = Vector2(9000,9000)
	instances_transforms[index].origin = reset_pos
	instances_positions[index] = reset_pos
	multi.set_instance_transform_2d(index, instances_transforms[index])
	instances_timers[index] = projectile_timout_time

func check_should_disable(index : int) :
	if instances_timers[index] <= 0 :
		deactivate_projectile(index)

func count_down_timer(index : int, delta : float) :
	instances_timers[index] -= delta

func check_collision(index : int) :
	var distance_from_player : float = instances_positions[index].distance_to(Globals.player.global_position)
	if distance_from_player <= projectile_radius :
		Globals.player.health_component.take_damage(10)
		deactivate_projectile(index)

func update_projectile_position(index : int, delta : float) :
	instances_positions[index].y += projectile_speed * delta
	instances_transforms[index].origin = instances_positions[index]
	multi.set_instance_transform_2d(index, instances_transforms[index])
