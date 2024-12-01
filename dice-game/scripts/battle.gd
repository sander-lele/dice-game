extends Control

var rng = RandomNumberGenerator.new()

@onready var dice_manager = $dice_manager
var dice = []
var damage = 0
var rerolls = 3

@onready var roll_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Roll
@onready var fight_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Fight
@onready var reroll_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Reroll
@onready var items_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Items

@onready var active_character = $battle_UI/player

var round = 1

func _ready() -> void:
	rng.randomize()

func enemy_turn():
	var enemies = $battle_UI.get_child(round).get_children()
	for i in enemies.size():
		var stats = enemies[i].get_stats()
		roll(stats[0],stats[1],stats[2],stats[3])
		$battle_UI/player.hit(damage)




func write_text(text):
	#for now just writes text. will be useful when animating it later
	$bottom_UI/HBoxContainer/text_panel/Label.text = text

func roll(min_roll:int,max_roll:int,dice_count:int,multiplier=1.0):
	#resets the dice array and damage
	damage = 0
	dice = []
	#rolls the dice and puts them into an array. Also claculates the damage
	for i in range(dice_count):
		var dice_result = rng.randi_range(min_roll,max_roll)
		dice.append(dice_result)
		damage += dice_result
	damage *= multiplier
	print(dice,damage)
	

func button_set_default():
	roll_button.visible = true
	fight_button.visible = false
	reroll_button.visible = false
	items_button.visible = true

func button_set_reroll():
	roll_button.visible = false
	fight_button.visible = true
	reroll_button.visible = true
	items_button.visible = true

func _on_roll_pressed() -> void:
	button_set_reroll()
	roll(1,6,4,1)
	print(dice,damage)
	write_text("you rolled " + str(dice) + "\nDo you want to fight or reroll?\nRerolls left:" + str(rerolls))


func _on_reroll_pressed() -> void:
	rerolls -= 1
	if rerolls <= 0:
		reroll_button.disabled = true
	roll(1,6,4,1)
	write_text("you rolled " + str(dice) + "\nDo you want to fight or reroll?\nRerolls left:" + str(rerolls))

func _on_fight_pressed() -> void:
	enemy_turn()
