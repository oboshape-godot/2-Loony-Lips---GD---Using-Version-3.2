extends Control

var welcomeString = "Hello and welcome to Loony Lips...\n"
var player_words = []  # to store all the words that the player enters
var current_story = {} # -- this way of declaring stops some errors
onready var playerTextNode = get_node("VBoxContainer/HBoxContainer/PlayerText")
onready var displayTextNode = get_node("VBoxContainer/DisplayText")


func _ready():
	displayTextNode.text = welcomeString
	set_current_story()
	_check_player_words_length()


func _on_PlayerText_text_entered():
	_add_to_player_words()


func _on_OK_Button_pressed():
	if is_story_done():
		if get_tree().reload_current_scene() != OK:
			print("Error reloading Scene")
	else:
		_add_to_player_words()


func _add_to_player_words():
	player_words.append((playerTextNode.text))
	displayTextNode.text = ""
	playerTextNode.clear()
	_check_player_words_length()


func is_story_done():
	return player_words.size() == current_story.prompts.size()


func _check_player_words_length():
	if is_story_done():
		_end_game()
	else:
		_prompt_player()


func _tell_story():
	displayTextNode.text = current_story.story % player_words

func _prompt_player():
	displayTextNode.text += "can I have "  + current_story.prompts[player_words.size()] + " please?"
	playerTextNode.grab_focus()	

func _end_game():
	playerTextNode.queue_free()
	get_node("VBoxContainer/HBoxContainer/OK_Label").text = "Again!"
	get_node("VBoxContainer/Player_Input_Label").text = ""
	_tell_story()
	get_node("VBoxContainer/HBoxContainer/OK_Button").grab_focus()

func set_current_story():
	randomize()
	##  CHOSE ONE OF THE FOLLOWING METHODS TO GET THE STORY

	## -- USE THIS METHOD TO GET STORY VIA JSON FILE
	set_current_Story_via_JSON_FILE()

	## -- OR USE THIS TO GET STORY VIA NODE METHOD
	#set_current_Story_via_STORY_NODES()


func set_current_Story_via_JSON_FILE():
	var stories = get_file_from_json("storybook.json")
	current_story = stories[randi() % stories.size()]
	print (current_story)

func set_current_Story_via_STORY_NODES():
	var stories = $StoryBook.get_child_count()
	var selected_story = randi() % stories
	current_story.prompts = $StoryBook.get_child(selected_story).prompts
	current_story.story = $StoryBook.get_child(selected_story).story



func get_file_from_json(_filename):
	var file = File.new()
	file.open(_filename, File.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data


func _on_OK_Button_focus_entered() -> void:
	pass # Replace with function body.
