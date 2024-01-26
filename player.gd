extends Area2D
signal hit

@export var max_speed = 400
@export var friction = 5
@export var directional_rotation = 1
@export var speed = 12
var screen_size
var velocity = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size	

func _process(delta):
	var input = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	if Input.is_action_pressed("move_up"):
		input.y -= 1
	if Input.is_action_pressed("move_down"):
		input.y += 1
	
	input = input.normalized()
	if input.x != 0:
		velocity.x = move_toward(velocity.x, input.x * max_speed, speed)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
	if input.y != 0:
		velocity.y = move_toward(velocity.y, input.y * max_speed, speed)
	else:
		velocity.y = move_toward(velocity.y, 0, friction)
	
	if input.length() > 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	#ROTATION
	var normalized_velocity = velocity / max_speed
	normalized_velocity = normalized_velocity.normalized() * abs(normalized_velocity)
	make_rotation(normalized_velocity, 0.01 * directional_rotation * (abs(normalized_velocity.x) + abs(normalized_velocity.y)))
	make_rotation(input, 0.1)
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if position.x == screen_size.x || position.x == 0:
		velocity.x = 0
	if position.y == screen_size.y || position.y == 0:
		velocity.y = 0

func make_rotation(input, value):
	var angle = rotation
	
	if input.x != 0 || input.y !=0:
		angle = atan2(input.x, -input.y)
		if rotation - angle > 3.14159:
			angle += 2*3.14159
		elif rotation - angle < -3.14159:
			angle -= 2*3.14159
	
	rotation = move_toward(rotation, angle, value)
	if rotation > 3.14159:
		rotation -= 2*3.14159
	elif rotation < -3.14159:
		rotation += 2*3.14159


func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false
