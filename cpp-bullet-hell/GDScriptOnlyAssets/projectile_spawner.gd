extends Marker2D

@onready var left_border: Marker2D = $LeftBorder
@onready var right_border: Marker2D = $RightBorder

const GD_ONLY_PROJECTILE = preload("uid://barf1fbrq84tc")

@export var max_projectiles : int 

func _process(_delta: float) -> void:
	
	if Globals.spawning == true :
	
		if Globals.current_projectiles < max_projectiles : 
			
			for i in range(10) :
			
				var ran_x = randf_range(left_border.global_position.x, right_border.global_position.x)
				
				var p = GD_ONLY_PROJECTILE.instantiate() as Area2D
				p.global_position = Vector2(ran_x, self.global_position.y)
				p.global_rotation_degrees = self.global_rotation_degrees
				
				get_tree().root.add_child(p)
				
				Globals.current_projectiles += 1
