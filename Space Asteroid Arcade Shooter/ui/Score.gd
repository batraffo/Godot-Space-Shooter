extends Label


func update_score(pointsc):
	var score= int (text)
	score += pointsc
	text= str(score)

func reset():
	text=str(0)
