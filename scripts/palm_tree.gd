extends Node3D

@export var content: int = 10
@export var respawn_timer: float = 10
var is_dead = false
var can_collect = true

func on_collect(player: Player):
	if not is_dead:
		can_collect = false
		get_tree().create_timer(0.2).timeout.connect(func(): can_collect = true)
		$ChopSFX.play()
		player.on_wood_collected()
		content -= 1
		if content <= 0:
			die()


func die():
	$DieSFX.play()
	$stump.visible = true
	$tree.visible = false
	is_dead = true
	get_tree().create_timer(5).timeout.connect(revive)


func revive():
	$stump.visible = false
	$tree.visible = true
	is_dead = false
	content = 10
