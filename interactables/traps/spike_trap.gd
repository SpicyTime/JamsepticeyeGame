extends Node2D
var reveal_mana_cost: int = 15
var disable_mana_cost: int = 20
var disabled: bool = false
var revealed: bool = false
const SPIKE_DISABLED = preload("res://interactables/traps/spike_disabled.mp3")
const SPIKE_ACTIVATE = preload("res://interactables/traps/unsheath_sword-6113.mp3")

func _ready() -> void:
	SignalManager.swapped_live_mode.connect(func(alive):
		if alive and not revealed:
			visible = false
			
		else:
			visible = true
			modulate.a *= 0.5
		)
	$Activated.stream = SPIKE_ACTIVATE
	$Disabled.stream = SPIKE_DISABLED

func handle_interact(player: Player) -> void:
	if not revealed:
		player.consume_mana(reveal_mana_cost)
		revealed = true
		modulate.a = 255
		return
		
	if not disabled:
		$Hitbox/CollisionShape2D.disabled = true
		$Interactable/Area2D/CollisionShape2D.disabled = true
		player.consume_mana(disable_mana_cost)
		disabled = true
		$AnimatedSprite2D.play("disabled")
		$Disabled.play()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is HurtBox and area.get_parent().is_alive():
		$AnimatedSprite2D.play("popup")
		$Activated.play()
		visible = true
		modulate.a = 255
		area.get_parent().swap_living_status(false)
		await area.get_parent().get_node("AnimatedSprite2D").animation_finished
		UiManager.show_overlay("DeadOverlay")
		var texture: Texture2D= preload("res://player/textures/BigDeadBodySprite.png")
		
		UiManager.ui_overlays["DeadOverlay"].get_node("VBoxContainer/PlayerIcon").texture = texture
		UiManager.ui_overlays["DeadOverlay"].get_node("VBoxContainer/DeadLabel").text = "You Actually Died"
		get_tree().paused = true
		
