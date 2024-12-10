extends Control

var rng = RandomNumberGenerator.new()

@onready var player_stats = $battle_UI/player.get_stats()

var dice = []
var damage = 0
var rerolls = 3

var player_attack = false

@onready var roll_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Roll
@onready var fight_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Fight
@onready var reroll_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Reroll
@onready var items_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Items

var round = 1

func _ready() -> void:
	rng.randomize()
	var enemies = $battle_UI.get_child(round).get_children()
	for i in enemies.size():
		enemies[i].connect("enemy_selected", Callable(self,"damage_enemy"))

func damage_enemy(enemy):
	if player_attack == true:
		player_attack = false
		enemy.hit(damage)
		enemy_turn()
		rerolls = 3
		reroll_button.disabled = false
		_on_roll_pressed()
func enemy_turn():
	#gets the curret batch of enemies
	var enemies = $battle_UI.get_child(round).get_children()
	#loop through the current batch of enemies
	for i in enemies.size():
		#gets the enemies stats, rolls based off the stats and then damages the players based of the roll
		var stats = enemies[i].get_stats()
		if enemies[i].hp >= 0 and enemies[i].turn_counter <= 0:
			roll(stats[0],stats[1],stats[2],stats[3])
			enemies[i].attack()
			$battle_UI/player.hit(damage)
		enemies[i].tic_turn_counter()
	enable_all_buttons()



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

func disable_all_buttons():
	roll_button.disabled = true
	fight_button.disabled = true
	reroll_button.disabled = true
	items_button.disabled = true

func enable_all_buttons():
	roll_button.disabled = false
	fight_button.disabled = false
	reroll_button.disabled = false
	items_button.disabled = false

func _on_roll_pressed() -> void:
	button_set_reroll()
	roll(player_stats[0],player_stats[1],player_stats[2],player_stats[3])
	write_text("you rolled " + str(dice) + " and your damage is " + str(damage) + "\nDo you want to fight or reroll?\nRerolls left:" + str(rerolls))


func _on_reroll_pressed() -> void:
	rerolls -= 1
	if rerolls <= 0:
		reroll_button.disabled = true
	roll(player_stats[0],player_stats[1],player_stats[2],player_stats[3])
	write_text("you rolled " + str(dice) + " and your damage is " + str(damage) + "\nDo you want to fight or reroll?\nRerolls left:" + str(rerolls))

func _on_fight_pressed() -> void:
	disable_all_buttons()
	player_attack = true
