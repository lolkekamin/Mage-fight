extends GridContainer

class Character:
	var type: int
	var team: int

	func _init(_type, _team):
		type = _type
		team = _team

enum characters{
	NONE = 0,
	DJIN = 1,
	SWORDSMAN = 2,
	KING = 3,
	UNICORN = 4,
	SKELETON = 5,
	ARCHER = 6,
	DRAGON = 7,
}
var board = []
var textures = {
	characters.NONE : load("res://assets/back.png"),
	characters.DJIN : load("res://assets/djin.png"),
	characters.SWORDSMAN : load("res://assets/swordsman.png"),
	characters.KING : load("res://assets/king.png"),
	characters.UNICORN : load("res://assets/unicorn.png"),
	characters.SKELETON : load("res://assets/skel.png"),
	characters.ARCHER : load("res://assets/archer.png"),
	characters.DRAGON : load("res://assets/dragon.png"),
}
var textures_2 = {
	characters.NONE : load("res://assets/back.png"),
	characters.DJIN : load("res://assets/djin2.png"),
	characters.SWORDSMAN : load("res://assets/swordsman2.png"),
	characters.KING : load("res://assets/king2.png"),
	characters.UNICORN : load("res://assets/unicorn2.png"),
	characters.SKELETON : load("res://assets/skel2.png"),
	characters.ARCHER : load("res://assets/archer2.png"),
	characters.DRAGON : load("res://assets/dragon2.png"),
}
var selected_pos = Vector2i(-1,-1)
var turn = 1
var mana_1 = 60
var mana_2 = 60
var status = false
var state_button = false
var fireball = false
var extra = false

func _ready():
	for x in range(8):
		board.append([])
		for y in range(8):
			board[x].append(Character.new(characters.NONE, 0))
			get_child(x+y*8).pos.x = x
			get_child(x+y*8).pos.y = y
	get_parent().get_child(3).text = "Mana p1 = " + str(mana_1) + "\nMana p2 = " + str(mana_2)
	board[0][5].type = characters.DJIN
	board[0][5].team = 1
	board[0][2].type = characters.DJIN
	board[0][2].team = 1
	board[0][7].type = characters.ARCHER
	board[0][7].team = 1
	board[7][7].type = characters.ARCHER
	board[7][7].team = 2
	board[0][0].type = characters.ARCHER
	board[0][0].team = 1
	board[7][0].type = characters.ARCHER
	board[7][0].team = 2
	board[0][4].type = characters.KING
	board[0][4].team = 1
	board[0][6].type = characters.UNICORN
	board[0][6].team = 1
	board[7][6].type = characters.UNICORN
	board[7][6].team = 2
	board[0][1].type = characters.UNICORN
	board[0][1].team = 1
	board[7][1].type = characters.UNICORN
	board[7][1].team = 2
	board[7][5].type = characters.DJIN
	board[7][5].team = 2
	board[7][2].type = characters.DJIN
	board[7][2].team = 2
	board[7][4].type = characters.KING
	board[7][4].team = 2
	board[7][3].type = characters.DRAGON
	board[7][3].team = 2
	board[0][3].type = characters.DRAGON
	board[0][3].team = 1
	board[1][0].type = characters.SWORDSMAN
	board[1][0].team = 1
	board[6][7].type = characters.SWORDSMAN
	board[6][7].team = 2
	board[1][1].type = characters.SWORDSMAN
	board[1][1].team = 1
	board[6][6].type = characters.SWORDSMAN
	board[6][6].team = 2
	board[1][2].type = characters.SWORDSMAN
	board[1][2].team = 1
	board[6][5].type = characters.SWORDSMAN
	board[6][5].team = 2
	board[1][3].type = characters.SWORDSMAN
	board[1][3].team = 1
	board[6][4].type = characters.SWORDSMAN
	board[6][4].team = 2
	board[1][4].type = characters.SWORDSMAN
	board[1][4].team = 1
	board[6][3].type = characters.SWORDSMAN
	board[6][3].team = 2
	board[1][5].type = characters.SWORDSMAN
	board[1][5].team = 1
	board[6][2].type = characters.SWORDSMAN
	board[6][2].team = 2
	board[1][6].type = characters.SWORDSMAN
	board[1][6].team = 1
	board[6][1].type = characters.SWORDSMAN
	board[6][1].team = 2
	board[1][7].type = characters.SWORDSMAN
	board[1][7].team = 1
	board[6][0].type = characters.SWORDSMAN
	board[6][0].team = 2
	update_board()


