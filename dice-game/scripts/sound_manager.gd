extends Node

func _ready() -> void:
	var buttons = get_tree().get_nodes_in_group("button")
	for i in buttons.size():
		if buttons[i].is_connected("pressed", Callable(self,"button_pressed")) == false or buttons[i].is_connected("mouse_entered", Callable(self,"button_hoverd")) == false:
			buttons[i].connect("pressed", Callable(self,"button_pressed"))
			buttons[i].connect("mouse_entered", Callable(self,"button_hoverd"))

func button_pressed():
	$pressed.play()

func button_hoverd():
	$hover.play()
