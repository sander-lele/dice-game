extends Sprite2D

signal enemy_selected

@export var hp: int = 100
@export var min_roll: int = 1
@export var max_roll: int = 6
@export var dice_count: int = 1
@export var multiplier: int = 1
@export var turn_counter_start: int = 0
var turn_counter = 0

func _ready() -> void:
	if turn_counter_start > 0:
		turn_counter = turn_counter_start
		$turn_label.visible = true
		$turn_label.text = str(turn_counter)
	else:
		$turn_label.visible = false
	$ProgressBar.max_value = hp
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)

func get_stats():
	return [min_roll,max_roll,dice_count,multiplier]

func attack():
	pass
	#could be used later for animating

func tic_turn_counter():
	if turn_counter <= 0:
		turn_counter = turn_counter_start
	else:
		turn_counter -= 1
	$turn_label.text = str(turn_counter)

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
