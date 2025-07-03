extends Camera2D

@export var player: CharacterBody2D

func _process(delta):
	## setting camera position to player, with camera smoothing
	if player:
		global_position = global_position.lerp(player.global_position, 5 * delta)
