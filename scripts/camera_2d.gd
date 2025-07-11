extends Camera2D

@export var tilemap: TileMap	
@onready var timer: Timer = $"../../../start/Timer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	await timer.timeout
	setup_camera_limits()


func setup_camera_limits():
	if not tilemap:
		return
	var used_rect: Rect2i = tilemap.get_used_rect()
	var tile_map_size := tilemap.tile_set.get_tile_size()
	limit_top = used_rect.position.y * tile_map_size.y - 850
