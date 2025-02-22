extends Control

var rng = RandomNumberGenerator.new()

@onready var player = $battle_UI/character_base
@onready var player_stats = $battle_UI/character_base.get_stats()
@onready var buff_selection = $buff_select
@onready var dice_manage = $dice_manager

var rerolls = 3


var player_attack = false

@onready var fight_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Fight
@onready var reroll_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Reroll

@warning_ignore("shadowed_global_identifier")
var round = 1
var enemy_positions = [Vector2(1051,140),Vector2(874,40),Vector2(874,240),Vector2(682,140)]

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
	$"Sound manager"._ready()

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
		enemy.hit(dice_manage.damage)
		player.attack()
		StatCount.damage_dealt += dice_manage.damage
		enemy_turn()
		rerolls = 3

func enemy_turn():
	get_tree().call_group("enemies","disable_button")
	#gets the curret batch of enemies
	var enemies = $battle_UI.get_child(round).get_children()
	#loop through the current batch of enemies
	for i in enemies.size():
		#gets the enemies stats, rolls based off the stats and then damages the players based of the roll
		var stats = enemies[i].get_stats()
		enemies[i].tic_turn_counter()
		if enemies[i].hp > 0 and enemies[i].turn_counter <= 0:
			if enemies[i].attack_type == "aggressive":
				dice_manage.roll(stats[0],stats[1],stats[2],stats[3])
				await $dice_manager/reveal_timer.timeout
			await get_tree().create_timer(0.25).timeout
			enemies[i].attack()
			await  enemies[i].signal_attack
			if enemies[i].attack_type == "aggressive":
				player.hit(dice_manage.damage)
			await get_tree().create_timer(0.5).timeout
	if player.hp <= 0:
		StatCount.battle_died = round
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
		StatCount.battles_won += 1
		for i in enemies.size():
			enemies[i].remove_from_group("current_enemies")
			enemies[i].add_to_group("remove_later")
			if get_tree().get_nodes_in_group("remove_later2").size() != 0:
				for n in get_tree().get_nodes_in_group("remove_later2").size():
					get_tree().get_nodes_in_group("remove_later2")[n].queue_free()
		#checks if round is 4 and creates new enemy batch.
		round += 1
		if round != 4:
			set_battle()
		else:
			set_boss()
		#heals the player
		player.heal_prot(25)
		#goes to the next batch.
		tween()
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
		StatCount.battles_won += 1
		#removes the dead enemies.
		for i in enemies.size():
			enemies[i].remove_from_group("current_enemies")
			enemies[i].add_to_group("remove_later2")
			for n in get_tree().get_nodes_in_group("remove_later").size():
				get_tree().get_nodes_in_group("remove_later")[n].queue_free()
		new_loop()
		
		set_battle()
		player.heal_prot(25)
		buff_selection.show_buff()
		await  buff_selection.selection_done
		tween()
		enable_all_buttons()
		_on_roll_pressed()
	else:
		enable_all_buttons()
		_on_roll_pressed()

func new_loop():
	round = 1
	BatMak.difficulty += 0.1
	BatMak.loop += 1
	StatCount.rounds += 1
	if BatMak.enemy_cap < 3:
		BatMak.enemy_cap += 1
	for i in $battle_UI.get_child_count():
		#this feels dumb but eh. this if statement is so that the loop skips over the player.
		if i != 0:
			$battle_UI.get_child(i).position.x = 1000

func tween():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($battle_UI.get_child(round),"position:x",0,3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Parallax2D,"scroll_offset:x",-500,3).as_relative().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	if (round-1) != 0:
		tween.tween_property($battle_UI.get_child(round-1),"position:x",-1700,3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).as_relative()
	await tween.finished

func write_text(text):
	#for now just writes text. will be useful when animating it later
	$bottom_UI/HBoxContainer/text_panel/Label.text = text

func button_set_default():
	fight_button.visible = false
	reroll_button.visible = false

func button_set_reroll():
	fight_button.visible = true
	reroll_button.visible = true

func disable_all_buttons():
	fight_button.disabled = true
	reroll_button.disabled = true

func enable_all_buttons():
	fight_button.disabled = false
	reroll_button.disabled = false

func _on_roll_pressed() -> void:
	button_set_reroll()
	dice_manage.roll(player_stats[0],player_stats[1],player_stats[2],player_stats[3])
	write_text("you rolled " + str(dice_manage.dice.size()) + " dice and your damage is " + str(dice_manage.damage) + "\nDo you want to fight or reroll?\nRerolls left:" + str(rerolls))
	StatCount.dice_rolled += dice_manage.dice.size()

func _on_reroll_pressed() -> void:
	rerolls -= 1
	if rerolls <= 0:
		reroll_button.disabled = true
	dice_manage.roll(player_stats[0],player_stats[1],player_stats[2],player_stats[3])
	write_text("you rolled " + str(dice_manage.dice.size()) + " dice and your damage is " + str(dice_manage.damage) + "\nDo you want to fight or reroll?\nRerolls left:" + str(rerolls))
	StatCount.dice_rolled += dice_manage.dice.size()

func _on_fight_pressed() -> void:
	get_tree().call_group("enemies","enable_button")
	disable_all_buttons()
	player_attack = true


func _on_screen_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://scenes/screens/end_screen.tscn")


func _on_buff_select_buff_selected(array) -> void:
	await  $battle_UI/character_base._on_buff_select_buff_selected(array)
	player_stats = player.get_stats()


func _on_buff_select_heal() -> void:
	player.heal_prot(25)


func _on_settings_button_pressed() -> void:
	Settings.visible = true
