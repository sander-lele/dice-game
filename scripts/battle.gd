extends Control

var rng = RandomNumberGenerator.new()

@onready var player_stats = $battle_UI/player.get_stats()
@onready var buff_selection = $buff_select

var dice = []
var damage = 0
var rerolls = 3

var player_attack = false

@onready var fight_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Fight
@onready var reroll_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Reroll
@onready var items_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Items

@warning_ignore("shadowed_global_identifier")
var round = 1
var enemy_positions = [Vector2(1051,133),Vector2(874,33),Vector2(874,227),Vector2(682,127)]

func _ready() -> void:
	rng.randomize()
	_on_roll_pressed()
	set_battle()

func set_battle():
	var enemy_set = BatMak.create_set()
	for i in enemy_set.size():
		var enemy_instance = enemy_set[i].instantiate()
		enemy_instance.position = enemy_positions[i]
		$battle_UI.get_child(round).add_child(enemy_instance)
	var enemies = $battle_UI.get_child(round).get_children()
	for i in enemies.size():
		enemies[i].add_to_group("current_enemies")
		enemies[i].connect("enemy_selected", Callable(self,"damage_enemy"))

func set_boss():
	var enemy_set = BatMak.create_boss_set()
	for i in enemy_set.size():
		var enemy_instance = enemy_set[i].instantiate()
		enemy_instance.position = enemy_positions[i]
		$battle_UI.get_child(round).add_child(enemy_instance)
	var enemies = $battle_UI.get_child(round).get_children()
	for i in enemies.size():
		enemies[i].add_to_group("current_enemies")
		enemies[i].connect("enemy_selected", Callable(self,"damage_enemy"))

func damage_enemy(enemy):
	if player_attack == true:
		player_attack = false
		enemy.hit(damage)
		enemy_turn()
		rerolls = 3

func enemy_turn():
	#gets the curret batch of enemies
	var enemies = $battle_UI.get_child(round).get_children()
	#loop through the current batch of enemies
	for i in enemies.size():
		#gets the enemies stats, rolls based off the stats and then damages the players based of the roll
		var stats = enemies[i].get_stats()
		enemies[i].tic_turn_counter()
		if enemies[i].hp > 0 and enemies[i].turn_counter <= 0 and enemies[i].attack_type == "aggressive":
			enemies[i].tic_turn_counter()
			roll(stats[0],stats[1],stats[2],stats[3])
			$battle_UI/player.hit(damage)
			enemies[i].attack()
	if $battle_UI/player.hp <= 0:
		$screen_transition.play("fade_out")
	if round == 4:
		check_boss_end()
	else:
		check_round_end()


func check_round_end():
	disable_all_buttons()
	#gets how many enemies are dead
	var dead_enemies = 0
	var enemies = $battle_UI.get_child(round).get_children()
	for i in enemies.size():
		if enemies[i].hp == 0:
			dead_enemies += 1
	if dead_enemies == enemies.size():
		#removes the dead enemies.
		for i in enemies.size():
			enemies[i].remove_from_group("current_enemies")
			enemies[i].queue_free()
		#checks if round is 4 and creates new enemy batch.
		round += 1
		if round != 4:
			set_battle()
		else:
			set_boss()
		#heals the player
		$battle_UI/player.heal_prot(25)
		#goes to the next batch.
		var tween = create_tween()
		tween.tween_property($battle_UI.get_child(round),"position:x",0,2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		enable_all_buttons()
		_on_roll_pressed()
	else:
		enable_all_buttons()
		_on_roll_pressed()

func check_boss_end():
	disable_all_buttons()
	#gets how many enemies are dead
	var dead_enemies = 0
	var enemies = $battle_UI.get_child(round).get_children()
	for i in enemies.size():
		if enemies[i].hp == 0:
			dead_enemies += 1
	if dead_enemies == enemies.size():
		#removes the dead enemies.
		for i in enemies.size():
			enemies[i].remove_from_group("current_enemies")
			enemies[i].queue_free()
		new_loop()
		set_battle()
		$battle_UI/player.heal_prot(25)
		buff_selection.show_buff()
		await  buff_selection.buff_selected
		var tween = create_tween()
		tween.tween_property($battle_UI.get_child(round),"position:x",0,2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		enable_all_buttons()
		_on_roll_pressed()
	else:
		enable_all_buttons()
		_on_roll_pressed()

func new_loop():
	round = 1
	BatMak.difficulty += 0.2
	BatMak.loop += 1
	if BatMak.enemy_cap <= 4:
		BatMak.enemy_cap += 1
	for i in $battle_UI.get_child_count():
		#this feels dumb but eh. this if statement is so that the loop skips over the player.
		if i != 0:
			$battle_UI.get_child(i).position.x = 1000

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
	damage = round(damage * multiplier)
	print(dice,damage)

func button_set_default():
	fight_button.visible = false
	reroll_button.visible = false
	items_button.visible = true

func button_set_reroll():
	fight_button.visible = true
	reroll_button.visible = true
	items_button.visible = true

func disable_all_buttons():
	fight_button.disabled = true
	reroll_button.disabled = true
	items_button.disabled = true

func enable_all_buttons():
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


func _on_screen_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://scenes/screens/end_screen.tscn")


func _on_buff_select_buff_selected(array) -> void:
	await  $battle_UI/player._on_buff_select_buff_selected(array)
	player_stats = $battle_UI/player.get_stats()


func _on_buff_select_heal() -> void:
	$battle_UI/player.heal_prot(25)
