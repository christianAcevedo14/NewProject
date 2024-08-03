extends Node2D


@export var speed = 300
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play("walk")
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#player vector
	var velocity = Vector2.ZERO
	
	#constantly check for inputs
	if Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.flip_h = false
		velocity.x += 1
	if  Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.flip_h = true
		velocity.x -= 1
	if  Input.is_action_pressed("move_down"):
		velocity.y += 1	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	#normalize velocity so that if diagonal, speed doesnt get multiplied		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		if $AnimatedSprite2D.animation != "light_attack":
			$AnimatedSprite2D.play("walk")
			
	if velocity.length() == 0 && $AnimatedSprite2D.animation != "light_attack":
		$AnimatedSprite2D.stop()
		
	if(Input.is_action_just_pressed("light_attack")):
		$AnimatedSprite2D.play("light_attack")
		
		#keeps the position of the player inside the screen
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	
func start(pos):
	position = pos
	show()
	$Light_Attack.disabled = false
	



func _on_animated_sprite_2d_animation_looped():
	if $AnimatedSprite2D.animation == "light_attack":
		$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.stop()
