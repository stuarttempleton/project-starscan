extends Button


export var scene_to_load = ""

func _ready():
	if (!StarMapData.SaveExists()):
		self.visible = false
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	MessageBox.connect("ChoiceSelected", self, "ChoiceResponse")	
	MessageBox.DisplayText("Restart", ["YES","NO"])


func ChoiceResponse(choice):
	MessageBox.disconnect("ChoiceSelected", self, "ChoiceResponse")
	match choice:
		-1: return
		0: DoResponse()
		1: return

func DoResponse():
	if (scene_to_load != "") :
		AudioPlayer._play_UI_Button_Select()
		StarMapData.ResetMap()
		ShipData.ResetShip()
		get_tree().change_scene(scene_to_load)
	else :
		print("THIS MENU BUTTON HAS NO SCENE TO LOAD")
