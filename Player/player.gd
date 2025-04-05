extends Area2D
class_name Player

@export var damage: int = 10
@export var dig_speed: float = 1 #Hits per second
var modifiers:Array[Modifier]
