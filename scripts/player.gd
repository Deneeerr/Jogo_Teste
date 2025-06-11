extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var is_jumping := false
@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D

func _physics_process(delta: float) -> void:
	# Adiciona gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		is_jumping = false  # Só marca como não pulando quando toca o chão

	# Pulo com tecla "accept" ou "up"
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true

	# Movimento lateral
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction  # Espelha o sprite dependendo da direção
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)  # Desaceleração

	# Controle de animações
	if is_jumping:
		animation.play("jump")
	elif direction:
		animation.play("run")
	else:
		animation.play("idle")

	# Aplica o movimento
	move_and_slide()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		queue_free()
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
