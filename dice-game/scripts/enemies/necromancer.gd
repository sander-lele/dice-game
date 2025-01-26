extends Node

@export var heal_amount: int = 10 
@export var is_boss = false
var attack_count = 0


func _ready() -> void:
	await get_parent().signal_attack
	if attack_count == 5 and is_boss == false:
		get_parent().die()
	if get_parent().hp != 0:
		get_parent().attack()
		attack_count =+ 1
		get_tree().call_group("current_enemies","revive",heal_amount)
	_ready()
