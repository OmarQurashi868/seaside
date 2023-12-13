extends CenterContainer

@export var radius: float = 2.0
@export var color: Color = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()


func _draw():
	draw_circle(Vector2.ZERO, radius, color)
