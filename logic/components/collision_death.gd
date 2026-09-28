extends Components
class_name COLLISION_DEATH_PLAYER
## 碰撞玩家后使玩家传送到重生点

func _on_unit_entered(area: Area2D) -> void:
	if area.get_parent() == EGG.MainPlayer:
		EGG.MainPlayer.position = EGG.MainPlayer.respawn_position
