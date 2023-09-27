@tool
extends CSGPolygon3D


@export_range(0.01, 0.1) var radius: float = 0.1
@export_range(3, 100, 1) var sides: int = 20

func _ready():
	set_polygon(create_polygon(sides, radius))

func create_polygon(n: int, r: float) -> PackedVector2Array:
	var points: PackedVector2Array
	if n == 0:
		points = PackedVector2Array([Vector2.ZERO])
		return points
	for i in n:
		var angle: float = PI * 2 * i / n
		points.append(Vector2(cos(angle), sin(angle)) * r)
	return points
