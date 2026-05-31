extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = .001
@onready var pmodel : Node3D = $model
@onready var cam : Camera3D = $head/Camera3D
@export var has_gun := false
@export var bullet_scene : PackedScene = preload("res://scenes/player/bullet.tscn")
@export var dialog_lines : Array[String] = ["Hello, it's me! The Devil!", "Answer these questions correctly to go back to earth!", "If you fail you go to hell (quiet yay)!", "Question 1: What is the best ingredient", "Question 2: Which is the WORST OS", "Question 3: Which game came first", "You won...okay...I lied, either way you go to hell!", "You lost! I'm just going to leave now!"]
@export var question2 : Node3D
@export var question3 : Node3D
@export var question4 : Node3D
var dialog_played := false
var has_failed = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print(cam)
	print(pmodel)
	$player_with_gun.visible = false
var game_ended = false

func _physics_process(delta: float) -> void:
	if question2!=null:
		if question2.option_number == 0 and dialog_played and has_failed == false:
			$head/Camera3D/Label3D.text = dialog_lines[3]
		elif question2.option_number == 1 and has_failed == false:
			$head/Camera3D/Label3D.text = dialog_lines[4]
	# End game when all three questions are at option_number == 2
	if question2!=null:
		if question2.option_number == 30:
			$head/Camera3D/Label3D.text = dialog_lines[5]
			await get_tree().create_timer(3).timeout
			get_tree().quit()
	
	# Rest of your existing physics process (shooting, movement, animations...)
	if Input.is_action_just_pressed("fire") and has_gun:
		if $head/Camera3D/RayCast3D.is_colliding() and $head/Camera3D/RayCast3D.get_collider().is_in_group("question_object"):
			if $head/Camera3D/RayCast3D.get_collider().select_option() == true:
				$head/Camera3D/RayCast3D.get_collider().select_option()
			else:
				has_failed = true
				$head/Camera3D/Label3D.text = dialog_lines[6]
				await get_tree().create_timer(3).timeout
				get_tree().quit()
		
	var is_moving = velocity.x != 0 or velocity.z != 0

	if has_gun:
		if dialog_played == false:
			early_dialogue()

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
		
func early_dialogue():
	await get_tree().create_timer(1).timeout
	$head/Camera3D/Label3D.text = dialog_lines[0]
	await get_tree().create_timer(1).timeout
	$head/Camera3D/Label3D.text = dialog_lines[1]
	await get_tree().create_timer(1).timeout
	$head/Camera3D/Label3D.text = dialog_lines[2]
	dialog_played = true
