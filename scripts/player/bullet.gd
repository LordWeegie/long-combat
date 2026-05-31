extends RigidBody3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("oh why")
	print(body)
	if body.is_in_group("question_object"):
		print("test")
		if body.select_option() == true:
			body.select_option()
			queue_free()
	else:
		print("No!")
		queue_free()
