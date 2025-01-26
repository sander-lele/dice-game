extends Control

signal buff_selected
signal heal
signal selection_done

var rng = RandomNumberGenerator.new()
var mult = BatMak.difficulty

#buff name, min, max, varible, buff desc
var buff = {
	1:["power",0.5,0.8, "multiplier", "damage multiplier"],
	2:["consistency",2,3, "min_roll", "minimum roll value"],
	3:["randomness",2,3, "max_roll", "maximum roll value"],
	4:["hoarding",1,1, "dice_count", "dice count"],
	5:["life",50,100, "max_hp", "max hp"],
	6:["regeneration",3,5,"heal_per_round","% heal per round"]
}

var selected_buffs: Array


func _ready() -> void:
	rng.randomize()

func show_buff():
	visible = true
	selected_buffs = [buff[rng.randi_range(1,6)],buff[rng.randi_range(1,6)],buff[rng.randi_range(1,6)]]
	for i in selected_buffs.size():
		var buff_array = selected_buffs[i]
		var buff_amount
		if buff_array[0] == "power":
			buff_amount = snapped(rng.randf_range(buff_array[1],buff_array[2])*mult,0.1)
		else:
			buff_amount = roundi(rng.randi_range(buff_array[1],buff_array[2])*mult)
		selected_buffs[i].append(buff_amount)
		$VBoxContainer/HBoxContainer.get_child(i).get_child(0).text = buff_array[0]
		$VBoxContainer/HBoxContainer.get_child(i).get_child(1).text = "+"+str(buff_amount)+" "+str(buff_array[4])


func _on_button_pressed() -> void:
	visible = false
	emit_signal("buff_selected",selected_buffs[0])
	emit_signal("selection_done")


func _on_button2_pressed() -> void:
	visible = false
	emit_signal("buff_selected",selected_buffs[1])
	emit_signal("selection_done")

func _on_button3_pressed() -> void:
	visible = false
	emit_signal("buff_selected",selected_buffs[2])
	emit_signal("selection_done")

func _on_heal_back_pressed() -> void:
	visible = false
	emit_signal("heal")
	emit_signal("selection_done")
