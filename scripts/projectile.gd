class_name Projectile
extends Area2D

@export var viable_targets = ["enemy"]
@export var speed = 200.0
@export var damage: float
@export var damage_type: String = "normal"
@export var grav: float
@export var pierce_count = 0
@export var pierces_terrain = false 
@export var lifetime = 10.0

var radius_mod = 1.0
var grav_builtup = 0.0
var targets_already_hit = []

func _ready() -> void:
	body_entered.connect(_body_entered)

func _physics_process(delta: float) -> void:
	# moving
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
	grav_builtup += grav * delta
	position.x += cos(rotation) * speed * delta
	position.y += sin(rotation) * speed * delta + grav_builtup * delta


func _body_entered(body: Node2D) -> void:
	hit_trigger()
	hit_trigger_entity(body)
	#hits and stuff
	if not targets_already_hit.has(body):
		for g in body.get_groups():
			if viable_targets.has(str(g)):
				body.take_damage(damage, damage_type)
				targets_already_hit.append(body)
				pierce_count -= 1
				if pierce_count <= 0:
					queue_free()
	
	if body.is_in_group("terrain"):
		queue_free()

## override it with something
func hit_trigger() -> void:
	pass

## override it with something. except it's triggering on the entity
func hit_trigger_entity(body: Node2D) -> void:
	pass
