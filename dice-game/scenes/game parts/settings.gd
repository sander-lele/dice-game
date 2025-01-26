extends CanvasLayer

signal button_pressed

var mouse_on_panel = false
var music_bus = 0
var sound_bus = 0
func _ready():
	music_bus = AudioServer.get_bus_index("music")
	sound_bus = AudioServer.get_bus_index("sound")

func _physics_process(_delta):
	if visible == false:
		mouse_on_panel = false
	get_tree().paused = visible
	if Input.is_action_just_pressed("esc"):
		visible = not visible



func _on_sound_value_changed(value):
	AudioServer.set_bus_volume_db(sound_bus,linear_to_db(value))


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus,linear_to_db(value))


func _on_sound_drag_started() -> void:
	$AudioStreamPlayer.play()


func _on_sound_drag_ended(value_changed: bool) -> void:
	$AudioStreamPlayer.stop()


func _on_close_pressed() -> void:
	visible = false
