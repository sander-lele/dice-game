extends TextureRect

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	$Label.text = str(rng.randi_range(1,6))


func _on_timer_timeout() -> void:
	$Timer.wait_time = rng.randi_range(1,6)
	$Label.text = str(rng.randi_range(1,6))
