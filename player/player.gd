extends CharacterBody2D
class_name Player
var active_state: Node = null
var input_vector: Vector2 = Vector2.ZERO
var facing_vector: Vector2 = Vector2(1, -1)
var movement_vector: Vector2 = Vector2.ZERO
var resurrection_count: int = 0
var max_resurrection_count: int = 3
var max_mana: int = 100
var current_mana: int = max_mana
var mana_drain: float = 0.01
var body_position: Vector2 = Vector2.ZERO
var prev_animation_path: String = ""
@onready var mana_drain_timer: Timer = $ManaDrainTimer

func _ready() -> void:
	active_state = $LivingState


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("kill_self"): 
			if active_state == $LivingState:
				swap_living_status(false)
			else:
				swap_living_status(true)
		if Input.is_action_just_pressed("activate_ability"):
			SignalManager.interacted.emit(get_tree().get_first_node_in_group("Current Interactables"), self)


func _physics_process(delta: float) -> void:
	# Handles movement input
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	if input_vector != Vector2.ZERO:
		velocity = lerp(velocity, input_vector.normalized() * active_state.MAX_SPEED, delta * active_state.ACCELERATION)
	else:
		velocity = lerp(velocity, input_vector.normalized() * active_state.MAX_SPEED, delta * active_state.FRICTION)
	
	_handle_animations()
	move_and_slide()


func _handle_animations() -> void:
	# Only changes the facing direction if the input vector has changed and is not (0, 0)
	if facing_vector != input_vector and input_vector != Vector2.ZERO:
		facing_vector = input_vector
	var animation_path: String = ""
	# Plays it from the spirit sheet if the player is dead
	if active_state != $LivingState:
		animation_path = "spirit_"
	# Checks for diagnal facing
	if facing_vector.x != 0 and facing_vector.y != 0:
		animation_path += "diag_"
	# Front and Back
	if sign(facing_vector.y) == -1:
		animation_path += "back_"
	elif sign(facing_vector.y) == 1:
		animation_path += "front_"
	# Side
	if facing_vector.x != 0 and not "diag" in animation_path:
		animation_path += "side_"
	# Walk and Idle
	if input_vector != Vector2.ZERO and not "spirit" in animation_path :
		animation_path += "walk"
	elif input_vector == Vector2.ZERO and not "spirit" in animation_path:
		animation_path += "idle"
	# Removes the last _ from the path if it is in spirit mode
	if "spirit" in animation_path:
		animation_path = animation_path.substr(0, animation_path.length() - 1)
	# Flipping sprite
	if facing_vector.x == -1:
		$AnimatedSprite2D.flip_h = false
	elif facing_vector.x == 1:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play(animation_path)


func consume_mana(amount: int):
	current_mana -= amount
	SignalManager.player_mana_changed.emit(current_mana)


func resurrect() -> void:
	print("Resurrecting")
	active_state = $LivingState
	resurrection_count += 1
	# Deletes the dead body
	var main_node = get_tree().root.get_node("Main")
	var body_sprite: Sprite2D = main_node.get_node("Game").get_node("DeadBodySprite")
	if body_sprite:
		body_sprite.queue_free()
		
	mana_drain_timer.stop()
	position = body_position
	velocity = Vector2.ZERO  
	# Invincibility
	$Hurtbox.set_collision_mask_value(2, false)
	$InvincibilityTimer.start()
	SignalManager.player_resurrect.emit()


func die() -> void:
	print("Dead")
	active_state = $DeadState
	current_mana = max_mana
	mana_drain_timer.start()
	spawn_body()
	if resurrection_count == max_resurrection_count:
		SignalManager.player_fully_dead.emit()
		get_tree().call_deferred("reload_current_scene")


func swap_living_status(living: bool) -> void:
	# Handles death
	if not living and active_state != $DeadState:
		die()
	# Handles life
	elif living and active_state != $LivingState and resurrection_count <  max_resurrection_count :
		resurrect()
	SignalManager.swapped_live_mode.emit(living)


func spawn_body() -> void: 
	var dead_body_sprite: Sprite2D = Sprite2D.new()
	# Sets up the sprite
	dead_body_sprite.texture = preload("res://icon.svg")  
	dead_body_sprite.position = position
	body_position = position
	dead_body_sprite.name = "DeadBodySprite"
	# Adds to tree
	var main_node = get_tree().root.get_node("Main")
	main_node.get_node("Game").add_child(dead_body_sprite)


func _on_mana_drain_timer_timeout() -> void:
	var passive_mana_removal: int =  int(max_mana * mana_drain)
	consume_mana(passive_mana_removal)
	if current_mana <= 1:
		swap_living_status(true)


func _on_invincibility_timer_timeout() -> void:
	$Hurtbox.set_collision_mask_value(2, true)
