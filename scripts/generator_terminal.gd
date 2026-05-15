extends Area3D

var is_player_inside = false

func _ready():
	# Підключаємо сигнали виявлення гравця
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		is_player_inside = true
		print("Гравець у зоні ремонту. Тисни E!")

func _on_body_exited(body):
	if body.name == "Player":
		is_player_inside = false

func _process(_delta):
	if is_player_inside and Input.is_action_just_pressed("interact"):
		repair()

func repair():
	if BaseManager:
		BaseManager.energy_level += 15
		if BaseManager.energy_level > 100:
			BaseManager.energy_level = 100
		
		if has_node("OmniLight3D"):
			var light = $OmniLight3D
			light.light_color = Color.GREEN
			await get_tree().create_timer(0.5).timeout
			light.light_color = Color.AZURE
			
		print("Енергія відновлена: ", BaseManager.energy_level, "%")
