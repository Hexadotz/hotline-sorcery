extends Node2D

#variables, fresh from my ass
@export var player: PlayerScript
@export var hand: Node2D
@export var back: Node2D
@export var staff: Node2D
@export var pickup_raduis: Area2D

var wep_list: Array[Node2D]
var weapons_dropped: bool = false # this is used so we don't call the drop weapons function too many times
#-------------------------------------------#
func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if !player.IS_DEAD:
		if Input.is_action_just_pressed("drop-pickup"):
			_pickup_weapon()
		
		if Input.is_action_just_pressed("switch_wep"):
			_switch_wepV2()
		
	#once the player dies, drop all weapons, just once
	else:
		if !weapons_dropped:
			_drop_weapons()

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

func _drop_weapons() -> void:
	var prim_wep = hand.get_child(0) if hand.get_child_count() != 0 else null
	var sec_wep = back.get_child(0) if back.get_child_count() != 0 else null
	
	#fucking stupid ugly hack, i hate this
	if prim_wep != null:
		prim_wep.reparent(player.cur_scene)
		if prim_wep.get("active") != null:
			prim_wep.active = false
	if sec_wep != null:
		sec_wep.reparent(player.cur_scene)
		if sec_wep.get("active") != null:
			sec_wep.active = false
	weapons_dropped = true
