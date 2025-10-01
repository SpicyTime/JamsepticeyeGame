extends CharacterBody2D
var active_state: Node = null
var input_vector: Vector2 = Vector2.ZERO
var resurrection_count: int = 0
var max_resurrection_count: int = 3
var max_mana: float = 100.0
var current_mana: float = max_mana
var mana_drain: float = 0.01
var body_position: Vector2 = Vector2.ZERO
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
 

func _physics_process(delta: float) -> void:
	# Handles movement input
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	if input_vector != Vector2.ZERO:
		velocity = lerp(velocity, input_vector.normalized() * active_state.MAX_SPEED, delta * active_state.ACCELERATION)
	else:
		velocity = lerp(velocity, input_vector.normalized() * active_state.MAX_SPEED, delta * active_state.FRICTION)
	move_and_slide()


func resurrect() -> void:
	print("Resurrecting")
	active_state = $LivingState
	resurrection_count += 1
	$CollisionShape2D.disabled = false
	# Deletes the dead body
	var main_node = get_tree().root.get_node("Main")
	main_node.get_node("Game").get_node("DeadBodySprite").queue_free()
	
	mana_drain_timer.stop()
	
	position = body_position
	
	velocity = Vector2.ZERO  

func die() -> void:
	active_state = $DeadState
	$CollisionShape2D.disabled = true
	current_mana = max_mana
	mana_drain_timer.start()
	spawn_body()
	if resurrection_count == max_resurrection_count:
		SignalManager.player_fully_dead.emit()
		get_tree().reload_current_scene()


func swap_living_status(living: bool) -> void:
	# Handles death
	if not living and active_state != $DeadState:
		die()
	# Handles life
	elif living and active_state != $LivingState and resurrection_count <  max_resurrection_count :
		resurrect()


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
	current_mana -= max_mana * mana_drain
	print(current_mana)
	if current_mana <= 1:
		swap_living_status(true)
