extends Button


func _ready():
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	StarMapData.SaveMap()
	get_tree().quit()
