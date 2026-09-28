class_name Inventory
extends Node

signal weapon_added(weapon)
signal weapon_removed(weapon)
signal equipped_changed(weapon)

@export var weapons: Array[Weapon] = []
@export var equipped_index: int

enum equipped{NULL, GUN, SWORD, SWORD_UPGRADE}
@export var equippedWeapon:equipped

func _ready() -> void:
	if weapons != null:
		for i in weapons:
			if i != null:
				equip_weapon(i.get_index())
				
	owner = get_parent()

func process(delta: float) -> void:
	if get_equipped() !=  null:
		if get_equipped().name == "Pistol":
			equippedWeapon = equipped.GUN
		elif get_equipped().name == "Knife":
			equippedWeapon = equipped.SWORD
	else:
		equippedWeapon = equipped.NULL
		equipped_index = -1
func add_weapon(weapon: Weapon) -> void:
	if weapon and not weapons.has(weapon):
		weapons.append(weapon)
		weapon_added.emit(weapon)
		if equipped_index == -1:
			equip_weapon(weapons.size() - 1)

func remove_weapon(weapon: Weapon) -> void:
	var idx = weapons.find(weapon)
	
	if idx == -1:
		return
	weapons.remove_at(idx)
	weapon_removed.emit(weapon)
	
	if equipped_index >= idx:
		equipped_index = max(-1, equipped_index - 1)
		
	if equipped_index == -1 and weapons.size() > 0:
		equip_weapon(0)

func get_weapon_at(index: int) -> Weapon:
	return weapons[index] if index >= 0 and index < weapons.size() else null

func get_equipped() -> Weapon:
	return get_weapon_at(equipped_index)
	
func equip_weapon(index: int) -> void:
	if index < 0 or index >= weapons.size():
		return
	var new_weapon = weapons[index]
	if new_weapon == get_equipped():
		return
	equipped_index = index
	equipped_changed.emit(new_weapon)

func next_weapon() -> void:
	if weapons.is_empty():
		return
	var next_idx = (equipped_index + 1) % weapons.size()
	equip_weapon(next_idx)

func prev_weapon() -> void:
	if weapons.is_empty():
		return
	var prev_idx = (equipped_index - 1 + weapons.size()) % weapons.size()
	equip_weapon(prev_idx)

func has_weapon_type(class_Name: String) -> bool:
	for w in weapons:
		if w.get_class() == class_Name:
			return true
	return false
