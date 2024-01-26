extends RigidBody2D

var over = false
func _ready():
	get_parent().get_node("Player").connect("hit", speed_up)
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if over:
		var velocity = Vector2(10.0, 0.0).rotated(rotation)
		linear_velocity.x += velocity.x
		linear_velocity.y += velocity.y

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func speed_up():
	over = true

