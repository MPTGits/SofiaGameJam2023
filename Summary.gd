extends Control

var data = null;

func _process(delta):
	if data != null:
		position = get_global_mouse_position()
		# Assuming you have Labels with these names on your summary screen
		$box/TotalEnemiesLabel.text = "Total Enemies: " + str(data["summary"]["total_enemies"]) 

		var countByUserText = "Number of enemies spawn by user:\n"
		for user in data["summary"]["count_by_user"]:
			countByUserText += user + ": " + str(data["summary"]["count_by_user"][user]) + " | "
		$box/CountByUserLabel.text = countByUserText + "\n"

		var countByEnemyText = "Number of enemies spawn by type:\n"
		for enemy_type in data["summary"]["count_by_enemy"]:
			countByEnemyText += enemy_type + ": " + str(data["summary"]["count_by_enemy"][enemy_type]) + " | "
		$box/CountByEnemyLabel.text = countByEnemyText+ "\n"

		var rareUsersText = "Rare enemies spawn:\n"
		for enemy_type in data["summary"]["rare_users"]:
			rareUsersText += enemy_type + ": " + ", ".join(data["summary"]["rare_users"][enemy_type]) +  " | "
		$box/RareUsersLabel.text = rareUsersText+ "\n"
		
		$end_screen.visible = true
