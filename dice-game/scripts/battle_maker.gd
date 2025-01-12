extends Node

var rng = RandomNumberGenerator.new()

var dag = preload("res://scenes/character and enemies/dagger.tscn")
var shi = preload("res://scenes/character and enemies/shield.tscn")
var ham = preload("res://scenes/character and enemies/hammer.tscn")
var bom = preload("res://scenes/character and enemies/bomb.tscn")
var can = preload("res://scenes/character and enemies/cannon_man.tscn")
var hel = preload("res://scenes/character and enemies/healer.tscn")
var nec = preload("res://scenes/character and enemies/necromancer.tscn")

var bdag = preload("res://scenes/character and enemies/bosses/boss_dagger.tscn")
var bshi = preload("res://scenes/character and enemies/bosses/boss_shield.tscn")
var bham = preload("res://scenes/character and enemies/bosses/boss_hammer.tscn")
var bbom = preload("res://scenes/character and enemies/bosses/boss_bomb.tscn")
var bcan = preload("res://scenes/character and enemies/bosses/boss_cannon.tscn")
var bhel = preload("res://scenes/character and enemies/bosses/boss_healer.tscn")
var bnec = preload("res://scenes/character and enemies/bosses/boss_necromancer.tscn") 

var loop = 1
var difficulty = 1.0
var enemy_cap_min = 1
var enemy_cap = 2

var enemy_sets = {
	1:[dag,ham],
	2:[dag,ham,shi,can,bom],
	3:[dag,ham,shi,can,nec,bom],
	4:[dag,ham,shi,can,bom,hel,nec]
}

var bosses = [bdag,bshi,bham,bbom,bcan,bhel,bnec]

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

func create_boss_set():
	var current_set = []
	for i in 3:
		var enemies
		if loop <= 4:
			enemies = enemy_sets[loop]
		else:
			enemies = enemy_sets[4]
		var enemy
		if i == 0:
			enemy = bosses[rng.randi_range(0,bosses.size()-1)]
		else:
			enemy = enemies[rng.randi_range(0,enemies.size()-1)]
		current_set.append(enemy)
	return current_set
