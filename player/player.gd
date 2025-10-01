extends CharacterBody2D
var active_container: Node = null
var input_vector: Vector2 = Vector2.ZERO

func _ready() -> void:
	swap_living_status(true)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("kill_self"):
			if active_container == $LivingContainer:
				swap_living_status(false)
			else:
				swap_living_status(true)


func _physics_process(delta: float) -> void:
	# Handles movement input
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	if input_vector != Vector2.ZERO:
		velocity = lerp(velocity, input_vector.normalized() * active_container.MAX_SPEED, delta * active_container.ACCELERATION)
	else:
		velocity = lerp(velocity, input_vector.normalized() * active_container.MAX_SPEED, delta * active_container.FRICTION)
	move_and_slide()


func swap_living_status(living: bool) -> void:
	if living:
		active_container = $LivingContainer
		print("Swapping to Living")
	else:
		active_container = $DeadContainer
		print("Swapping to Dead")
