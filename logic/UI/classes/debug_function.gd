extends Node
##调试功能

#Fields
var DebugInfo:Dictionary[String,Variant] = {
	"GameVersionName":0.1,
	"VersionType":"Dev",
	"GameName":"Game",
	"OSName":OS.get_name(),
	"ProcessorName":OS.get_processor_name(),
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
#Functions
# 获取静态调试消息文本(首选显示在右侧)
func get_formatted_static_info() -> String:
	return '''{GameName} {VersionType} {GameVersionName}({RenderingDriverName})
	OS:{OSName} Imitate:{IsEmulator}
	Godot:{EngineVersionName}
	CPU:{ProcessorName}(arrch:{ArchitectureName})
	GPU:{VideoAdapterName}'''.format(DebugFunction.DebugInfo)
# 获取动态调试消息文本(首选显示在左侧)
func get_formatted_dynamic_info() -> String:
	return '''FPS:{CurrentFPS}/{MaxFPS}({FrameRenderingTime})
	Pos(X,Y):{PlayerPosition}
	Respawn(X,Y):{RespawnPosition}
	Velocity(X,Y):{PlayerVelocity}'''.format(DebugFunction.DebugInfo)
