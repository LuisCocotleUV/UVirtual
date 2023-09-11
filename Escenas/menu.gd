extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$contenedorMenuPrincipal/bttnIniciar.grab_focus()

func _on_bttn_iniciar_pressed():
	get_tree().change_scene_to_file("res://Escenas/mundo.tscn")


func _on_bttn_salir_pressed():
	get_tree().quit()
