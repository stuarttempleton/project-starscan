extends Button


export var scene_to_load = ""

func _ready():
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	AudioPlayer._play_UI_Button_Select()
	MessageBox.connect("ChoiceSelected", self, "ChoiceResponse")	
	MessageBox.DisplayText("ReturnToMenu", ["YES","NO"])


func ChoiceResponse(choice):
	MessageBox.disconnect("ChoiceSelected", self, "ChoiceResponse")

	match choice:
		-1: return
		0: DoResponse()
		1: return

func DoResponse():
	if (scene_to_load != "") :
		StarMapData.SaveMap()
		ShipData.SaveShip()
		GameNarrativeDisplay.CancelDialog()
		GameController.Unpause()
		SceneChanger.LoadScene(scene_to_load,0.0)
	else :
		print("THIS MENU BUTTON HAS NO SCENE TO LOAD")

