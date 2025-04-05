extends TileMapLayer
class_name Blocks

class Block:
	var hp
	var defense
	var gold_yield
	var coords 
	
	func _init(_hp, _defense, _gold_yield):
		hp = _hp
		defense = _defense
		gold_yield = _gold_yield

@onready var player: Player = $"../Player"
var tile_dict = {}

func _ready():
	player.dig.connect(_on_dig)
	
func _on_dig(tile_collider_rid):
	var current_tile
	var tile_coords = get_coords_for_body_rid(tile_collider_rid)
	if tile_collider_rid not in tile_dict:
		var tile_data = get_cell_tile_data(tile_coords)
		var hp = tile_data.get_custom_data('hp')
		var defense = tile_data.get_custom_data('defense')
		var gold_yield = tile_data.get_custom_data('gold_yield')
		var block = Block.new(hp, defense, gold_yield)
		block.coords = tile_coords
		tile_dict.get_or_add(tile_collider_rid, block)
		
	var actual_damage = player.damage - tile_dict[tile_collider_rid].defense
	if actual_damage < 0: actual_damage = 0
	
	if (actual_damage >= tile_dict[tile_collider_rid].hp):
		player.total_gold += tile_dict[tile_collider_rid].gold_yield
		set_cell(tile_coords) #deletes cell
	else:
		tile_dict[tile_collider_rid].hp -= actual_damage
		
