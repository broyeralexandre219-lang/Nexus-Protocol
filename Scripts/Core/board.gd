extends Node2D

@export var core_scene : PackedScene

const COLS := 6
const ROWS := 6
const CELL_SIZE := 96.0

var board = []
var selected_core = null


func _ready():

	randomize()

	initialize_board()

	create_board()


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

			core.core_clicked.connect(_on_core_clicked)

			board[y][x] = core


func _on_core_clicked(core):

	if selected_core != null:
		selected_core.set_selected(false)

	selected_core = core

	selected_core.set_selected(true)
