extends Control

var player_words = []
var current_story = {}

onready var PlayerText = $VBoxContainer/HBoxContainer/PlayerText
onready var DisplayText = $VBoxContainer/DisplayText


func _ready():
	_set_current_story()
	DisplayText.text = "Welcome to Loony Lips! We're going to tell a story and have a wonderful time! "
	_check_player_words_length()
	PlayerText.grab_focus()


func _set_current_story():
	randomize()
	var stories = $StoryBook.get_child_count() # Get the total number of stories we have
	var selected_story = randi() % stories # Get the index of one of the stories at random
	current_story.prompts = $StoryBook.get_child(selected_story).prompts
	current_story.story = $StoryBook.get_child(selected_story).story
#	current_story = template[randi() % template.size()]


# warning-ignore:unused_argument
func _on_PlayerText_text_entered(new_text):
	_add_to_player_words()


func _on_TextureButton_pressed():
	if _is_story_done():
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	else:
		_add_to_player_words()


func _add_to_player_words():
	$SFX/Chalk.play()
	player_words.append(PlayerText.text)
	DisplayText.text = ""
	PlayerText.clear()
	_check_player_words_length()


func _is_story_done():
	return player_words.size() == current_story.prompts.size()


func _check_player_words_length():
	if _is_story_done():
		_end_game()
	else:
		_prompt_player()


func _tell_story():
	DisplayText.text = current_story.story % player_words


func _prompt_player():
	DisplayText.text += "May I have " + current_story.prompts[player_words.size()] + " please?"


func _end_game():
	$SFX/Ding.play()
	PlayerText.queue_free()
	$VBoxContainer/HBoxContainer/Label.text = "Again!"
	_tell_story()
