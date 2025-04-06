extends TileMapLayer
class_name Blocks

class Block:
	var hp
	var defense
	var gold_yield
	var coords 
	
	func _init(tile_data:TileData, tile_coords:Vector2i):
		hp = tile_data.get_custom_data('hp')
		defense = tile_data.get_custom_data('defense')
		gold_yield = tile_data.get_custom_data('gold_yield')
		coords = tile_coords

@onready var player: Player = $"../Player"
@export var noise: FastNoiseLite
var block_dict = {}
var look_up_table = [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)]
@onready var display_label = preload('res://Blocks/damage_display.tscn')

func _ready():
	player.dig.connect(_on_dig)
	var map_width = 16
	var map_height = 1000
	randomize()
	noise.seed = randi()
	generate_tilemap(map_width, map_height)
	
func generate_tilemap(width:int, height:int):
	var source_id = get_cell_source_id(Vector2i(0,0))
	for i in range(width):
		for j in range(height):
			set_cell(Vector2i(i,j), source_id, sample_random_tile(i, j))

func sample_random_tile(i,j):
	var value = abs(noise.get_noise_2d(i,j))
	value = clampf(value, 0, 1)
	value *= value
	value *= 4
	value = floori(value)
	return look_up_table[value]

func display_damage(damage, pos):
	var damage_display_instance = display_label.instantiate()
	damage_display_instance.global_position = pos
	damage_display_instance.text = str(damage)
	add_child(damage_display_instance)
	print(damage_display_instance)

func _on_dig(tile_collider_rid):
	var current_tile
	var tile_coords = get_coords_for_body_rid(tile_collider_rid)
	if tile_collider_rid not in block_dict:
		var tile_data = get_cell_tile_data(tile_coords)
		var block = Block.new(tile_data, tile_coords)
		block_dict.get_or_add(tile_collider_rid, block)
		
	current_tile = block_dict[tile_collider_rid]
	
	var actual_damage = player.damage - current_tile.defense
	if actual_damage < 0: actual_damage = 0
	
	if (actual_damage >= current_tile.hp):
		player.total_gold += current_tile.gold_yield
		set_cell(tile_coords, -1) #deletes cell
		block_dict.erase(tile_collider_rid) #removes block from dict
	else:
		current_tile.hp -= actual_damage
	
	display_damage(actual_damage, map_to_local(tile_coords))
	#'print('Current Tile: \n Position: {0}\n hp: {1} \n'.format([current_tile.coords, current_tile.hp]))
