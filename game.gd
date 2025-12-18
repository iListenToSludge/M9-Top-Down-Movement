extends Node2D

@onready var _hit_box: Area2D = %HitBox

@onready var _bouncer: CharacterBody2D = %Bouncer
@onready var count_down: CountDown = %CountDown
@onready var runner: Runner = %Runner
@onready var _finish_line: FinishLine = %FinishLine

func _ready() -> void:
	_finish_line.body_entered.connect(func (body: Node) -> void:
		if body is not RunnerVisual:
			return
		var _runner := body as RunnerVisual

		runner.set_physics_process(false)
		var destination_position := (
			_finish_line.global_position
			+ Vector2(0, 64)
		)

		runner.walk_to(destination_position)
		runner.walked_to.connect(
			_finish_line.pop_confettis
		)
	)

	_finish_line.confettis_finished.connect(
		get_tree().reload_current_scene.call_deferred
	)
	count_down.start_counting()
	runner.set_physics_process(false)
	count_down.counting_finished.connect(
		func() -> void:
		runner.set_physics_process(true)
		_bouncer.set_physics_process(false)
		count_down.counting_finished.connect(
		func() -> void:
			_bouncer.set_physics_process(true)
		)
	)
	_hit_box.body_entered.connect(func(body: Node) -> void:
		if body is Runner:
			get_tree().reload_current_scene.call_deferred()
	)
	
	
