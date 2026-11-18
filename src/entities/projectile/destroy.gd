extends Timer

func _on_timeout() -> void:
	owner.queue_free()
