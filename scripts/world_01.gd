extends Node2D

@onready var player := $player
@onready var camera := $camera as Camera2D

func _process(_delta):
	if is_instance_valid(player):
		camera.global_position = player.global_position
