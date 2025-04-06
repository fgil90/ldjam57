extends Node2D

var player
var UI_Gold

func _ready() -> void:
	player = get_node('Player')
	UI_Gold = get_node("UI/Gold_Label")

func _process(delta: float) -> void:
	UI_Gold.text = str(player.total_gold)
