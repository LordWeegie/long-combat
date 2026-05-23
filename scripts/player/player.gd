extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = .001
@onready var pmodel : Node3D = $model
@onready var cam : Camera3D = $head/Camera3D
@export var has_gun := false
@export var bullet_scene : PackedScene = preload("res://scenes/player/bullet.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print(cam)
	print(pmodel)
	$player_with_gun.visible = false

func _physics_process(delta: float) -> void:
	var is_moving = velocity.x != 0 or velocity.z != 0

	if has_gun:
		$player_with_gun.visible = true
		$model.visible = false
	else:
		$model.visible = true
		$player_with_gun.visible = false
	# Add the gravity.
	if not is_on_floor():
		velocity += ProjectSettings.get_setting("physics/3d/default_gravity") * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if is_moving and !has_gun:
		$model/AnimationPlayer.play("Armature|mixamo_com|Layer0")
	elif !is_on_floor() and !has_gun:
		$model/AnimationPlayer.play("Armature|mixamo_com|Layer0")
	elif is_moving:
		if has_gun:
			$player_with_gun/AnimationPlayer.play("mixamo_com")
	else:
		# Stop ALL animation players when not moving
		$model/AnimationPlayer.stop()
		$model/AnimationPlayer.seek(0, true)
		$player_with_gun/AnimationPlayer.stop()
		$player_with_gun/AnimationPlayer.seek(0, true)

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
