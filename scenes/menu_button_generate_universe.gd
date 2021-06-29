extends Button


export var scene_to_load = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	AudioPlayer._play_UI_Button_Select()
	MessageBox.connect("ChoiceSelected", self, "ChoiceResponse")	
	MessageBox.DisplayText("RegenerateUniverse", ["YES","NO"])


func ChoiceResponse(choice):
	MessageBox.disconnect("ChoiceSelected", self, "ChoiceResponse")

	match choice:
		-1: return
		0: DoResponse()
		1: return

func DoResponse():
	WorldGenerator.generate(-1)
	StarMapData.ResetMap()
	ShipData.ResetShip()
	SceneChanger.LoadScene(scene_to_load,0.0)