func tile_pressed(pos: Vector2i):
	if !(selected_pos.x >= 0 and selected_pos.y >= 0):
		if board[pos.x][pos.y].team == turn:
			selected_pos = pos
		elif state_button:
				if fireball:
					if turn == 1:
						if board[pos.x][pos.y].team == 2 and !(board[pos.x][pos.y].type == characters.KING):
							var king_pos = Vector2i(-1,-1)
							for x in range(8):
								for y in range(8):
									if board[x][y].team == 1 and board[x][y].type == characters.KING:
										king_pos = Vector2i(x, y)
							if moves(king_pos):
								board[pos.x][pos.y].type = characters.NONE
								board[pos.x][pos.y].team = 0
								turn = 2
								mana_1 -= 30
								self.get_child(pos.x+pos.y*8).get_child(2).play("Fireball")
					else:
						if board[pos.x][pos.y].team == 1 and !(board[pos.x][pos.y].type == characters.KING):
							var king_pos = Vector2i(-1,-1)
							for x in range(8):
								for y in range(8):
									if board[x][y].team == 2 and board[x][y].type == characters.KING:
										king_pos = Vector2i(x, y)
							if moves(king_pos):
								board[pos.x][pos.y].type = characters.NONE
								board[pos.x][pos.y].team = 0
								turn = 1
								mana_2 -= 30
								self.get_child(pos.x+pos.y*8).get_child(2).play("Fireball")
					fireball = false
					state_button = false
				selected_pos = Vector2i(-1, -1)
	else:
		if board[pos.x][pos.y].team == turn:
			selected_pos = pos
		elif state_button:
				if fireball:
					if turn == 1:
						if board[pos.x][pos.y].team == 2 and !(board[pos.x][pos.y].type == characters.KING):
							var king_pos = Vector2i(-1,-1)
							for x in range(8):
								for y in range(8):
									if board[x][y].team == 1 and board[x][y].type == characters.KING:
										king_pos = Vector2i(x, y)
							if moves(king_pos):
								board[pos.x][pos.y].type = characters.NONE
								board[pos.x][pos.y].team = 0
								turn = 2
								mana_1 -= 30
								self.get_child(pos.x+pos.y*8).get_child(2).play("Fireball")
					else:
						if board[pos.x][pos.y].team == 1 and !(board[pos.x][pos.y].type == characters.KING):
							var king_pos = Vector2i(-1,-1)
							for x in range(8):
								for y in range(8):
									if board[x][y].team == 2 and board[x][y].type == characters.KING:
										king_pos = Vector2i(x, y)
							if moves(king_pos):
								board[pos.x][pos.y].type = characters.NONE
								board[pos.x][pos.y].team = 0
								turn = 1
								mana_2 -= 30
								self.get_child(pos.x+pos.y*8).get_child(2).play("Fireball")
					fireball = false
					state_button = false
				selected_pos = Vector2i(-1, -1)
		elif !state_button:
			match board[pos.x][pos.y].type:
				characters.DJIN:
					if selected_pos.x >= 0 and selected_pos.y >= 0:
						match board[selected_pos.x][selected_pos.y].type:
							characters.DJIN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 3
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 3
									selected_pos = Vector2i(-1, -1)
							characters.SWORDSMAN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 3
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 3
									selected_pos = Vector2i(-1, -1)
							characters.KING:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 3
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 3
									selected_pos = Vector2i(-1, -1)
							characters.SKELETON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 3
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 3
									selected_pos = Vector2i(-1, -1)
							characters.ARCHER:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									if pos.x > selected_pos.x+1 or pos.x < selected_pos.x-1 or pos.y > selected_pos.y+1 or pos.y < selected_pos.y-1 or pos.x < selected_pos.x-1 and pos.y < selected_pos.y-1 or pos.x > selected_pos.x+1 and pos.y > selected_pos.y+1 or pos.x < selected_pos.x-1 and pos.y > selected_pos.y+1 or pos.x > selected_pos.x+1 and pos.y < selected_pos.y-1:
										board[pos.x][pos.y].type = characters.NONE
										board[pos.x][pos.y].team = 0
									else:
										board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
										board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
										board[selected_pos.x][selected_pos.y].type = characters.NONE
										board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 3
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 3
									selected_pos = Vector2i(-1, -1)
							characters.DRAGON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 3
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 3
									selected_pos = Vector2i(-1, -1)
				characters.ARCHER:
					if selected_pos.x >= 0 and selected_pos.y >= 0:
						match board[selected_pos.x][selected_pos.y].type:
							characters.DJIN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 5
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 5
									selected_pos = Vector2i(-1, -1)
							characters.SWORDSMAN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 5
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 5
									selected_pos = Vector2i(-1, -1)
							characters.KING:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 5
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 5
									selected_pos = Vector2i(-1, -1)
							characters.SKELETON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 5
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 5
									selected_pos = Vector2i(-1, -1)
							characters.ARCHER:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									if pos.x > selected_pos.x+1 or pos.x < selected_pos.x-1 or pos.y > selected_pos.y+1 or pos.y < selected_pos.y-1 or pos.x < selected_pos.x-1 and pos.y < selected_pos.y-1 or pos.x > selected_pos.x+1 and pos.y > selected_pos.y+1 or pos.x < selected_pos.x-1 and pos.y > selected_pos.y+1 or pos.x > selected_pos.x+1 and pos.y < selected_pos.y-1:
										board[pos.x][pos.y].type = characters.NONE
										board[pos.x][pos.y].team = 0
									else:
										board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
										board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
										board[selected_pos.x][selected_pos.y].type = characters.NONE
										board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 5
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 5
									selected_pos = Vector2i(-1, -1)
							characters.DRAGON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 5
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 5
									selected_pos = Vector2i(-1, -1)
				characters.UNICORN:
					if selected_pos.x >= 0 and selected_pos.y >= 0:
						match board[selected_pos.x][selected_pos.y].type:
							characters.DJIN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.SWORDSMAN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.KING:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.SKELETON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.ARCHER:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									if pos.x > selected_pos.x+1 or pos.x < selected_pos.x-1 or pos.y > selected_pos.y+1 or pos.y < selected_pos.y-1 or pos.x < selected_pos.x-1 and pos.y < selected_pos.y-1 or pos.x > selected_pos.x+1 and pos.y > selected_pos.y+1 or pos.x < selected_pos.x-1 and pos.y > selected_pos.y+1 or pos.x > selected_pos.x+1 and pos.y < selected_pos.y-1:
										board[pos.x][pos.y].type = characters.NONE
										board[pos.x][pos.y].team = 0
									else:
										board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
										board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
										board[selected_pos.x][selected_pos.y].type = characters.NONE
										board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.DRAGON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
				characters.NONE:
					if selected_pos.x >= 0 and selected_pos.y >= 0:
						match board[selected_pos.x][selected_pos.y].type:
							characters.DJIN:
								if pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 1
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 1
									selected_pos = Vector2i(-1, -1)
							characters.SWORDSMAN:
								if pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 1
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 1
									selected_pos = Vector2i(-1, -1)
							characters.KING:
								if pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 1
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 1
									selected_pos = Vector2i(-1, -1)
							characters.SKELETON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 1
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 1
									selected_pos = Vector2i(-1, -1)
							characters.UNICORN:
								if pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if selected_pos.x > pos.x:
										if board[selected_pos.x-1][selected_pos.y].team != turn:
											board[selected_pos.x-1][selected_pos.y].type = characters.NONE
											board[selected_pos.x-1][selected_pos.y].team = 0
											match board[selected_pos.x-1][selected_pos.y].type:
												characters.DJIN:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 3
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 3
												characters.DRAGON:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 9
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 9
												characters.SWORDSMAN:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 2
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 2
												characters.UNICORN:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 2
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 2
												characters.ARCHER:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 5
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 5
												characters.KING:
													gameover()
												characters.NONE:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 1
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 1
										else: 
											if turn == 1:
												if !extra:
													turn = 2
												extra = false
												mana_1 += 1
											else:
												if !extra:
													turn = 1
												extra = false
												mana_2 += 1
									elif selected_pos.x < pos.x:
										if board[selected_pos.x+1][selected_pos.y].team != turn:
											board[selected_pos.x+1][selected_pos.y].type = characters.NONE
											board[selected_pos.x+1][selected_pos.y].team = 0
											match board[selected_pos.x+1][selected_pos.y].type:
												characters.DJIN:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 3
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 3
												characters.DRAGON:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 9
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 9
												characters.SWORDSMAN:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 2
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 2
												characters.UNICORN:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 2
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 2
												characters.ARCHER:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 5
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 5
												characters.KING:
													gameover()
												characters.NONE:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 1
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 1
										else: 
											if turn == 1:
												if !extra:
													turn = 2
												extra = false
												mana_1 += 1
											else:
												if !extra:
													turn = 1
												extra = false
												mana_2 += 1
									elif selected_pos.y > pos.y:
										if board[selected_pos.x][selected_pos.y-1].team != turn:
											board[selected_pos.x][selected_pos.y-1].type = characters.NONE
											board[selected_pos.x][selected_pos.y-1].team = 0
											match board[selected_pos.x][selected_pos.y-1].type:
												characters.DJIN:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 3
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 3
												characters.DRAGON:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 9
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 9
												characters.SWORDSMAN:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 2
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 2
												characters.UNICORN:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 2
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 2
												characters.ARCHER:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 5
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 5
												characters.KING:
													gameover()
												characters.NONE:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 1
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 1
										else: 
											if turn == 1:
												if !extra:
													turn = 2
												extra = false
												mana_1 += 1
											else:
												if !extra:
													turn = 1
												extra = false
												mana_2 += 1
									elif selected_pos.y < pos.y:
										if board[selected_pos.x][selected_pos.y+1].team != turn:
											board[selected_pos.x][selected_pos.y+1].type = characters.NONE
											board[selected_pos.x][selected_pos.y+1].team = 0
											match board[selected_pos.x][selected_pos.y+1].type:
												characters.DJIN:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 3
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 3
												characters.DRAGON:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 9
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 9
												characters.SWORDSMAN:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 2
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 2
												characters.UNICORN:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 2
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 2
												characters.ARCHER:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 5
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 5
												characters.KING:
													gameover()
												characters.NONE:
													if turn == 1:
														if !extra:
															turn = 2
														extra = false
														mana_1 += 1
													else:
														if !extra:
															turn = 1
														extra = false
														mana_2 += 1
										else: 
											if turn == 1:
												if !extra:
													turn = 2
												extra = false
												mana_1 += 1
											else:
												if !extra:
													turn = 1
												extra = false
												mana_2 += 1
									selected_pos = Vector2i(-1, -1)
							characters.ARCHER:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
											extra = false
										mana_1 += 1
									else:
										if !extra:
											turn = 1
											extra = false
										mana_2 += 1
									selected_pos = Vector2i(-1, -1)
							characters.DRAGON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 1
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 1
									selected_pos = Vector2i(-1, -1)
				characters.SWORDSMAN:
					if selected_pos.x >= 0 and selected_pos.y >= 0:
						match board[selected_pos.x][selected_pos.y].type:
							characters.DJIN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.SWORDSMAN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.KING:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.SKELETON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.ARCHER:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									if pos.x > selected_pos.x+1 or pos.x < selected_pos.x-1 or pos.y > selected_pos.y+1 or pos.y < selected_pos.y-1 or pos.x < selected_pos.x-1 and pos.y < selected_pos.y-1 or pos.x > selected_pos.x+1 and pos.y > selected_pos.y+1 or pos.x < selected_pos.x-1 and pos.y > selected_pos.y+1 or pos.x > selected_pos.x+1 and pos.y < selected_pos.y-1:
										board[pos.x][pos.y].type = characters.NONE
										board[pos.x][pos.y].team = 0
									else:
										board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
										board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
										board[selected_pos.x][selected_pos.y].type = characters.NONE
										board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.DRAGON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
				characters.KING:
					if selected_pos.x >= 0 and selected_pos.y >= 0:
						match board[selected_pos.x][selected_pos.y].type:
							characters.DJIN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										gameover()
									else:
										gameover()
									selected_pos = Vector2i(-1, -1)
							characters.SWORDSMAN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										gameover()
									else:
										gameover()
									selected_pos = Vector2i(-1, -1)
							characters.KING:
								if (selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										gameover()
									else:
										gameover()
									selected_pos = Vector2i(-1, -1)
							characters.SKELETON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										gameover()
									else:
										gameover()
									selected_pos = Vector2i(-1, -1)
							characters.ARCHER:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									if pos.x > selected_pos.x+1 or pos.x < selected_pos.x-1 or pos.y > selected_pos.y+1 or pos.y < selected_pos.y-1 or pos.x < selected_pos.x-1 and pos.y < selected_pos.y-1 or pos.x > selected_pos.x+1 and pos.y > selected_pos.y+1 or pos.x < selected_pos.x-1 and pos.y > selected_pos.y+1 or pos.x > selected_pos.x+1 and pos.y < selected_pos.y-1:
										board[pos.x][pos.y].type = characters.NONE
										board[pos.x][pos.y].team = 0
									else:
										board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
										board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
										board[selected_pos.x][selected_pos.y].type = characters.NONE
										board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										gameover()
									else:
										gameover()
									selected_pos = Vector2i(-1, -1)
							characters.DRAGON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										gameover()
									else:
										gameover()
									selected_pos = Vector2i(-1, -1)
				characters.SKELETON:
					if selected_pos.x >= 0 and selected_pos.y >= 0:
						match board[selected_pos.x][selected_pos.y].type:
							characters.DJIN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.SWORDSMAN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.KING:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.SKELETON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.ARCHER:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									if pos.x > selected_pos.x+1 or pos.x < selected_pos.x-1 or pos.y > selected_pos.y+1 or pos.y < selected_pos.y-1 or pos.x < selected_pos.x-1 and pos.y < selected_pos.y-1 or pos.x > selected_pos.x+1 and pos.y > selected_pos.y+1 or pos.x < selected_pos.x-1 and pos.y > selected_pos.y+1 or pos.x > selected_pos.x+1 and pos.y < selected_pos.y-1:
										board[pos.x][pos.y].type = characters.NONE
										board[pos.x][pos.y].team = 0
									else:
										board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
										board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
										board[selected_pos.x][selected_pos.y].type = characters.NONE
										board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
							characters.DRAGON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 2
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 2
									selected_pos = Vector2i(-1, -1)
				characters.DRAGON:
					if selected_pos.x >= 0 and selected_pos.y >= 0:
						match board[selected_pos.x][selected_pos.y].type:
							characters.DJIN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 9
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 9
									selected_pos = Vector2i(-1, -1)
							characters.SWORDSMAN:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 9
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 9
									selected_pos = Vector2i(-1, -1)
							characters.KING:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 9
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 9
									selected_pos = Vector2i(-1, -1)
							characters.SKELETON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 9
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 9
									selected_pos = Vector2i(-1, -1)
							characters.ARCHER:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									if pos.x > selected_pos.x+1 or pos.x < selected_pos.x-1 or pos.y > selected_pos.y+1 or pos.y < selected_pos.y-1 or pos.x < selected_pos.x-1 and pos.y < selected_pos.y-1 or pos.x > selected_pos.x+1 and pos.y > selected_pos.y+1 or pos.x < selected_pos.x-1 and pos.y > selected_pos.y+1 or pos.x > selected_pos.x+1 and pos.y < selected_pos.y-1:
										board[pos.x][pos.y].type = characters.NONE
										board[pos.x][pos.y].team = 0
									else:
										board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
										board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
										board[selected_pos.x][selected_pos.y].type = characters.NONE
										board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 9
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 9
									selected_pos = Vector2i(-1, -1)
							characters.DRAGON:
								if	(selected_pos!=pos) and board[pos.x][pos.y].team != board[selected_pos.x][selected_pos.y].team and pos in moves(selected_pos):
									board[pos.x][pos.y].type = board[selected_pos.x][selected_pos.y].type
									board[pos.x][pos.y].team = board[selected_pos.x][selected_pos.y].team
									board[selected_pos.x][selected_pos.y].type = characters.NONE
									board[selected_pos.x][selected_pos.y].team = 0
									if turn == 1:
										if !extra:
											turn = 2
										extra = false
										mana_1 += 9
									else:
										if !extra:
											turn = 1
										extra = false
										mana_2 += 9
									selected_pos = Vector2i(-1, -1)
	update_board()

func update_board():
	for x in range(8):
		for y in range(8):
			get_child(x+y*8).selected = false
			if board[x][y].team == 1:
				get_child(x+y*8).get_child(0).set_texture(textures[board[x][y].type])
			else:
				get_child(x+y*8).get_child(0).set_texture(textures_2[board[x][y].type])
	if selected_pos.x >= 0 and selected_pos.y >= 0:
		get_child(selected_pos.x+selected_pos.y*8).selected = true
		for move in moves(selected_pos):
			if move.x >= 0 and move.x <= 7 and move.y >= 0 and move.y <= 7:
				get_child(move.x+move.y*8).selected = true
	get_parent().get_child(3).text = "Mana p1 = " + str(mana_1) + "\nMana p2 = " + str(mana_2)

func moves(pos):
	var result = [] 
	match board[pos.x][pos.y].type:
		characters.DJIN:
			if pos.x+2 >= 0 and pos.x+2 <= 7 and pos.y+1 >= 0 and pos.y+1 <= 7 and board[pos.x+2][pos.y+1].team != turn:
				result.append(Vector2i(pos.x+2, pos.y+1))
			if pos.x+1 >= 0 and pos.x+1 <= 7 and pos.y+2 >= 0 and pos.y+2 <= 7 and board[pos.x+1][pos.y+2].team != turn:
				result.append(Vector2i(pos.x+1, pos.y+2))
			if pos.x-2 >= 0 and pos.x-2 <= 7 and pos.y-1 >= 0 and pos.y-1 <= 7 and board[pos.x-2][pos.y-1].team != turn:
				result.append(Vector2i(pos.x-2, pos.y-1))
			if pos.x-1 >= 0 and pos.x-1 <= 7 and pos.y-2 >= 0 and pos.y-2 <= 7 and board[pos.x-1][pos.y-2].team != turn:
				result.append(Vector2i(pos.x-1, pos.y-2))
			if pos.x+1 >= 0 and pos.x+1 <= 7 and pos.y-2 >= 0 and pos.y-2 <= 7 and board[pos.x+1][pos.y-2].team != turn:
				result.append(Vector2i(pos.x+1, pos.y-2))
			if pos.x-1 >= 0 and pos.x-1 <= 7 and pos.y+2 >= 0 and pos.y+2 <= 7 and board[pos.x-1][pos.y+2].team != turn:
				result.append(Vector2i(pos.x-1, pos.y+2))
			if pos.x+2 >= 0 and pos.x+2 <= 7 and pos.y-1 >= 0 and pos.y-1 <= 7 and board[pos.x+2][pos.y-1].team != turn:
				result.append(Vector2i(pos.x+2, pos.y-1))
			if pos.x-2 >= 0 and pos.x-2 <= 7 and pos.y+1 >= 0 and pos.y+1 <= 7 and board[pos.x-2][pos.y+1].team != turn:
				result.append(Vector2i(pos.x-2, pos.y+1))
			if pos.x+1 >= 0 and pos.x+1 <= 7 and pos.y+1 >= 0 and pos.y+1 <= 7 and board[pos.x+1][pos.y+1].team != turn:
				result.append(Vector2i(pos.x+1, pos.y+1))
			if pos.x+1 >= 0 and pos.x+1 <= 7 and pos.y-1 >= 0 and pos.y-1 <= 7 and board[pos.x+1][pos.y-1].team != turn:
				result.append(Vector2i(pos.x+1, pos.y-1))
			if pos.x-1 >= 0 and pos.x-1 <= 7 and pos.y-1 >= 0 and pos.y-1 <= 7 and board[pos.x-1][pos.y-1].team != turn:
				result.append(Vector2i(pos.x-1, pos.y-1))
			if pos.x-1 >= 0 and pos.x-1 <= 7 and pos.y+1 >= 0 and pos.y+1 <= 7 and board[pos.x-1][pos.y+1].team != turn:
				result.append(Vector2i(pos.x-1, pos.y+1))
		characters.SWORDSMAN:
			if pos.x+1 >= 0 and pos.x+1 <= 7 and pos.y >= 0 and pos.y <= 7 and board[pos.x+1][pos.y].team != turn:
				result.append(Vector2i(pos.x+1, pos.y))
			if pos.x-1 >= 0 and pos.x-1 <= 7 and pos.y >= 0 and pos.y <= 7 and  board[pos.x-1][pos.y].team != turn :
				result.append(Vector2i(pos.x-1, pos.y))
			if pos.x >= 0 and pos.x <= 7 and pos.y+1 >= 0 and pos.y+1 <= 7 and board[pos.x][pos.y+1].team != turn:
				result.append(Vector2i(pos.x, pos.y+1)) 
			if pos.x >= 0 and pos.x <= 7 and pos.y-1 >= 0 and pos.y-1 <= 7 and board[pos.x][pos.y-1].team != turn:
				result.append(Vector2i(pos.x, pos.y-1))
			if pos.x+1 >= 0 and pos.x+1 <= 7 and pos.y+1 >= 0 and pos.y+1 <= 7 and board[pos.x+1][pos.y+1].team != turn:
				result.append(Vector2i(pos.x+1, pos.y+1))
			if pos.x+1 >= 0 and pos.x+1 <= 7 and pos.y-1 >= 0 and pos.y-1 <= 7 and board[pos.x+1][pos.y-1].team != turn:
				result.append(Vector2i(pos.x+1, pos.y-1))
			if pos.x-1 >= 0 and pos.x-1 <= 7 and pos.y-1 >= 0 and pos.y-1 <= 7 and board[pos.x-1][pos.y-1].team != turn:
				result.append(Vector2i(pos.x-1, pos.y-1))
			if pos.x-1 >= 0 and pos.x-1 <= 7 and pos.y+1 >= 0 and pos.y+1 <= 7 and board[pos.x-1][pos.y+1].team != turn:
				result.append(Vector2i(pos.x-1, pos.y+1))
		characters.KING:
			for x in range(1,8):
				if pos.x+x >= 0 and pos.x+x <= 7 and pos.y >= 0 and pos.y <= 7:
					if board[pos.x+x][pos.y].type != characters.NONE and board[pos.x+x][pos.y].team == turn:
						break
					result.append(Vector2i(pos.x+x, pos.y))
					if board[pos.x+x][pos.y].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x-x >= 0 and pos.x-x <= 7 and pos.y >= 0 and pos.y <= 7:
					if board[pos.x-x][pos.y].type != characters.NONE and board[pos.x-x][pos.y].team == turn:
						break
					result.append(Vector2i(pos.x-x, pos.y))
					if board[pos.x-x][pos.y].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x >= 0 and pos.x <= 7 and pos.y+x >= 0 and pos.y+x <= 7:
					if board[pos.x][pos.y+x].type != characters.NONE and board[pos.x][pos.y+x].team == turn:
						break
					result.append(Vector2i(pos.x, pos.y+x))
					if board[pos.x][pos.y+x].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x >= 0 and pos.x <= 7 and pos.y-x >= 0 and pos.y-x <= 7:
					if board[pos.x][pos.y-x].type != characters.NONE and board[pos.x][pos.y-x].team == turn:
						break
					result.append(Vector2i(pos.x, pos.y-x))
					if board[pos.x][pos.y-x].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x+x >= 0 and pos.x+x <= 7 and pos.y+x >= 0 and pos.y+x <= 7:
					if board[pos.x+x][pos.y+x].type != characters.NONE and board[pos.x+x][pos.y+x].team == turn:
						break
					result.append(Vector2i(pos.x+x, pos.y+x))
					if board[pos.x+x][pos.y+x].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x+x >= 0 and pos.x+x <= 7 and pos.y-x >= 0 and pos.y-x <= 7:
					if board[pos.x+x][pos.y-x].type != characters.NONE and board[pos.x+x][pos.y-x].team == turn:
						break
					result.append(Vector2i(pos.x+x, pos.y-x))
					if board[pos.x+x][pos.y-x].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x-x >= 0 and pos.x-x <= 7 and pos.y-x >= 0 and pos.y-x <= 7:
					if board[pos.x-x][pos.y-x].type != characters.NONE and board[pos.x-x][pos.y-x].team == turn:
						break
					result.append(Vector2i(pos.x-x, pos.y-x))
					if board[pos.x-x][pos.y-x].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x-x >= 0 and pos.x-x <= 7 and pos.y+x >= 0 and pos.y+x <= 7:
					if board[pos.x-x][pos.y+x].type != characters.NONE and board[pos.x-x][pos.y+x].team == turn:
						break
					result.append(Vector2i(pos.x-x, pos.y+x))
					if board[pos.x-x][pos.y+x].type != characters.NONE:
						break
		characters.UNICORN:
			if pos.x+2 >= 0 and pos.x+2 <= 7 and pos.y >= 0 and pos.y <= 7 and board[pos.x+1][pos.y].type != characters.NONE and board[pos.x+2][pos.y].type == characters.NONE:
				result.append(Vector2i(pos.x+2, pos.y))
			if pos.x-2 >= 0 and pos.x-2 <= 7 and pos.y >= 0 and pos.y <= 7 and board[pos.x-1][pos.y].type != characters.NONE and board[pos.x-2][pos.y].type == characters.NONE:
				result.append(Vector2i(pos.x-2, pos.y))
			if pos.y+2 >= 0 and pos.y+2 <= 7 and pos.x >= 0 and pos.x <= 7 and board[pos.x][pos.y+1].type != characters.NONE and board[pos.x][pos.y+2].type == characters.NONE:
				result.append(Vector2i(pos.x, pos.y+2))
			if pos.x >= 0 and pos.x <= 7 and pos.y-2 >= 0 and pos.y-2 <= 7 and board[pos.x][pos.y-1].type != characters.NONE and board[pos.x][pos.y-2].type == characters.NONE:
				result.append(Vector2i(pos.x, pos.y-2))
		characters.SKELETON:
			if pos.x-2 >= 0 and pos.x-2 <= 7 and pos.y-2 >= 0 and pos.y-2 <= 7 and board[pos.x-2][pos.y-2].team != turn:
				result.append(Vector2i(pos.x-2, pos.y-2))
			if pos.x+2 >= 0 and pos.x+2 <= 7 and pos.y-2 >= 0 and pos.y-2 <= 7 and board[pos.x+2][pos.y-2].team != turn:
				result.append(Vector2i(pos.x+2, pos.y-2))
			if pos.x >= 0 and pos.x <= 7 and pos.y-2 >= 0 and pos.y-2 <= 7 and board[pos.x][pos.y-2].team != turn:
				result.append(Vector2i(pos.x, pos.y-2))
			if pos.x+2 >= 0 and pos.x+2 <= 7 and pos.y+2 >= 0 and pos.y+2 <= 7 and board[pos.x+2][pos.y+2].team != turn:
				result.append(Vector2i(pos.x+2, pos.y+2))
			if pos.x-2 >= 0 and pos.x-2 <= 7 and pos.y+2 >= 0 and pos.y+2 <= 7 and board[pos.x-2][pos.y+2].team != turn:
				result.append(Vector2i(pos.x-2, pos.y+2))
			if pos.x >= 0 and pos.x <= 7 and pos.y+2 >= 0 and pos.y+2 <= 7 and board[pos.x][pos.y+2].team != turn:
				result.append(Vector2i(pos.x, pos.y+2))
			if pos.x-2 >= 0 and pos.x-2 <= 7 and pos.y >= 0 and pos.y <= 7 and board[pos.x-2][pos.y].team != turn:
				result.append(Vector2i(pos.x-2, pos.y))
			if pos.x+2 >= 0 and pos.x+2 <= 7 and pos.y >= 0 and pos.y <= 7 and board[pos.x+2][pos.y].team != turn:
				result.append(Vector2i(pos.x+2, pos.y))
		characters.ARCHER:
			if pos.x+1 >= 0 and pos.x+1 <= 7 and pos.y >= 0 and pos.y <= 7 and board[pos.x+1][pos.y].team != turn:
				result.append(Vector2i(pos.x+1, pos.y))
			if pos.x-1 >= 0 and pos.x-1 <= 7 and pos.y >= 0 and pos.y <= 7 and  board[pos.x-1][pos.y].team != turn :
				result.append(Vector2i(pos.x-1, pos.y))
			if pos.x >= 0 and pos.x <= 7 and pos.y+1 >= 0 and pos.y+1 <= 7 and board[pos.x][pos.y+1].team != turn:
				result.append(Vector2i(pos.x, pos.y+1)) 
			if pos.x >= 0 and pos.x <= 7 and pos.y-1 >= 0 and pos.y-1 <= 7 and board[pos.x][pos.y-1].team != turn:
				result.append(Vector2i(pos.x, pos.y-1))
			if pos.x+1 >= 0 and pos.x+1 <= 7 and pos.y+1 >= 0 and pos.y+1 <= 7 and board[pos.x+1][pos.y+1].team != turn:
				result.append(Vector2i(pos.x+1, pos.y+1))
			if pos.x+1 >= 0 and pos.x+1 <= 7 and pos.y-1 >= 0 and pos.y-1 <= 7 and board[pos.x+1][pos.y-1].team != turn:
				result.append(Vector2i(pos.x+1, pos.y-1))
			if pos.x-1 >= 0 and pos.x-1 <= 7 and pos.y-1 >= 0 and pos.y-1 <= 7 and board[pos.x-1][pos.y-1].team != turn:
				result.append(Vector2i(pos.x-1, pos.y-1))
			if pos.x-1 >= 0 and pos.x-1 <= 7 and pos.y+1 >= 0 and pos.y+1 <= 7 and board[pos.x-1][pos.y+1].team != turn:
				result.append(Vector2i(pos.x-1, pos.y+1))
			for x in range(1,5):
				if pos.x+x >= 0 and pos.x+x <= 7 and pos.y >= 0 and pos.y <= 7:
					if board[pos.x+x][pos.y].type != characters.NONE and board[pos.x+x][pos.y].team == turn:
						break
					if board[pos.x+x][pos.y].type != characters.NONE:
						result.append(Vector2i(pos.x+x, pos.y))
						break
			for x in range(1,5):
				if pos.x-x >= 0 and pos.x-x <= 7 and pos.y >= 0 and pos.y <= 7:
					if board[pos.x-x][pos.y].type != characters.NONE and board[pos.x-x][pos.y].team == turn:
						break
					if board[pos.x-x][pos.y].type != characters.NONE:
						result.append(Vector2i(pos.x-x, pos.y))
						break
			for x in range(1,5):
				if pos.x >= 0 and pos.x <= 7 and pos.y+x >= 0 and pos.y+x <= 7:
					if board[pos.x][pos.y+x].type != characters.NONE and board[pos.x][pos.y+x].team == turn:
						break
					if board[pos.x][pos.y+x].type != characters.NONE:
						result.append(Vector2i(pos.x, pos.y+x))
						break
			for x in range(1,5):
				if pos.x >= 0 and pos.x <= 7 and pos.y-x >= 0 and pos.y-x <= 7:
					if board[pos.x][pos.y-x].type != characters.NONE and board[pos.x][pos.y-x].team == turn:
						break
					if board[pos.x][pos.y-x].type != characters.NONE:
						result.append(Vector2i(pos.x, pos.y-x))
						break
			for x in range(1,5):
				if pos.x+x >= 0 and pos.x+x <= 7 and pos.y+x >= 0 and pos.y+x <= 7:
					if board[pos.x+x][pos.y+x].type != characters.NONE and board[pos.x+x][pos.y+x].team == turn:
						break
					if board[pos.x+x][pos.y+x].type != characters.NONE:
						result.append(Vector2i(pos.x+x, pos.y+x))
						break
			for x in range(1,5):
				if pos.x+x >= 0 and pos.x+x <= 7 and pos.y-x >= 0 and pos.y-x <= 7:
					if board[pos.x+x][pos.y-x].type != characters.NONE and board[pos.x+x][pos.y-x].team == turn:
						break
					if board[pos.x+x][pos.y-x].type != characters.NONE:
						result.append(Vector2i(pos.x+x, pos.y-x))
						break
			for x in range(1,5):
				if pos.x-x >= 0 and pos.x-x <= 7 and pos.y-x >= 0 and pos.y-x <= 7:
					if board[pos.x-x][pos.y-x].type != characters.NONE and board[pos.x-x][pos.y-x].team == turn:
						break
					if board[pos.x-x][pos.y-x].type != characters.NONE:
						result.append(Vector2i(pos.x-x, pos.y-x))
						break
			for x in range(1,5):
				if pos.x-x >= 0 and pos.x-x <= 7 and pos.y+x >= 0 and pos.y+x <= 7:
					if board[pos.x-x][pos.y+x].type != characters.NONE and board[pos.x-x][pos.y+x].team == turn:
						break
					if board[pos.x-x][pos.y+x].type != characters.NONE:
						result.append(Vector2i(pos.x-x, pos.y+x))
						break
		characters.DRAGON:
			for x in range(1,8):
				if pos.x+x >= 0 and pos.x+x <= 7 and pos.y >= 0 and pos.y <= 7:
					if board[pos.x+x][pos.y].type != characters.NONE and board[pos.x+x][pos.y].team == turn:
						break
					result.append(Vector2i(pos.x+x, pos.y))
					if board[pos.x+x][pos.y].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x-x >= 0 and pos.x-x <= 7 and pos.y >= 0 and pos.y <= 7:
					if board[pos.x-x][pos.y].type != characters.NONE and board[pos.x-x][pos.y].team == turn:
						break
					result.append(Vector2i(pos.x-x, pos.y))
					if board[pos.x-x][pos.y].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x >= 0 and pos.x <= 7 and pos.y+x >= 0 and pos.y+x <= 7:
					if board[pos.x][pos.y+x].type != characters.NONE and board[pos.x][pos.y+x].team == turn:
						break
					result.append(Vector2i(pos.x, pos.y+x))
					if board[pos.x][pos.y+x].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x >= 0 and pos.x <= 7 and pos.y-x >= 0 and pos.y-x <= 7:
					if board[pos.x][pos.y-x].type != characters.NONE and board[pos.x][pos.y-x].team == turn:
						break
					result.append(Vector2i(pos.x, pos.y-x))
					if board[pos.x][pos.y-x].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x+x >= 0 and pos.x+x <= 7 and pos.y+x >= 0 and pos.y+x <= 7:
					if board[pos.x+x][pos.y+x].type != characters.NONE and board[pos.x+x][pos.y+x].team == turn:
						break
					result.append(Vector2i(pos.x+x, pos.y+x))
					if board[pos.x+x][pos.y+x].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x+x >= 0 and pos.x+x <= 7 and pos.y-x >= 0 and pos.y-x <= 7:
					if board[pos.x+x][pos.y-x].type != characters.NONE and board[pos.x+x][pos.y-x].team == turn:
						break
					result.append(Vector2i(pos.x+x, pos.y-x))
					if board[pos.x+x][pos.y-x].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x-x >= 0 and pos.x-x <= 7 and pos.y-x >= 0 and pos.y-x <= 7:
					if board[pos.x-x][pos.y-x].type != characters.NONE and board[pos.x-x][pos.y-x].team == turn:
						break
					result.append(Vector2i(pos.x-x, pos.y-x))
					if board[pos.x-x][pos.y-x].type != characters.NONE:
						break
			for x in range(1,8):
				if pos.x-x >= 0 and pos.x-x <= 7 and pos.y+x >= 0 and pos.y+x <= 7:
					if board[pos.x-x][pos.y+x].type != characters.NONE and board[pos.x-x][pos.y+x].team == turn:
						break
					result.append(Vector2i(pos.x-x, pos.y+x))
					if board[pos.x-x][pos.y+x].type != characters.NONE:
						break
			if pos.x+2 >= 0 and pos.x+2 <= 7 and pos.y+1 >= 0 and pos.y+1 <= 7 and board[pos.x+2][pos.y+1].team != turn:
				result.append(Vector2i(pos.x+2, pos.y+1))
			if pos.x+1 >= 0 and pos.x+1 <= 7 and pos.y+2 >= 0 and pos.y+2 <= 7 and board[pos.x+1][pos.y+2].team != turn:
				result.append(Vector2i(pos.x+1, pos.y+2))
			if pos.x-2 >= 0 and pos.x-2 <= 7 and pos.y-1 >= 0 and pos.y-1 <= 7 and board[pos.x-2][pos.y-1].team != turn:
				result.append(Vector2i(pos.x-2, pos.y-1))
			if pos.x-1 >= 0 and pos.x-1 <= 7 and pos.y-2 >= 0 and pos.y-2 <= 7 and board[pos.x-1][pos.y-2].team != turn:
				result.append(Vector2i(pos.x-1, pos.y-2))
			if pos.x+1 >= 0 and pos.x+1 <= 7 and pos.y-2 >= 0 and pos.y-2 <= 7 and board[pos.x+1][pos.y-2].team != turn:
				result.append(Vector2i(pos.x+1, pos.y-2))
			if pos.x-1 >= 0 and pos.x-1 <= 7 and pos.y+2 >= 0 and pos.y+2 <= 7 and board[pos.x-1][pos.y+2].team != turn:
				result.append(Vector2i(pos.x-1, pos.y+2))
			if pos.x+2 >= 0 and pos.x+2 <= 7 and pos.y-1 >= 0 and pos.y-1 <= 7 and board[pos.x+2][pos.y-1].team != turn:
				result.append(Vector2i(pos.x+2, pos.y-1))
			if pos.x-2 >= 0 and pos.x-2 <= 7 and pos.y+1 >= 0 and pos.y+1 <= 7 and board[pos.x-2][pos.y+1].team != turn:
				result.append(Vector2i(pos.x-2, pos.y+1))
	return result

func gameover():
	status = true
	get_parent().get_child(4).text = "GAME OVER!\nPLAYER NUMBER " + str(turn) + "\nHAS WON"

func _on_revive_pressed():
	if turn == 1 and mana_1 >= 20 and !status:
		var king_pos = Vector2i(-1,-1)
		for x in range(8):
			for y in range(8):
				if board[x][y].team == 1 and board[x][y].type == characters.KING:
					king_pos = Vector2i(x, y)
		if king_pos.x >= 0 and king_pos.x <= 7 and king_pos.y+1 >= 0 and king_pos.y+1 <= 7 and board[king_pos.x][king_pos.y+1].type == characters.NONE:
			board[king_pos.x][king_pos.y+1].type = characters.SKELETON
			board[king_pos.x][king_pos.y+1].team = 1
		if king_pos.x+1 >= 0 and king_pos.x+1 <= 7 and king_pos.y >= 0 and king_pos.y <= 7 and board[king_pos.x+1][king_pos.y].type == characters.NONE:
			board[king_pos.x+1][king_pos.y].type = characters.SKELETON
			board[king_pos.x+1][king_pos.y].team = 1
		if king_pos.x >= 0 and king_pos.x <= 7 and king_pos.y-1 >= 0 and king_pos.y-1 <= 7 and board[king_pos.x][king_pos.y-1].type == characters.NONE:
			board[king_pos.x][king_pos.y-1].type = characters.SKELETON
			board[king_pos.x][king_pos.y-1].team = 1
		if king_pos.x-1 >= 0 and king_pos.x-1 <= 7 and king_pos.y >= 0 and king_pos.y <= 7 and board[king_pos.x-1][king_pos.y].type == characters.NONE:
			board[king_pos.x-1][king_pos.y].type = characters.SKELETON
			board[king_pos.x-1][king_pos.y].team = 1
		turn = 2
		mana_1-=20
	elif mana_2 >= 20 and !status:
		var king_pos = Vector2i(-1,-1)
		for x in range(8):
			for y in range(8):
				if board[x][y].team == 2 and board[x][y].type == characters.KING:
					king_pos = Vector2i(x, y)
		if king_pos.x >= 0 and king_pos.x <= 7 and king_pos.y+1 >= 0 and king_pos.y+1 <= 7 and board[king_pos.x][king_pos.y+1].type == characters.NONE:
			board[king_pos.x][king_pos.y+1].type = characters.SKELETON
			board[king_pos.x][king_pos.y+1].team = 2
		if king_pos.x+1 >= 0 and king_pos.x+1 <= 7 and king_pos.y >= 0 and king_pos.y <= 7 and board[king_pos.x+1][king_pos.y].type == characters.NONE:
			board[king_pos.x+1][king_pos.y].type = characters.SKELETON
			board[king_pos.x+1][king_pos.y].team = 2
		if king_pos.x >= 0 and king_pos.x <= 7 and king_pos.y-1 >= 0 and king_pos.y-1 <= 7 and board[king_pos.x][king_pos.y-1].type == characters.NONE:
			board[king_pos.x][king_pos.y-1].type = characters.SKELETON
			board[king_pos.x][king_pos.y-1].team = 2
		if king_pos.x-1 >= 0 and king_pos.x-1 <= 7 and king_pos.y >= 0 and king_pos.y <= 7 and board[king_pos.x-1][king_pos.y].type == characters.NONE:
			board[king_pos.x-1][king_pos.y].type = characters.SKELETON
			board[king_pos.x-1][king_pos.y].team = 2
		turn = 1
		mana_2-=20
	update_board()


func _on_fireball_pressed():
	if !state_button:
		if turn == 1 and mana_1 >= 30 and !status:
			state_button = true
			fireball = true
		elif mana_2 >= 30 and !status:
			state_button = true
			fireball = true
	else:
		state_button = false
		fireball = false
	update_board()


func _on_extra_pressed():
	if !extra:
		if turn == 1 and mana_1 >= 60 and !status:
			extra = true
			mana_1 -= 60
		elif mana_2 >= 60 and !status:
			extra = true
			mana_2 -= 60
	else:
		extra = false
	update_board()
