extends Node2D

@export var bubble_scene: PackedScene

const COLS := 6
const ROWS := 6
const CELL_SIZE := 88

var bubbles = []

var colors = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW,
	Color.PURPLE
]

var current_chain = []
var dragging := false


func _ready():

	randomize()

	initialize_grid()
	generate_board()


func initialize_grid():

	bubbles.clear()

	for y in range(ROWS):

		bubbles.append([])

		for x in range(COLS):
			bubbles[y].append(null)


func generate_board():

	var board_width = COLS * CELL_SIZE
	var board_height = ROWS * CELL_SIZE

	var viewport_size = get_viewport_rect().size

	var start_x = (viewport_size.x - board_width) / 2.0
	var start_y = (viewport_size.y - board_height) / 2.0

	for y in range(ROWS):

		for x in range(COLS):

			var bubble = bubble_scene.instantiate()

			add_child(bubble)

			bubble.position = Vector2(
				start_x + x * CELL_SIZE + CELL_SIZE / 2,
				start_y + y * CELL_SIZE + CELL_SIZE / 2
			)

			bubble.grid_x = x
			bubble.grid_y = y

			var random_type = randi() % colors.size()

			bubble.bubble_type = random_type
			bubble.color = colors[random_type]

			bubbles[y][x] = bubble

			bubble.bubble_clicked.connect(_on_bubble_clicked)
			bubble.bubble_hovered.connect(_on_bubble_hovered)


func _on_bubble_clicked(bubble):

	clear_chain()

	dragging = true

	current_chain.append(bubble)

	bubble.set_selected(true)

	print("Début chaîne")


func _on_bubble_hovered(bubble):

	if !dragging:
		return

	if current_chain.has(bubble):
		return

	current_chain.append(bubble)

	bubble.set_selected(true)

	print("Chaîne :", current_chain.size())


func _input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:

			if dragging:

				dragging = false

				print("Chaîne terminée :", current_chain.size())

				clear_chain()


func clear_chain():

	for bubble in current_chain:
		bubble.set_selected(false)

	current_chain.clear()


func get_bubble(x, y):

	if x < 0 or y < 0:
		return null

	if x >= COLS or y >= ROWS:
		return null

	return bubbles[y][x]
