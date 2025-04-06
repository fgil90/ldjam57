extends Label

@onready var timer: Timer = $Timer
@onready var inverse_wait_time = 1/timer.wait_time

@export var rising_speed: float = 100

func _process(delta: float) -> void:
	self_modulate.a = inverse_wait_time * timer.time_left
	global_position += Vector2.UP * rising_speed * delta

func _on_timer_timeout() -> void:
	queue_free()
