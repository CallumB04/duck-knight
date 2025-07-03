extends CharacterBody2D

## -- Player Movement Variables --
const MAX_WALK_SPEED: float = 50.0;
const MAX_SPRINT_SPEED: float = 75.0;
const ACCELERATION: float = 300.0;
var current_speed: float = 0.0;
var is_sprinting: bool = false;
var facing_direction = "down"; ## left, right, up, down. if diagonal, priorities horizontal


## runs once every frame
func _process(delta):
	update_player_movement(delta);

## -- Update Functions --

func update_player_movement(delta):
	## using WASD to decide what direction[s] to move the player
	## in Godot project settings, WASD is mapped to "left", "right", "up" and "down"
	var direction = Input.get_vector("left", "right", "up", "down");
	
	is_sprinting = Input.is_key_pressed(KEY_SHIFT); ## true or false
	
	## updating direction facing for animations
	if direction.x > 0:
		facing_direction = "right";
	elif direction.x < 0:
		facing_direction = "left";
	elif direction.y > 0:
		facing_direction = "down";
	elif direction.y < 0:
		facing_direction = "up";
	
	## accelerating players current speed
	if direction.x != 0 || direction.y != 0:
		current_speed += ACCELERATION * delta;
		
		## walking
		if !is_sprinting && current_speed > MAX_WALK_SPEED:
			current_speed = MAX_WALK_SPEED;
		## sprinting
		elif is_sprinting && current_speed > MAX_SPRINT_SPEED:
			current_speed = MAX_SPRINT_SPEED;
	## reset player speed when stop moving
	else:
		current_speed = 0;
		
	## zooming out when sprinting
	if is_sprinting:
		var zoom_transition = create_tween();
		zoom_transition.tween_property($"../Camera2D", "zoom", Vector2(2.8, 2.8), 0.4);
	## zooming back in when end sprint
	else:
		var zoom_transition = create_tween();
		zoom_transition.tween_property($"../Camera2D", "zoom", Vector2(3.0, 3.0), 0.4);
	
	## velocity is a pre-existing class variable for movement
	## delta is not factored in, since move_and_slide() does automatically
	velocity = direction * current_speed;
	
	move_and_slide(); ## built in function to move CharacterBody2D's	update_player_movement();
	
