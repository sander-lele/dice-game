extends Control

func _ready() -> void:
	BatMak.difficulty = 1.0
	BatMak.enemy_cap_min = 2
	
	$VBoxContainer/Label2.text = "You survived " + str(StatCount.rounds) + " rounds.\nYou won " + str(StatCount.battles_won) + " battles.\nYou rolled " + str(StatCount.dice_rolled) + " dice,\ndealt " + str(StatCount.damage_dealt) + " points of damage\nand killed " + str(StatCount.enemies_killed) + " enemies."




func _on_retry_pressed() -> void:
	StatCount.reset_stats()
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/game/battle_test.tscn")


func _on_menu_pressed() -> void:
	StatCount.reset_stats()
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/screens/title_screen.tscn")
