extends Node

const PORT := 7070
const BALLS_PER_OVER := 6
const CRICKET := preload("res://Cricket Batting Experience.tscn")

var game
var bowler_camera: Camera3D
var balls := 0
var in_play := false
@onready var lobby: CenterContainer = $UI/Lobby
@onready var address: LineEdit = $UI/Lobby/Controls/Address
@onready var status: Label = $UI/Lobby/Controls/Status
@onready var batting: VBoxContainer = $UI/Batting
@onready var swing_button: Button = $UI/Batting/Swing
@onready var over_label: Label = $UI/Over

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(func(_id: int): _leave("Player disconnected."))
	multiplayer.connection_failed.connect(func(): _leave("Could not connect. Check the host IP."))
	multiplayer.server_disconnected.connect(func(): _leave("Host disconnected."))
	$UI/Lobby/Controls/Host.pressed.connect(_connect_game.bind(true))
	$UI/Lobby/Controls/Join.pressed.connect(_connect_game.bind(false))
	swing_button.pressed.connect(_send_swing)

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
	bowler_camera = Camera3D.new()
	bowler_camera.name = "BowlerCamera"
	game.add_child(bowler_camera)
	bowler_camera.position = game.ball_start + Vector3(0, 1.4, -4)
	bowler_camera.look_at(game.to_global(Vector3(0, 0.7, -10)))
	game.bowl_button.pressed.disconnect(game._bowl)
	game.bowl_button.pressed.connect(_send_bowl)
	game.delivery_finished.connect(_finish_delivery)
	lobby.hide()
	over_label.show()
	_apply_over(0, false)

func _is_bowler(peer_id: int) -> bool:
	var host_bowls := balls % (BALLS_PER_OVER * 2) < BALLS_PER_OVER
	return (peer_id == 1) == host_bowls

func _send_bowl() -> void:
	var timing := 1.0 - absf(game.meter.value * 2.0 - 1.0)
	_request_bowl.rpc_id(1, balls, game.bowl_type.selected, timing)

@rpc("any_peer", "call_local", "reliable")
func _request_bowl(delivery: int, mode: int, timing: float) -> void:
	if not multiplayer.is_server() or game == null or in_play or delivery != balls:
		return
	if not _is_bowler(multiplayer.get_remote_sender_id()) or mode < 0 or mode > 2 or not is_finite(timing):
		return
	game.bowl(mode, clampf(timing, 0.0, 1.0))
	_apply_over.rpc(balls, true)

func _finish_delivery() -> void:
	_apply_over.rpc(balls + 1, false)

@rpc("authority", "call_local", "reliable")
func _apply_over(delivered: int, active: bool) -> void:
	balls = delivered
	in_play = active
	var bowling := _is_bowler(multiplayer.get_unique_id())
	game.bowl_button.get_parent().visible = bowling
	game.bowl_button.disabled = active
	batting.visible = not bowling
	swing_button.disabled = not active
	var camera: Camera3D = bowler_camera if bowling else game.get_node("Camera3D")
	camera.make_current()
	over_label.text = "%s · Ball %d of %d" % ["Bowling" if bowling else "Batting", balls % BALLS_PER_OVER + 1, BALLS_PER_OVER]

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
	if game != null and batting.visible and in_play:
		_request_swing.rpc_id(1, balls)

@rpc("any_peer", "call_local", "reliable")
func _request_swing(delivery: int) -> void:
	if not multiplayer.is_server() or game == null or not in_play or delivery != balls:
		return
	if not _is_bowler(multiplayer.get_remote_sender_id()):
		game.swing()

func _leave(message: String) -> void:
	if game != null:
		game.queue_free()
		game = null
	multiplayer.multiplayer_peer = null
	batting.hide()
	over_label.hide()
	lobby.show()
	status.text = message
