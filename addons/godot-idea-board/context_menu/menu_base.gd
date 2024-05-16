#01. tool
@tool
#02. class_name

#03. extends
extends PopupMenu
#-----------------------------------------------------------
#04. # docstring
## hoge
#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------
#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------
#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------
#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------
#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------
#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
var _parent
var _icon
#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------
#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------

func _ready():
	_parent = get_parent().get_parent()
	clear()
	index_pressed.connect(_on_index_pressed)
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
#	表示したときに最初のアイテムをフォーカスする
	if visible:
		set_focused_item(0)

func _on_index_pressed(index:int):
	pass

func _input(event):
#	クリックしたら表示を消す
	if visible and event is InputEventMouseButton and !event.pressed:
		hide.call_deferred()
	pass

#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------
