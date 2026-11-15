extends Control

func _play_single() -> void:
	get_tree().change_scene_to_file("res://Cricket Batting Experience.tscn")

func _play_double() -> void:
	get_tree().change_scene_to_file("res://lan_lobby.tscn")
