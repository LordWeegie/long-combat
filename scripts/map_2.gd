extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProjectSettings.set_setting("physics/3d/default_gravity", Vector3(0, -2.5 , 0))
	print(ProjectSettings.get_setting("physics/3d/default_gravity"))


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$gun2.queue_free()
		print("Has gun")
		$player.has_gun = true


func _on_respawn_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
