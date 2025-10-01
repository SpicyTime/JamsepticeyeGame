extends Node
## Preload ui menus ##

enum UiMenuType{
	
}
var ui_menus: Dictionary[String, Control] = {}
## Preload overlays ##

enum UiOverlayType{
	
}
var ui_overlays: Dictionary[String, Control] = {}

var active_overlays: Array[Control] = []
var active_menu: Control = null
func set_up_ui(canvas_item: CanvasItem) -> void:
	var overlays: Control = canvas_item.get_child(0)
	var menus: Control = canvas_item.get_child(1)
	# Sets up menus
	for menu in menus.get_children():
		ui_menus.set(menu.name, menu)
	# Sets up overlays
	for overlay in overlays.get_children():
		ui_overlays.set(overlay.name, overlay)


func show_overlay(overlay_key: String) -> void:
	if not ui_overlays.has(overlay_key):
		push_error("Failed to show overlay. Overlay %s does not exist" % overlay_key)
	var overlay: Control = ui_overlays[overlay_key]
	overlay.visible = true
	active_overlays.push_back(overlay)


func hide_overlay(overlay_key: String) -> void:
	if not ui_overlays.has(overlay_key):
		push_error("Failed to hide overlay. Overlay %s does not exist" % overlay_key)
	var overlay: Control = ui_overlays[overlay_key]
	if overlay in ui_overlays:
		ui_overlays.erase(overlay)


func swap_menu(menu_key: String) -> void:
	if not ui_menus.has(menu_key):
		push_error("Menu %s does not exist")
	var menu: Control = ui_menus[menu_key]
	if active_menu:
		active_menu.visible = false
	active_menu = menu
	active_menu.visible = true
