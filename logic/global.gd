# EGG is an abbrivation of Eclt Game Global.
extends Node
# Singnals
@warning_ignore("unused_signal")
signal OnMessageSend(message:String)
# Fields
var DebugInfo:Dictionary[String,Variant] = {
	"GameVersionName":0.1,
	"VersionType":"Dev",
	"GameName":"Game",
	"OSName":OS.get_name(),
	"ProcessorName":OS.get_processor_name() ,
	"VideoAdapterName":RenderingServer.get_video_adapter_name(),
	"ArchitectureName":Engine.get_architecture_name(),
	"MaxFPS":Engine.max_fps,
	"CurrentFPS":-1,
	"EngineVersionName":Engine.get_version_info().string,
	"FrameRenderingTime":float(-1),
	"PlayerPosition":Vector2(),
	"RenderingDriverName":RenderingServer.get_current_rendering_driver_name(),
	"IsEmulator":OS.get_model_name().to_lower().contains("emulator"),
	"RespawnPosition":Vector2(),
	"PlayerVelocity":Vector2()
}
var MainPlayer:CharacterBody2D = null
var ISVertrulKeyMovementPressed:bool = false
var FloattingText:Resource = preload("res://sences/tiny_sence/Objects/floatting_text.tscn")
#Functions
func Display_up_floatting_text(target_node:Node2D,text:String) -> void:
	# 主要变量
	var text_root:Node2D = EGG.FloattingText.instantiate()
	var main_text = text_root.get_child(0)
	# 初始化变换
	target_node.add_child(text_root)
	text_root.position = Vector2(0,0)
	main_text.text = text
	await get_tree().process_frame # 相当于 事件:游戏帧更新
	text_root.position.y -= main_text.size.y
	# 动画配置 & 执行
	var text_animation_player:AnimationPlayer = main_text.get_child(0)
	var text_animation:Animation = text_animation_player.get_animation("disappear")
	text_animation.track_set_key_value(0,0,
	  Vector2(text_root.position.x - main_text.size.x / 2,
	  text_root.position.y))
	text_animation.track_set_key_value(0,1,
	  Vector2(text_root.position.x - main_text.size.x / 2,
	  text_root.position.y - 50))
	text_animation_player.current_animation = "disappear"
	# 删除节点计时器
	var text_destory_timer:Timer = main_text.get_child(1)
	text_destory_timer.start(0.4)
	await text_destory_timer.timeout
	text_root.queue_free()
