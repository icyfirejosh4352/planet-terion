extends Node

signal shards_changed(total: int)

var shards: int = 0

func add_shard(amount: int) -> void:
	shards += amount
	shards_changed.emit(shards)

func spend_shards(amount: int) -> bool:
	if amount > shards:
		return false
	shards -= amount
	shards_changed.emit(shards)
	return true
