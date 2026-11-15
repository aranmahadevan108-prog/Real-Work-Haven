extends Node

const PORT := 7070
const CRICKET := preload("res://Cricket Batting Experience.tscn")

var game
@onready var lobby: CenterContainer = $UI/Lobby
@onready var address: LineEdit = $UI/Lobby/Controls/Address
@onready var status: Label = $UI/Lobby/Controls/Status
@onready var batting: VBoxContainer = $UI/Batting

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(func(_id: int): _leave("Player disconnected."))
	multiplayer.connection_failed.connect(func(): _leave("Could not connect. Check the host IP."))
	multiplayer.server_disconnected.connect(func(): _leave("Host disconnected."))
	$UI/Lobby/Controls/Host.pressed.connect(_connect_game.bind(true))
	$UI/Lobby/Controls/Join.pressed.connect(_connect_game.bind(false))
	$UI/Batting/Swing.pressed.connect(_send_swing)

func _connect_game(host: bool) -> void:
	if multiplayer.multiplayer_peer is ENetMultiplayerPeer:
		return
	if not host and address.text.strip_edges().is_empty():
		status.text = "Enter the host IP address."
		return
	var peer := ENetMultiplayerPeer.new()
	var result := peer.create_server(PORT, 1) if host else peer.create_client(address.text.strip_edges(), PORT)
	if result != OK:
		status.text = error_string(result)
		return
	multiplayer.multiplayer_peer = peer
	status.text = "Waiting for batter on port %d…" % PORT if host else "Connecting…"

func _on_peer_connected(id: int) -> void:
	if multiplayer.is_server():
		_start_match()
		_start_match.rpc_id(id)

@rpc("authority", "call_remote", "reliable")
func _start_match() -> void:
	game = CRICKET.instantiate()
	game.local_swing = false
	add_child(game)
	lobby.hide()
	if not multiplayer.is_server():
		game.set_process(false)
		game.bowl_button.get_parent().hide()
		batting.show()

func _physics_process(_delta: float) -> void:
	if game != null and multiplayer.is_server():
		_sync_ball.rpc(game.ball.position)

@rpc("authority", "call_remote", "unreliable_ordered")
func _sync_ball(position: Vector3) -> void:
	if game != null:
		game.ball.position = position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.physical_keycode == KEY_SPACE and event.pressed and not event.echo:
		_send_swing()

func _send_swing() -> void:
	if game != null and not multiplayer.is_server():
		_request_swing.rpc_id(1)

@rpc("any_peer", "call_remote", "reliable")
func _request_swing() -> void:
	if game != null and multiplayer.is_server() and game.bowl_button.disabled:
		game.swing()

func _leave(message: String) -> void:
	if game != null:
		game.queue_free()
		game = null
	multiplayer.multiplayer_peer = null
	batting.hide()
	lobby.show()
	status.text = message
