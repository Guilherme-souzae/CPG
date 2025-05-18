extends Node2D

var message_duration := 2.0

func _ready():
	$UI/MessageLabel.visible = false

func show_message(text: String, duration := message_duration):
	$UI/MessageLabel.text = text
	$UI/MessageLabel.visible = true
	await get_tree().create_timer(duration).timeout
	$UI/MessageLabel.visible = false
