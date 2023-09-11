extends Node3D

# Pausar el juego
class_name Pausa

signal activarPausa(is_paused : bool)

var juegoPausado : bool = false:
	get:
		return juegoPausado
	set(value):
		juegoPausado = value
		get_tree().paused = juegoPausado
		emit_signal("activarPausa", juegoPausado)

func _input(event: InputEvent):
	if(event.is_action_pressed("Pausa")):
		juegoPausado = !juegoPausado
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
