extends Area2D

signal core_pressed(core)
signal core_hovered(core)

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
		scale = Vector2.ONE * 1.15
	else:
		scale = Vector2.ONE

	queue_redraw()


func _input_event(_viewport, event, _shape_idx):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:
				core_pressed.emit(self)


func _on_mouse_entered():

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		core_hovered.emit(self)
