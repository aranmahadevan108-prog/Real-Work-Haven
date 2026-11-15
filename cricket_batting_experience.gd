extends Node3D

signal delivery_finished
var runs = 0
var ball_in_zone = false
var cooldown = 0
var wickets = 0
var local_swing := true
# Called when the node enters the scene tree for the first time.
@onready var ball: RigidBody3D = $Ball
@onready var ball_start: Vector3 = ball.position

var bowl_type := OptionButton.new()
var meter := HSlider.new()
var bowl_button := Button.new()
var meter_time := 0.0
var spin := 0.0
var score_label := Label.new()

func _ready() -> void:
	ball.freeze = true
	ball.contact_monitor = true
	ball.max_contacts_reported = 4
	ball.body_entered.connect(_on_ball_bounce)

	var hud := CanvasLayer.new()
	add_child(hud)

	var controls := VBoxContainer.new()
	controls.position = Vector2(20, 20)
	controls.custom_minimum_size.x = 240
	hud.add_child(controls)

	for mode in ["Pace", "Off Spin", "Leg Spin"]:
		bowl_type.add_item(mode)
	bowl_type.select(0)
	bowl_type.focus_mode = Control.FOCUS_NONE
	controls.add_child(bowl_type)

	var hint := Label.new()
	hint.text = "Fastest at the center"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	controls.add_child(hint)

	meter.max_value = 1.0
	meter.step = 0.001
	meter.tick_count = 3
	meter.editable = false
	meter.focus_mode = Control.FOCUS_NONE
	controls.add_child(meter)

	bowl_button.text = "Bowl"
	bowl_button.focus_mode = Control.FOCUS_NONE
	bowl_button.pressed.connect(_bowl)
	controls.add_child(bowl_button)

	score_label.position = Vector2(20, 220)
	score_label.add_theme_font_size_override("font_size", 28)
	hud.add_child(score_label)

	if local_swing:
		var swing_button := Button.new()
		swing_button.text = "Swing (Space)"
		swing_button.focus_mode = Control.FOCUS_NONE
		swing_button.pressed.connect(swing)
		controls.add_child(swing_button)

func _bowl() -> void:
	var timing := 1.0 - absf(meter.value * 2.0 - 1.0)
	bowl(bowl_type.selected, timing)

func bowl(mode: int, timing: float) -> void:
	bowl_button.disabled = true
	var speed := lerpf(21.0, 33.0, timing) if mode == 0 else lerpf(18.0, 25.0, timing)
	spin = [0.0, -0.9, 0.9][mode]

	ball_in_zone = false
	ball.position = ball_start
	ball.freeze = false
	ball.angular_velocity = Vector3.ZERO
	ball.linear_velocity = Vector3(0.0, -2.0, speed)
	ball.sleeping = false

	await get_tree().create_timer(2.5).timeout
	ball.freeze = true
	ball.position = ball_start
	bowl_button.disabled = false
	delivery_finished.emit()

func _on_ball_bounce(body: Node) -> void:
	if body == $Pitch and spin != 0.0:
		ball.apply_central_impulse.call_deferred(Vector3(spin * ball.mass, 0.0, 0.0))
		spin = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	score_label.text = "Runs: " + str(runs) + "  Wickets: " + str(wickets)

	# arrow keys move the camera, W/S move it forward/back
	var cam = $Camera3D
	if Input.is_key_pressed(KEY_LEFT):
		cam.position.x -= 3 * delta
	if Input.is_key_pressed(KEY_RIGHT):
		cam.position.x += 3 * delta
	if Input.is_key_pressed(KEY_UP):
		cam.position.y += 3 * delta
	if Input.is_key_pressed(KEY_DOWN):
		cam.position.y -= 3 * delta
	if Input.is_key_pressed(KEY_W):
		cam.position.z -= 3 * delta
	if Input.is_key_pressed(KEY_S):
		cam.position.z += 3 * delta
	if not bowl_button.disabled:
		meter_time += delta
		meter.value = pingpong(meter_time, 1.0)
	
	cooldown -= delta
	if local_swing and Input.is_action_just_pressed("swing"):
		swing()
func swing() -> void:
	if cooldown > 0:
		return
	cooldown = 1
	swing_bat()
	if ball_in_zone:
		print("HIT")
		runs += 6
		ball.linear_velocity = Vector3(45, 15, -40)
		$HitSound.stream = load("res://screen-charm-recording.mp3")
		$HitSound.play()
	else:
		print("MISSED")


func _on_hit_zone_body_entered(body: Node3D):
	if body == $Ball:
		ball_in_zone = true

func _on_hit_zone_body_exited(body: Node3D):
	ball_in_zone = false


func _on_stumps_body_entered(body: Node3D) -> void:
	if body == $Ball:
		wickets += 1
		print("OUT! Wickets: ", wickets)

func swing_bat():
	var tween = create_tween()
	tween.tween_property($Batsman/BatPivot, "rotation_degrees:x", 100, 0.12)
	tween.tween_property($Batsman/BatPivot, "rotation_degrees:x", 0, 0.25)
