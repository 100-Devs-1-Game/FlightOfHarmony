extends Control


@onready var button_next: Button = %"Button Tutorial Next"

var pages: Array[TextureRect]
var index: int= 0



func _ready() -> void:
	for child in get_children():
		if child is TextureRect:
			pages.append(child)
	
	show_page()


func open():
	button_next.show()
	index= 0
	show_page()
	show()
	

func show_page():
	for page in pages:
		page.hide()
	pages[index].show()


func _on_button_tutorial_next_pressed() -> void:
	index+= 1
	if index == pages.size() - 1:
		button_next.hide()
	show_page()


func _on_button_tutorial_close_pressed() -> void:
	hide()
