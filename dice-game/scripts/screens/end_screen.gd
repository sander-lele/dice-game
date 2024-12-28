extends Control






func _on_retry_pressed() -> void:
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/game/battle_test.tscn")


func _on_menu_pressed() -> void:
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/game/battle_test.tscn")
