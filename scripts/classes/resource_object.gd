extends Node3D
class_name ResourceObject

@export var resource_type: TeamData.resource_type
@export var content: int = 10
@export var collect_cooldown: float = 0.5
@export var respawn_timer: float = 10
var is_dead = false
var can_collect = true

func on_collect(player: Player):
	if not is_dead:
		can_collect = false
		get_tree().create_timer(collect_cooldown).timeout.connect(func(): can_collect = true)
		$CollectSFX.play()
		player.on_resource_collected(resource_type)
		content -= 1
		if content <= 0:
			die()


func die():
	$DieSFX.play()
	$Stump.visible = true
	$Cylinder.visible = false
	is_dead = true
	get_tree().create_timer(5).timeout.connect(revive)


func revive():
	$Stump.visible = false
	$Cylinder.visible = true
	is_dead = false
	content = 10
