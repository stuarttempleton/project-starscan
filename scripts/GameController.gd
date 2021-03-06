extends Node2D


export var pause_menu_path = ""
var is_gameloop = false
var pause_menu_scene
var pause_menu_instance
var is_usingmap = false
var scene_has_map = false
var movement_block_queue = 0

signal gameloop_state(loopstate)
signal map_state(mapstate)
signal pause_state(pausestate)


func _ready():
	pause_menu_scene = load(pause_menu_path)
	
	$CanvasLayer/TextureButton.visible = is_gameloop
	$CanvasLayer/MapButton.visible = is_gameloop && scene_has_map


func Pause():
	AudioPlayer._play_UI_Button_Select()
	pause_menu_instance = pause_menu_scene.instance()
	add_child(pause_menu_instance)
	emit_signal("pause_state", true)
	EnableMovement(false)
	get_tree().paused = true
	$CanvasLayer/MapButton.visible = false


func Unpause():
	AudioPlayer._play_UI_Button_Select()
	if pause_menu_instance:
		pause_menu_instance.queue_free()
	get_tree().paused = false
	EnableMovement(true)
	emit_signal("pause_state", false)
	$CanvasLayer/MapButton.visible = is_gameloop && scene_has_map


func EnterGameLoop(is_loop):
	is_gameloop = is_loop
	emit_signal("gameloop_state",is_gameloop)
	$CanvasLayer/TextureButton.visible = is_gameloop
	$CanvasLayer/MapButton.visible = is_gameloop && scene_has_map
	$WinLoseCheck.isInGame = is_gameloop
	is_usingmap = false

func isGameOver():
	return $WinLoseCheck.handlingGameOver

func EnableMovement(enable):
	if enable:
		movement_block_queue -= 1
	else:
		movement_block_queue += 1
	
	if movement_block_queue <= 0:
		movement_block_queue = 0


func ResetMoveBlock():
	movement_block_queue = 0

func is_movement_enabled():
	return movement_block_queue == 0

func EnableMap():
	scene_has_map = true
	$CanvasLayer/MapButton.visible = is_gameloop && scene_has_map

func DisableMap():
	scene_has_map = false
	$CanvasLayer/MapButton.visible = is_gameloop && scene_has_map

func togglePause():
	if get_tree().paused:
		Unpause()
	else:
		Pause()

func _input(_event):
	if is_gameloop:
		if Input.is_action_just_released("pause_menu"):
			togglePause()
		if Input.is_action_just_released("starmap_mapview"):
			MapToggle()

func MapToggle():
	if scene_has_map and !get_tree().paused:
		AudioPlayer._play_UI_Button_Select()
		is_usingmap = !is_usingmap
		EnableMovement(!is_usingmap)
		emit_signal("map_state", is_usingmap)


func _on_TextureButton_pressed():
	togglePause()

func _on_TextureButton_mouse_entered():
	EnableMovement(false)

func _on_TextureButton_mouse_exited():
	EnableMovement(true)

func _on_MapButton_mouse_entered():
	EnableMovement(false)

func _on_MapButton_mouse_exited():
	EnableMovement(true)

func _on_MapButton_pressed():
	MapToggle()
