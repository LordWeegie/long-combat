extends Node3D

# Do not forget to assign the player scene in the inspector
@export var player_scene : PackedScene
func _ready() -> void:
	# Listen for when clients join or leave the current lobby
	GDSync.client_joined.connect(client_joined)
	GDSync.client_left.connect(client_left)
func client_joined(client_id : int) -> void:
	print("Client joined ", client_id)
	# Check if the client that just joined is our own local client
	if client_id == GDSync.get_client_id():
		print("Own id ", client_id)
	# Instantiate the player scene and set its name to the client ID
	var player : CharacterBody3D = player_scene.instantiate()
	add_child(player)
	player.name = str(client_id)
	# Grant this specific client ownership over their player node
	GDSync.set_gdsync_owner(player, client_id)
func client_left(client_id : int) -> void:
	print("Client left ", client_id)
	# Find the player node associated with the disconnected client and remove it
	var player : Node2D = get_node_or_null(str(client_id))
	if player != null:
		player.queue_free()
