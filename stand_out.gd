extends Control

signal choice_locked(option_index: int)

const QUESTIONS := [
	{
		"prompt": "Which superpower would you choose?",
		"options": ["Flying", "Invisibility", "Teleportation"],
		"sample_votes": [2, 1, 0]
	},
	{
		"prompt": "Where would you spend a free weekend?",
		"options": ["Beach", "Mountains", "Big city"],
		"sample_votes": [0, 2, 1]
	},
	{
		"prompt": "Which snack would you grab first?",
		"options": ["Popcorn", "Chips", "Cookies"],
		"sample_votes": [1, 0, 2]
	}
]

var question_index := 0
var total_points := 0

var progress := Label.new()
var question := Label.new()
var status := Label.new()
var results := Label.new()
var next_button := Button.new()
var choice_buttons: Array[Button] = []


func _ready() -> void:
	var center := CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var panel := VBoxContainer.new()
	panel.custom_minimum_size.x = minf(500.0, get_viewport_rect().size.x - 48.0)
	panel.add_theme_constant_override("separation", 16)
	center.add_child(panel)

	progress.add_theme_font_size_override("font_size", 16)
	progress.add_theme_color_override("font_color", Color("#9cb7ff"))

	question.add_theme_font_size_override("font_size", 30)
	question.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	status.add_theme_font_size_override("font_size", 18)
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	results.add_theme_font_size_override("font_size", 18)
	next_button.custom_minimum_size.y = 48

	panel.add_child(progress)
	panel.add_child(question)
	panel.add_child(status)

	for i in range(3):
		var button := Button.new()
		button.pressed.connect(_lock_choice.bind(i))
		choice_buttons.append(button)
		panel.add_child(button)

	panel.add_child(results)
	next_button.pressed.connect(_next_question)
	panel.add_child(next_button)

	_show_question()


func _show_question() -> void:
	var current: Dictionary = QUESTIONS[question_index]
	var options: Array = current["options"]

	progress.text = "Question %d of %d" % [question_index + 1, QUESTIONS.size()]
	question.text = current["prompt"]
	status.text = "Pick the option you think the fewest friends will choose."
	results.text = ""
	next_button.hide()

	for i in range(choice_buttons.size()):
		choice_buttons[i].text = options[i]
		choice_buttons[i].disabled = false


func _lock_choice(index: int) -> void:
	for button in choice_buttons:
		button.disabled = true

	var current: Dictionary = QUESTIONS[question_index]
	var sample_votes: Array = current["sample_votes"]
	var votes := sample_votes.duplicate()
	votes[index] += 1

	var fewest := 0
	for count in votes:
		if count > 0 and (fewest == 0 or count < fewest):
			fewest = count

	var points := 100 if votes[index] == fewest else 0
	total_points += points

	status.text = "Locked in: " + choice_buttons[index].text
	results.text = "Test results\n"
	for i in range(choice_buttons.size()):
		results.text += "%s: %d vote(s)\n" % [choice_buttons[i].text, votes[i]]
	results.text += "+%d points | Total: %d" % [points, total_points]

	next_button.text = "See Final Score" if question_index == QUESTIONS.size() - 1 else "Next Question"
	next_button.show()
	choice_locked.emit(index)


func _next_question() -> void:
	question_index += 1
	if question_index < QUESTIONS.size():
		_show_question()
		return

	progress.text = "Round complete"
	question.text = "Final score: %d / %d" % [total_points, QUESTIONS.size() * 100]
	status.hide()
	results.hide()
	next_button.hide()
	for button in choice_buttons:
		button.hide()
