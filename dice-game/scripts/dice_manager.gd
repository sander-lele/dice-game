extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	#gets called once
	rng.randomize()
