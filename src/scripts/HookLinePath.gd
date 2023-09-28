extends Path3D


func set_path(points: PackedVector3Array):
	var curve3d: Curve3D = Curve3D.new()
	curve3d.clear_points()
	for point in points:
		curve3d.add_point(point)
	set_curve(curve3d)
