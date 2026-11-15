extends Node3D
var ball_in_zone = false
var cooldown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Ball.linear_velocity = Vector3(0, -2, 25)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	cooldown -= delta
	if Input.is_action_just_pressed("swing") and cooldown <= 0:
		cooldown = 1
		if ball_in_zone:
			print("HIT")
			$Ball.linear_velocity = Vector3(45, 15, -40)
			$HitSound.stream = load("res://screen-charm-recording.mp3")
			$HitSound.play()
		else:
			print("MISSED")


func _on_hit_zone_body_entered(body: Node3D):
	if body == $Ball:
		ball_in_zone = true

func _on_hit_zone_body_exited(body: Node3D):
	ball_in_zone = false
