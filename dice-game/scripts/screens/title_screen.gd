extends Control


func _on_play_pressed() -> void:
	$AnimationPlayer.play("fade out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/game/battle_test.tscn")


func _on_guide_pressed() -> void:
	pass
