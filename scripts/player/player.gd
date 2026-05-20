extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = .001
@onready var pmodel : Node3D = $model
@onready var cam : Camera3D = $head/Camera3D

func _ready():
	GDSync.connect_gdsync_owner_changed(self, owner_changed)
	print(cam)
	print(pmodel)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func owner_changed(owner_id : int) -> void:
	var is_owner : bool = GDSync.is_gdsync_owner(self)



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if velocity.x > 0 or velocity.x < 0 or velocity.z < 0 or velocity.z > 0:
		$model/AnimationPlayer.play("Armature|mixamo_com|Layer0")
	else:
		$model/AnimationPlayer.stop()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("right", "left", "down", "up")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENS)
		var new_rot = cam.rotation.x + (-event.relative.y * MOUSE_SENS)
		cam.rotation.x = clamp(new_rot, deg_to_rad(-60), deg_to_rad(60))
