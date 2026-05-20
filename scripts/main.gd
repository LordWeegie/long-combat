extends Node3D

func _ready() -> void:
	GDSync.connected.connect(connected)
	GDSync.connection_failed.connect(connection_failed)
	
	GDSync.lobby_created.connect(lobby_created)
	GDSync.lobby_creation_failed.connect(lobby_creation_failed)
	
	GDSync.lobby_joined.connect(lobby_joined)
	GDSync.lobby_join_failed.connect(lobby_join_failed)
	GDSync.start_multiplayer()
	
	
func connection_failed(error: int) -> void:
	match(error):
		ENUMS.CONNECTION_FAILED.INVALID_PUBLIC_KEY:
			push_error("The public or private key you entered were invalid.")
		ENUMS.CONNECTION_FAILED.TIMEOUT:
			push_error("Unable to connect, please check your internet connection.")
	
func connected():
	print("Connected!")
	
	GDSync.lobby_create("TestLobby")
	
func lobby_created(lobby_name : String) -> void:
	print("Created lobby ", lobby_name)

func lobby_creation_failed(lobby_name : String, error : int) -> void:
	print("Failed to create lobby ", lobby_name)
	if error == ENUMS.LOBBY_CREATION_ERROR.LOBBY_ALREADY_EXISTS:
		GDSync.lobby_join(lobby_name)
	
func lobby_joined(lobby_name : String) -> void:
	print("Joined lobby ", lobby_name)
func lobby_join_failed(lobby_name : String, error : int):
	print("Lobby join failed ", lobby_name)
