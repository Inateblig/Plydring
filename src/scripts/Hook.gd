extends CharacterBody3D


@onready var character: CharacterBody3D = self.get_owner().get_node("CharacterBody3D")
@onready var path: Path3D = get_node("Path3D")
@export var action_name: String = "hook_left"
@export var hand_offset: Vector3 = Vector3(0.6, 0, 0.5)
@onready var hand: MeshInstance3D = get_node("Hand")
var OFFSET: Vector3 = -hand_offset if action_name == "hook_left" else hand_offset

@export var HOOK_SPEED: float = 100.0
var dir: Vector3 = Vector3.ZERO
var pos: Vector3 = Vector3.ZERO

var collided = false

func _process(dt):
	update_hook_line()

func _physics_process(dt):
	handle_hook_input(dt)

func handle_hook_input(_dt):
	if Input.is_action_just_pressed(action_name):
		init_hook()
	if Input.is_action_pressed(action_name):
		update_hook_projectile()

func init_hook():
	collided = false
	self.set_position(character.get_position())
	dir = (character.transform.basis * character.head.transform.basis * Vector3.FORWARD).normalized()

func update_hook_projectile():
	if collided:
		return
	velocity = dir * HOOK_SPEED
	collided = move_and_slide()

func update_hook_line():
	var t: Transform3D = character.transform.basis * character.head.transform.basis
	var offset = (t * OFFSET)
	pos = character.position - self.position + offset
	hand.set_position(pos)
	path.set_path(PackedVector3Array([pos, Vector3.ZERO]))
