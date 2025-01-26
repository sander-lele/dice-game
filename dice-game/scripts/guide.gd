extends Panel

var page = 0
@onready var page_count_max = $pages.get_child_count()


func close_all_pages():
	for i in page_count_max:
		$pages.get_child(i).visible = false
	if page >= page_count_max-1:
		$next.disabled = true
	else:
		$next.disabled = false
	if page <= 0:
		$back.disabled = true
	else:
		$back.disabled = false

func _on_exit_pressed() -> void:
	visible = false
	page = 0
	close_all_pages()
	$pages.get_child(page).visible=true

func _on_next_pressed() -> void:
	page = clamp(page+1,0,page_count_max-1)
	close_all_pages()
	$pages.get_child(page).visible=true


func _on_back_pressed() -> void:
	page = clamp(page-1,0,page_count_max-1)
	close_all_pages()
	$pages.get_child(page).visible=true
