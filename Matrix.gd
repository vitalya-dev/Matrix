extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var font = load('res://PressStart2P-vaV7.tres')
onready var columns = int(rect_size.x / font.size)
onready var rows = int(rect_size.y / font.size)

var streamers = []
var max_streamers = 50

class Streamer:
	var column = 0
	var position = 0
	var speed = 0
	var text = ""
	
	func _init(c, p, s, t):
		column = c
		position = p
		speed = s
		text = t

	func draw(c):
		var x = column * c.font.size
		for i in range(len(text)):
			var y = (position + i + 1) * c.font.size
			var col = Color.green
			if speed < 15:
				col = Color.darkgreen
			if i == 0:
				col = Color.white
			if i > 0 and i <= 3:
				col = Color.silver 
			c.draw_char(c.font, Vector2(x, y), text[int(position - i) % len(text)], "", col)	

	static func sort(a, b):
		if a.speed < b.speed:
			return true
		return false


func _random_text():
	var r_text = ""
	var r_length = randi() % 60 + 10 
	for i in range(r_length):
		r_text += char(randi() % (0x3ce - 0x3a3) + 0x3a3)
	return r_text

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(max_streamers):
		var text = _random_text()
		streamers.append(Streamer.new(randi() % columns, -len(text), randi() % 20 + 5, text))
	streamers.sort_custom(Streamer, "sort")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for s in streamers:
		s.position += s.speed * delta
		if s.position >= rows:
			s.text = _random_text()
			s.column = randi() % columns 
			s.position = -len(s.text)
			s.speed = randi() % 20 + 5
	streamers.sort_custom(Streamer, "sort")		
	update()	

func _draw():
	for s in streamers:
		s.draw(self)


func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		get_tree().quit()

