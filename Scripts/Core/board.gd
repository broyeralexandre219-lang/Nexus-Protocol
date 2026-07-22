extends Node2D

@export var core_scene: PackedScene

const COLS := 6
const ROWS := 6
const CELL_SIZE := 96.0

const MIN_CHAIN := 3

# Animations
const DROP_DURATION := 0.20
const SPAWN_DURATION := 0.18
const DESTROY_DURATION := 0.15

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

	if chain.size() > 0:
		update_line()

	if chain.size() > 0 and !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):

		finish_chain()


func _on_core_pressed(core):

	clear_chain()

	chain_color = core.core_type

	add_to_chain(core)


func _on_core_hovered(core):

	if chain.is_empty():
		return

	if core.core_type != chain_color:
		return

	if chain.has(core):

		var index = chain.find(core)

		while chain.size() > index + 1:

			var removed = chain.pop_back()
			removed.set_selected(false)

		update_line()
		return

	var last_core = chain.back()

	if !are_neighbors(last_core, core):
		return

	add_to_chain(core)


func add_to_chain(core):

	chain.append(core)
	core.set_selected(true)
	update_line()


func finish_chain():

	if chain.size() < MIN_CHAIN:

		print("Chaîne annulée (", chain.size(), " Core)")

		clear_chain()
		return

	print("Chaîne validée ! (", chain.size(), " Cores)")

	destroy_chain()


func clear_chain():

	for core in chain:
		core.set_selected(false)

	chain.clear()
	chain_color = -1

	line.clear_points()


func update_line():

	line.clear_points()

	for core in chain:
		line.add_point(core.position)

	if chain.size() > 0:
		line.add_point(get_global_mouse_position())


func are_neighbors(core_a, core_b) -> bool:

	var dx = abs(core_a.grid_x - core_b.grid_x)
	var dy = abs(core_a.grid_y - core_b.grid_y)

	return dx <= 1 and dy <= 1 and !(dx == 0 and dy == 0)


func destroy_chain():

	for core in chain:
		remove_core(core)

	clear_chain()

	# Préparation des prochaines versions
	drop_cores()
	spawn_new_cores()
	debug_board()


func remove_core(core):

	board[core.grid_y][core.grid_x] = null

	core.queue_free()


func drop_cores():

	var tween = create_tween()

	for x in range(COLS):

		for y in range(ROWS - 1, -1, -1):

			if board[y][x] != null:
				continue

			for search_y in range(y - 1, -1, -1):

				if board[search_y][x] == null:
					continue

				var core = board[search_y][x]

				board[y][x] = core
				board[search_y][x] = null

				core.grid_y = y

				var target_position = core.position
				target_position.y += (y - search_y) * CELL_SIZE

				tween.tween_property(
					core,
					"position",
					target_position,
					DROP_DURATION
				)

				break


func spawn_new_cores():

	var tween = create_tween()

	var board_width = COLS * CELL_SIZE
	var board_height = ROWS * CELL_SIZE

	var start_x = (get_viewport_rect().size.x - board_width) / 2.0
	var start_y = (get_viewport_rect().size.y - board_height) / 2.0

	for x in range(COLS):

		var empty_count := 0

		for y in range(ROWS):

			if board[y][x] == null:
				empty_count += 1

		for y in range(empty_count):

			var core = core_scene.instantiate()

			add_child(core)

			core.grid_x = x
			core.grid_y = y

			core.core_type = randi() % 5

			var final_position = Vector2(
				start_x + x * CELL_SIZE + CELL_SIZE / 2.0,
				start_y + y * CELL_SIZE + CELL_SIZE / 2.0
			)

			# Apparition au-dessus du plateau
			core.position = final_position - Vector2(0, CELL_SIZE * empty_count)

			core.core_pressed.connect(_on_core_pressed)
			core.core_hovered.connect(_on_core_hovered)

			board[y][x] = core

			tween.tween_property(
				core,
				"position",
				final_position,
				SPAWN_DURATION
			)


func debug_board():

	for y in range(ROWS):

		var line = ""

		for x in range(COLS):

			if board[y][x] == null:
				line += ". "
			else:
				line += "X "

		print(line)
