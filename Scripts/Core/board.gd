extends Node2D

@export var core_scene : PackedScene

const COLS := 6
const ROWS := 6
const CELL_SIZE := 96.0

var board = []

var chain = []
var chain_color := -1

@onready var line: Line2D = $Line2D


func _ready():

	randomize()

	initialize_board()

	create_board()

	line.clear_points()


func initialize_board():

	board.clear()

	for y in range(ROWS):

		board.append([])

		for x in range(COLS):

			board[y].append(null)


func create_board():

	var board_width = COLS * CELL_SIZE
	var board_height = ROWS * CELL_SIZE

	var start_x = (get_viewport_rect().size.x - board_width) / 2.0
	var start_y = (get_viewport_rect().size.y - board_height) / 2.0

	for y in range(ROWS):

		for x in range(COLS):

			var core = core_scene.instantiate()

			add_child(core)

			core.position = Vector2(
				start_x + x * CELL_SIZE + CELL_SIZE / 2.0,
				start_y + y * CELL_SIZE + CELL_SIZE / 2.0
			)

			core.grid_x = x
			core.grid_y = y

			core.core_type = randi() % 5

			core.core_pressed.connect(_on_core_pressed)
			core.core_hovered.connect(_on_core_hovered)

			board[y][x] = core


func _process(_delta):

	if chain.size() > 0 and !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):

		print("Chaîne :", chain.size())

		clear_chain()


func _on_core_pressed(core):

	clear_chain()

	chain_color = core.core_type

	add_to_chain(core)


func _on_core_hovered(core):

	if core.core_type != chain_color:
		return

	if chain.has(core):
		return

	add_to_chain(core)


func add_to_chain(core):

	chain.append(core)

	core.set_selected(true)

	update_line()


func clear_chain():

	for core in chain:
		core.set_selected(false)

	chain.clear()

	chain_color = -1

	update_line()


func update_line():

	line.clear_points()

	for core in chain:
		line.add_point(core.position)
