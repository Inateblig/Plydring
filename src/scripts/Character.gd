extends CharacterBody3D


@onready var head: Node3D = get_node("Head")
@onready var face: MeshInstance3D = head.get_node("Face")
@onready var hooks: Array[Node] = get_tree().get_nodes_in_group("hook")

var SPEED: float = 5.0
var MOUSE_SPEED: float = 0.005

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	face.hide()

func _input(ev):
	if ev is InputEventMouseMotion:
		var dp: Vector2 = -lerp(Vector2.ZERO, ev.relative * MOUSE_SPEED, 0.75)
		rotate_y(dp.x)
		head.rotate_x(dp.y)

func _physics_process(dt):
	var inp_dir: Vector3 = Vector3(Input.get_axis("left", "right"),
		Input.get_axis("down", "up"),
		Input.get_axis("forward", "backward"))

	var direction = (transform.basis * inp_dir).normalized()

	var hook_pull_velocity: Vector3 = Vector3.ZERO
	for hook in hooks:
		hook_pull_velocity += hook.pull_force(dt)
	velocity = direction * SPEED + hook_pull_velocity

	move_and_slide()
