@tool
extends TextureButton

@export var dark: bool = false
@export var pos: Vector2i = Vector2i(-1,-1)
@export var selected: bool = false : 
	set(value):
		selected = value
		if selected:
			get_child(1).set_texture(load("res://assets/selected.png"))
		else:
			get_child(1).set_texture(load("res://assets/back.png"))

func _ready():
	if dark == false:
		var bright_tile = load("res://assets/tile1.png")
		$".".texture_normal = bright_tile
	else:
		var dark_tile = load("res://assets/tile2.png")
		$".".texture_normal = dark_tile

func _on_pressed():
	if !get_parent().status:
		get_parent().tile_pressed(pos)


