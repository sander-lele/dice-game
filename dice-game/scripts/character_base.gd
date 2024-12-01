extends Sprite2D

@export var hp: int = 100
@export var min_roll: int = 1
@export var max_roll: int = 6
@export var dice_count: int = 1
@export var multiplier: int = 1


func get_stats():
	return [min_roll,max_roll,dice_count,multiplier]

func hit(damage):
	hp -= damage
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)
