extends Area2D

signal core_clicked(core)

@export var core_type : int = 0

var grid_x : int = 0
var grid_y : int = 0

var selected := false

const RADIUS := 40.0

var colors = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW,
	Color.PURPLE
]


func _ready():
	queue_redraw()


func _draw():

	draw_circle(Vector2.ZERO, RADIUS, colors[core_type])

	if selected:
		draw_arc(
			Vector2.ZERO,
			RADIUS + 4,
			0,
			TAU,
			64,
			Color.WHITE,
			4.0
		)


func set_selected(value: bool):

	selected = value

	if selected:
		scale = Vector2(1.15, 1.15)
	else:
		scale = Vector2.ONE

	queue_redraw()


func _input_event(viewport, event, shape_idx):

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			core_clicked.emit(self)
