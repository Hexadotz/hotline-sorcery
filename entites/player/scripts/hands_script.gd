extends Node2D

#variables, fresh from my ass
@export var player: PlayerScript
@export var hand: Node2D
@export var back: Node2D
@export var staff: Node2D
@export var pickup_raduis: Area2D

var wep_list: Array[Node2D] 
#-------------------------------------------#
func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("drop-pickup"):
		_pickup_weapon()
	
	if Input.is_action_just_pressed("switch_wep"):
		_switch_wepV2()

#NOTE: i hate this
func _switch_wepV2() -> void:
	#this has to be typed to stop godot from bitching, why dosen't get_child return null when the index out of range???
	var cur_wep: Node2D = null if hand.get_child_count() == 0 else hand.get_child(0)
	
	if cur_wep != null:
		#same as line 28
		var sec_wep: Node2D = null if back.get_child_count() == 0 else back.get_child(0)
		
		cur_wep.reparent(back, false)
		
		cur_wep.active = false
		cur_wep.global_transform = back.global_transform
		
		#if our back isn't empty put whatever is there back at our hands
		if sec_wep != null:
			sec_wep.reparent(hand, false)
			sec_wep.active = true
			sec_wep.global_transform = hand.global_transform
	else:
		var sec_wep: Node2D = back.get_child(0)
		sec_wep.reparent(hand, false)
		
		sec_wep.active = true
		sec_wep.global_transform = hand.global_transform

func _pickup_weapon() -> void:
	#picking up the first weapon in the pickup raduis
	if pickup_raduis.has_overlapping_bodies():
		var list: Array[Node2D] = pickup_raduis.get_overlapping_bodies()
		for wep in list:
			#NOTE: working but i need to clean this somehow... fuck
			if hand.get_child_count() + back.get_child_count() < 2:
				#if we have the staff already equipped switch it to the back
				if hand.get_child_count() == 1:
					var cur_wep: Node2D = null if hand.get_child_count() == 0 else hand.get_child(0) 
					
					cur_wep.reparent(back, false)
					cur_wep.active = false
					cur_wep.global_transform = back.global_transform
				
				#put the weapon we picked up in our hands
				wep.reparent(hand, false)
				wep.pickup()
				wep.global_transform = hand.global_transform
