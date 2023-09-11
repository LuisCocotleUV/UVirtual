extends Control

@export var mundo : Pausa

func _ready():
	hide()
	mundo.connect("activarPausa", habilitarPausa)

func habilitarPausa(is_paused : bool):
	if(is_paused):
		show()
	else:
		hide()

func _on_bttn_continuar_pressed():
	mundo.juegoPausado = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_bttn_salir_pressed():
	get_tree().quit()
