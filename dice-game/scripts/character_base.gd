extends Sprite2D

signal enemy_selected

signal signal_hit
signal signal_attack
signal signal_turn_tick

@export var max_hp: int = 100 * BatMak.difficulty
@export var min_roll: int = 1
@export var max_roll: int = 6
@export var dice_count: int = 1
@export var multiplier: int = 1 * BatMak.difficulty
@export var turn_counter_start: int = 0
@export_enum("passive","aggressive") var attack_type = "aggressive"
var turn_counter = 0
var hp

func _ready() -> void:
	if turn_counter_start > 0:
		turn_counter = turn_counter_start
		$turn_label.visible = true
		$turn_label.text = str(turn_counter)
	else:
		$turn_label.visible = false
	hp = max_hp
	$ProgressBar.max_value = max_hp
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)

func get_stats():
	return [min_roll,max_roll,dice_count,multiplier]

func attack():
	if attack_type == "agressive":
		emit_signal("signal_attack")
	#could be used later for animating

func tic_turn_counter():
	if visible == true:
		if turn_counter <= 0:
			turn_counter = turn_counter_start
		else:
			turn_counter -= 1
		$turn_label.text = str(turn_counter)
		emit_signal("signal_turn_tick")

func hit(damage=0):
	emit_signal("signal_hit")
	hp = clamp(hp-damage,0,max_hp)
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)
	if hp <= 0:
		die()

func heal(heal_amount=10):
	hp = clamp(hp+heal_amount,0,max_hp)
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)
	if hp >= 0:
		turn_counter = turn_counter_start
		visible = true

func die():
	visible = false


func _on_button_pressed() -> void:
	emit_signal("enemy_selected",self)
