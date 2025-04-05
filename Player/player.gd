extends CharacterBody2D
class_name Player

@export var max_velocity:float = 800
@export var damage: int = 10
@export var dig_speed: float = 1 #Hits per second
var total_gold: int = 0

var time_between_digs: float 
var time_until_dig: float = 0
var modifiers:Array[Modifier]

signal dig(tile_collider_rid)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.speed_scale = dig_speed
	time_between_digs = 1/dig_speed

func _physics_process(delta: float) -> void:
	time_until_dig += delta
	velocity += Vector2.DOWN * get_gravity() * delta
	move_and_slide()
	dig_below()

func dig_below():
	var last_collision = get_last_slide_collision()
	if time_until_dig < time_between_digs: return
	if last_collision == null: return
	
	var tile_collider_rid = last_collision.get_collider_rid()
	dig.emit(tile_collider_rid) #Connects with Blocks (TileMapLayer)
	time_until_dig = 0
