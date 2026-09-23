extends Components
class_name TRIGGER_AREA

var action_array:Array[Callable]

func player_interact():
	for action:Callable in self.action_array:
		action.call(self.get_parent())
	
