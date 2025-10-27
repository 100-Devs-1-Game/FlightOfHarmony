extends Cutscene


func on_finished():
	LevelManager.goto_start()
