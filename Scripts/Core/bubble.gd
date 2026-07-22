extends Area2D

signal bubble_clicked(bubble)
signal bubble_hovered(bubble)

@export var radius: float = 40.0

var bubble_type := 0
var grid_x := 0
var grid_y := 0

var color: Color = Color.WHITE
var selected := false


func _ready():
	queue_redraw()


func _draw():
	draw_circle(Vector2.ZERO, radius, color)

	if selected:
		draw_arc(
			Vector2.ZERO,
			radius + 5,
			0,
			TAU,
			64,
			Color.WHITE,
			4.0
		)


func set_selected(value: bool):
	selected = value
	queue_redraw()


func _input_event(_viewport, event, _shape_idx):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			bubble_clicked.emit(self)

	if event is InputEventMouseMotion:

		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			bubble_hovered.emit(self)
