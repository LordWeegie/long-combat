extends Node3D
var is_doom = false
@export var is_correct = false
@onready var label = $Label3D
@export var options: Array[String] = []
var option_number = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = options[option_number]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if option_number < 3:
		label.text = options[option_number]
	if option_number==0:
		print("cheese")
		if options[option_number] == "Godot":
			print("cheese!")
			is_correct = true
	elif option_number==1 and options[option_number] == "doom":
		print("doom?")
		is_doom = true
		is_correct = true
	else:
		is_correct = false

	
func select_option():
	print("something")
	if is_correct:
		if is_doom:
			option_number = 30
			return true
		print("Correct answer")
		var question_objects = get_tree().get_nodes_in_group("question_object")
		if question_objects[1].option_number==0:
			for i in range(question_objects.size()):
				question_objects[i].option_number=2
			return true
		elif question_objects[1].option_number==2:
			for i in range(question_objects.size()):
				question_objects[i].option_number = 1
			return true
		elif question_objects[1].option_number==1:
			for i in range(question_objects.size()):
				question_objects[i].option_number = 2
			return true
	else:
		print("Nope")
		return false
