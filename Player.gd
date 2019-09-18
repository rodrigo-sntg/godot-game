extends Area2D
signal hit

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
var is_attacking = false
var is_dead = false

func _ready():
	screen_size = get_viewport_rect().size	
	#hide()
	pass # Replace with function body.
	


func _process(delta):
	if is_dead == true:
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.play("dead")
		return
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		if is_attacking == false && is_dead == false:
			$AnimatedSprite.play("idle")


	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0
		if velocity.x < 0:
			get_node("Atack/CollisionWeapon").position.x = -41
		else: get_node("Atack/CollisionWeapon").position.x = 41
    
		
func _on_Player_body_entered(body):
	if is_attacking == true:
		return
	$AnimatedSprite.play("dying")  # Player disappears after being hit.
	emit_signal("hit")
	is_dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	is_dead = false
	$CollisionShape2D.disabled = false
	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_A:	
			$AnimatedSprite.play("atack")
			is_attacking = true
			get_node("Atack/CollisionWeapon").disabled = false
			yield($AnimatedSprite, "animation_finished")
			get_node("Atack/CollisionWeapon").disabled = true
			is_attacking = false
		if event.pressed and event.scancode == KEY_X:	
			$AnimatedSprite.play("jump")
			var velocity = Vector2()
			$AnimatedSprite.position.y -= 10
			yield(get_tree().create_timer(.1), "timeout")
			$AnimatedSprite.position.y += 10

func _on_atack_body_entered(body):
	body.die()