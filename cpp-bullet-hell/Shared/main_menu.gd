extends PanelContainer


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://CPP&MultiMeshInstance2D/cpp&multi_mesh_instance_2d.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
