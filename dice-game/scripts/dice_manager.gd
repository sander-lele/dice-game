extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	#gets called once
	rng.randomize()


func roll_dice(min_roll:int,max_roll:int,dice_count:int,multiplier=1.0,total_damage=0):
	#rolls the dice and calculates the damage
	var dice = []
	for i in range(dice_count):
		var dice_result = rng.randi_range(min_roll,max_roll)
		dice.append(dice_result)
		total_damage += dice_result
	return [dice, total_damage]
