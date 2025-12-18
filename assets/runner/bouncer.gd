extends CharacterBody2D

@export var max_speed := 600.0
@export var acceleration := 1200.0
@export var deceleration := 1080.0
@onready var runner_visual: RunnerVisual = %RunnerVisualPurple
@onready var dust: GPUParticles2D = %Dust

func _physics_process(delta: float) -> void:
	var direction := global_position.direction_to(get_global_player_position())
	var has_input_direction := direction.length() > 0.0
	if has_input_direction:
		var desired_velocity := direction * max_speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)

	move_and_slide()

	if direction.length() > 0.0:
		runner_visual.angle = rotate_toward(runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)

		var current_speed_percent := velocity.length() / max_speed
		runner_visual.animation_name = (
			RunnerVisual.Animations.WALK
			if current_speed_percent < 0.8
			else RunnerVisual.Animations.RUN
		)
		dust.emitting = true
	else:
		runner_visual.animation_name = RunnerVisual.Animations.IDLE
		dust.emitting = false
	var _distance := global_position.distance_to(get_global_player_position())

func get_global_player_position() -> Vector2:
	return get_tree().root.get_node("Game/Runner").global_position
