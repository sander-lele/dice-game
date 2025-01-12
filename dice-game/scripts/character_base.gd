extends Node2D

@warning_ignore("unused_signal")
signal enemy_selected

@warning_ignore("unused_signal")
signal signal_hit
@warning_ignore("unused_signal")
signal signal_attack
@warning_ignore("unused_signal")
signal signal_turn_tick

@export var max_hp: int = 100
@export var min_roll: int = 1
@export var max_roll: int = 6
@export var dice_count: int = 1
@export var multiplier: int = 1
@export var turn_counter_start: int = 0
@export_enum("passive","aggressive") var attack_type = "aggressive"
var turn_counter = 0
var hp
var heal_per_round = 25

var rng = RandomNumberGenerator.new()

@onready var turn_label = $turn_counter/turn_label

func play_hit():
	$sounds/hit.pitch_scale = rng.randf_range(0.75,1.25)
	$sounds/hit.play()

func play_heal():
	if hp != max_hp:
		$sounds/heal.pitch_scale = rng.randf_range(0.75,1.25)
		$sounds/heal.play()

func disable_button():
	$Button.disabled = true

func enable_button():
	$Button.disabled = false

func _ready() -> void:
	max_hp *= BatMak.difficulty
	multiplier *= BatMak.difficulty
	if turn_counter_start > 0:
		turn_counter = turn_counter_start
		$turn_counter.visible = true
		turn_label.text = str(turn_counter)
	else:
		$turn_counter.visible = false
	hp = max_hp
	$ProgressBar.max_value = max_hp
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)

func get_stats():
	return [min_roll,max_roll,dice_count,multiplier]

func attack():
	if attack_type == "aggressive":
		$AnimationPlayer.play("attack")

func tic_turn_counter():
	if visible == true:
		turn_counter -= 1
		turn_label.text = str(turn_counter)
		emit_signal("signal_turn_tick")

func hit(damage=0):
	play_hit()
	$AnimationPlayer.play("hit")
	emit_signal("signal_hit")
	hp = clamp(hp-damage,0,max_hp)
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)
	if hp <= 0:
		die()

func heal(heal_amount=10):
	play_heal()
	hp = clamp(hp+heal_amount*BatMak.difficulty,0,max_hp)
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)

func revive(heal_amount=10):
	play_heal()
	if hp <= 0:
		hp = clamp(10 * BatMak.difficulty,0,max_hp)
		$ProgressBar.value = hp
		$ProgressBar/Label.text = str(hp)
		turn_counter = turn_counter_start
		visible = true

func die():
	visible = false

func heal_prot(prot=heal_per_round):
	play_heal()
	print(max_hp/100*prot)
	hp = clamp(hp+(max_hp/100*prot),0,max_hp)
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)

func over_heal(heal_amount=25):
	play_heal()
	max_hp += roundi((heal_amount*BatMak.difficulty)/2)
	hp = clamp(hp+heal_amount*BatMak.difficulty,0,max_hp)
	$ProgressBar.max_value = max_hp
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)

func _on_button_pressed() -> void:
	emit_signal("enemy_selected",self)



func _on_buff_select_buff_selected(array) -> void:
	#gets the varible by name then adds the buff amount to it
	play_heal()
	set(array[3],get(array[3])+array[5])
	$ProgressBar.max_value = max_hp
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)




func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		$AnimationPlayer.play("idle")


func _on_signal_attack() -> void:
	if turn_counter <= 0:
		turn_counter = turn_counter_start
		turn_label.text = str(turn_counter)
