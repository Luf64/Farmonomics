extends CanvasLayer

@onready var buttons = [
	$"control/volume/1",
	$"control/volume/2",
	$"control/volume/3",
	$"control/volume/4",
	$"control/volume/5",
	$"control/volume/6",
	$"control/volume/7",
	$"control/volume/8",
	$"control/volume/9",
	$"control/volume/10"
]
@onready var sound = $control/sound

var bar_textures = {
	"on": preload("res://Assets/setting icon/Settings_sound_1.png"),
	"off": preload("res://Assets/setting icon/Settings_sound_0.png")
}

var sound_textures = {
	"on": preload("res://Assets/setting icon/Settings_sound_icon_on.png"),
	"off": preload("res://Assets/setting icon/Settings_sound_icon.png")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("setting")
	Json.load_game()
	refresh_ui()

func _on_help_pressed() -> void:
	$"control/help/Panel".visible = true
	await get_tree().create_timer(10.0).timeout
	$"control/help/Panel".visible = false

func _on_save_pressed() -> void:
	Json.save_game()
	pass # Replace with function body.

func _on_close_pressed() -> void:
	Json.save_game()
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()

func _on_sound_pressed() -> void:
	Global.is_muted = !Global.is_muted
	sound.texture_normal = sound_textures["off"] if Global.is_muted else sound_textures["on"]
	Global.apply_volume()
	Json.save_game()

func set_volume_level(level: int) -> void:
	level = clamp(level, 0, 10)

	Global.sound_percent = level * 10.0
	if level > 0:
		Global.is_muted = false
	for i in range(buttons.size()):
		if i < level:
			buttons[i].texture_normal = bar_textures["on"]
		else:
			buttons[i].texture_normal = bar_textures["off"]
	Global.apply_volume()

func _on_1_pressed() -> void:
	set_volume_level(1)

func _on_2_pressed() -> void:
	set_volume_level(2)

func _on_3_pressed() -> void:
	set_volume_level(3)

func _on_4_pressed() -> void:
	set_volume_level(4)

func _on_5_pressed() -> void:
	set_volume_level(5)
	print(Global.sound_percent)

func _on_6_pressed() -> void:
	set_volume_level(6)

func _on_7_pressed() -> void:
	set_volume_level(7)

func _on_8_pressed() -> void:
	set_volume_level(8)

func _on_9_pressed() -> void:
	set_volume_level(9)

func _on_10_pressed() -> void:
	set_volume_level(10)
	print(Global.sound_percent)

func refresh_ui() -> void:
	print("Refreshing UI")
	print(Global.sound_percent)
	print(Global.is_muted)
	set_volume_level(Global.sound_percent / 10)
	sound.texture_normal = sound_textures["off"] if Global.is_muted else sound_textures["on"]

func _on_close_button_pressed() -> void:
	var room = get_parent()
	room.setting_open = false
	room.setting = null
	queue_free()
	pass # Replace with function body.
