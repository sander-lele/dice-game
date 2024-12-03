extends Sprite2D

signal enemy_selected

@export var hp: int = 100
@export var min_roll: int = 1
@export var max_roll: int = 6
@export var dice_count: int = 1
@export var multiplier: int = 1

func _ready() -> void:
	$ProgressBar.max_value = hp
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)

func get_stats():
	return [min_roll,max_roll,dice_count,multiplier]

func hit(damage):
	hp -= damage
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)
	if hp <= 0:
		die()

func die():
	queue_free()


func _on_button_pressed() -> void:
	emit_signal("enemy_selected",self)
