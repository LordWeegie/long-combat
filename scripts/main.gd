extends Node3D

var time_wait := 1.0

func _ready() -> void:
	ProjectSettings.set_setting("physics/3d/default_gravity", Vector3(0, -9.0 , 0))
	flicker_loop()

func flicker_loop() -> void:
	while true:
		await get_tree().create_timer(time_wait).timeout
		flicker()

func flicker() -> void:
	if $StaticBody3D/OmniLight3D3.light_energy == 0.0:
		$StaticBody3D/OmniLight3D3.light_energy = 0.1
		$StaticBody3D/Sprite3D.visible = true
		time_wait = 1.3
	else:
		$StaticBody3D/Sprite3D.visible = false
		$StaticBody3D/OmniLight3D3.light_energy = 0.0
		time_wait = 0.3


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://scenes/maps/animation_plays.tscn")
