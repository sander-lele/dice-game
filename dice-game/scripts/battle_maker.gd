extends Node

var rng = RandomNumberGenerator.new()

var dag = preload("res://scenes/character and enemies/dagger.tscn")
var shi = preload("res://scenes/character and enemies/shield.tscn")
var ham = preload("res://scenes/character and enemies/hammer.tscn")
var bom = preload("res://scenes/character and enemies/bomb.tscn")
var can = preload("res://scenes/character and enemies/cannon_man.tscn")
var hel = preload("res://scenes/character and enemies/healer.tscn")



var loop = 1
var difficulty = 1.0
var enemy_cap_min = 1
var enemy_cap = 2

var enemy_sets = {
	1:[dag,ham,shi],
	2:[dag,ham,shi,can],
	3:[dag,ham,shi,can,bom],
	4:[dag,ham,shi,can,bom,hel]
}

func  _ready() -> void:
	rng.randomize()
	create_set()

func create_set():
	var current_set = []
	for i in rng.randi_range(enemy_cap_min,enemy_cap):
		var enemies
		if loop <= 4:
			enemies = enemy_sets[loop]
		else:
			enemies = enemy_sets[4]
		var enemy = enemies[rng.randi_range(0,enemies.size()-1)]
		current_set.append(enemy)
	return current_set
