extends RigidBody2D
signal hit

export var min_speed = 200  # Minimum speed range.
export var max_speed = 350  # Maximum speed range.
var mob_types = ["walk", "swim", "fly"]
enum STATES {ACTIVE, DEAD}
var currentState = STATES.ACTIVE

func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


func _on_Visibility_screen_exited():
	queue_free()

func _on_start_game():
	queue_free()

func _on_Mob_body_shape_entered(body_id, body, body_shape, local_shape):
	queue_free()
	currentState = STATES.DEAD
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func die():
	currentState = STATES.DEAD
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	hide()