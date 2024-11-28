extends Control

@onready var dice_manager = $dice_manager

var turn = 1

var dice = []
var damage = []
var rerolls = 3

var player_hp = 100
var enemy_hp = 100

@onready var roll_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Roll
@onready var fight_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Fight
@onready var reroll_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Reroll
@onready var items_button = $bottom_UI/HBoxContainer/button_panel/VBoxContainer/Items

func write_text(text):
	$bottom_UI/HBoxContainer/text_panel/Label.text = text

func roll():
	button_set_reroll()
	var roll = $dice_manager.roll_dice(1,6,4)
	dice = roll[0]
	damage = roll[1]
	write_text("you rolled " + str(dice) + "\nDo you want to fight or reroll\nRerolls left:" + str(rerolls))

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
	roll()


func _on_reroll_pressed() -> void:
	rerolls -= 1
	if rerolls <= 0:
		reroll_button.disabled = true
	roll()
