extends Path3D


func set_path(points: PackedVector3Array):
	curve.clear_points()
	for point in points:
		curve.add_point(point)
