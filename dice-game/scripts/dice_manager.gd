extends Control

var dice_scene = load("res://scenes/game parts/dice_base.tscn")

var rng = RandomNumberGenerator.new()
var reroll = 3
var dice = []
var damage = 0

var dice_stats = []

var total_gap_time = 1
var revealed_dice = -5

@onready var dice_nodes = $Panel/HBoxContainer/GridContainer
@onready var damage_counter = $Panel/HBoxContainer/Panel2/damage_counter/number

func _ready():
	#gets called once
	rng.randomize()

func roll(min_roll:int,max_roll:int,dice_count:int,multiplier=1.0):
	#resets the dice array,damage and the visible dice.
	damage = 0
	dice = []
	get_tree().call_group("dice_base","queue_free")
	#rolls the dice and puts them into an array. Also claculates the damage
	for i in range(dice_count):
		var dice_result = rng.randi_range(min_roll,max_roll)
		dice.append(dice_result)
		damage += dice_result
		draw_dice(dice_result)
	damage = round(damage * multiplier)
	dice_stats = [min_roll,max_roll]
	$roll.play()
	animate_dice()
	return damage

func draw_dice(dice_result):
	var inst = dice_scene.instantiate()
	inst.get_child(0).text = str(dice_result)
	dice_nodes.add_child(inst)

func animate_dice():
	$random_timer.start()
	$reveal_timer.start()

func _on_random_timer_timeout() -> void:
	for i in dice.size():
		var dice_result = rng.randi_range(dice_stats[0],dice_stats[1])
		dice_nodes.get_child(i).get_child(0).text = str(dice_result)
	if $reveal_timer.time_left <= 0.05:
		$roll.stop()
	damage_counter.text = str(rng.randi_range(0,500))


func _on_reveal_timer_timeout() -> void:
	$roll.stop()
	$reveal_timer.stop()
	$random_timer.stop()
	damage_counter.text = str(damage)
	for i in dice.size():
		dice_nodes.get_child(i).get_child(0).text = str(dice[i])
		$done.play()
		$done.pitch_scale += 0.2
		dice_nodes.get_child(i).bump()
		await get_tree().create_timer(0.05).timeout
	$done.pitch_scale = 1
