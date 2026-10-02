# EGG is an abbrivation of Eclt Game Global.
extends Node
# Fields
var MainPlayer:CharacterBody2D = null
var PlayerUserName:String = "Player"
var ISVirtualKeyMovementPressed:bool = false
var OSType:String = "E" if OS.get_name() == "Android" or OS.get_name() == "IOS" else "C"
