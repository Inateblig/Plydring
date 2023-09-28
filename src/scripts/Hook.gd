extends CharacterBody3D


@onready var character: CharacterBody3D = self.get_owner().get_node("CharacterBody3D")
@onready var path: Path3D = get_node("Path3D")
@onready var hand: MeshInstance3D = get_node("Hand")

@export var action_name: String = "hook_left"
@export var hand_offset: Vector3 = Vector3(-0.6, 0, -0.5)

@export var HOOK_SPEED: float = 75.0
@export var HOOK_PULL_SPEED: float = 500.0
@export var HOOK_RETRIEVE_SPEED: float = 25.0

enum {
	INACTIVE,
	THROWN,
	ATTACHED,
	PULLING,
	RETRIEVING,
}

var dir: Vector3 = Vector3.ZERO
var hand_pos: Vector3 = Vector3.ZERO
var checkTimes: int = 3
var clddTimes: int = 0
var state: int = INACTIVE

func _process(_dt):
	if state == INACTIVE:
		return
	draw_hook_line()

func _physics_process(dt):
	if Input.is_action_just_pressed(action_name):
		throw_hook()
	elif Input.is_action_just_released(action_name):
		release_hook()
	if Input.is_action_pressed(action_name):
		move_projectile(dt)
	elif state == INACTIVE:
		return
	else:
		retrieve_hook()

func retrieve_hook():
	if abs(hand_pos.length()) < 0.25:
		hide()
		state = INACTIVE
		return
	velocity = hand_pos * HOOK_RETRIEVE_SPEED
	move_and_slide()

func throw_hook():
	show()
	state = THROWN
	clddTimes = 0
	set_position(character.get_position())
	dir = (character.transform.basis * character.head.transform.basis * Vector3.FORWARD).normalized()

func release_hook():
	state = RETRIEVING

func move_projectile(dt):
	if clddTimes == checkTimes:
		state = PULLING
		return
	var speed: float = HOOK_SPEED
	for i in range (clddTimes, checkTimes):
		var cln: KinematicCollision3D = move_and_collide(dir * speed * dt)
		if !cln:
			return
		clddTimes += 1
		speed *= 0.5

func pull_force(dt) -> Vector3:
	if state != PULLING:
		return Vector3.ZERO
	return (self.position - character.position).normalized() * dt * HOOK_PULL_SPEED

func draw_hook_line():
	hand_pos = character.position - self.position + character.transform.basis * character.head.transform.basis * hand_offset
	hand.set_position(hand_pos)
	path.set_path(PackedVector3Array([hand_pos, Vector3.ZERO]))
