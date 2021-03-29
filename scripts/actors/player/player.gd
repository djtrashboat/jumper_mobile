extends "res://scripts/actors/Actor.gd"


var global_position_i: Vector2#guarda a posicao do clique do mouse
var global_position_f: Vector2#guarda a posicao de quando solta o mouse
var finger_position: Vector2

var mousehold:bool = false
var enable_mov: bool #se true o player pode comandar o personagem

#*******************************************

#*******************************************
func _physics_process(delta: float) -> void:
	move_and_slide(_velocity * _speed, FLOOR_NORMAL)#vrummmm
	_velocity.y += gravity * delta#aplicando a gravidade
	if is_on_ceiling():
		_velocity.y *= -0.3 #max(_velocity.y, -_velocity.y) * 0.3#se o player estiver no teto ele ganha velocidade em y para cair e nao grudar la
	elif is_on_floor():
		_velocity.x = 0
		enable_mov = true
	elif is_on_wall():#bounce bounce (on walls)
		_velocity.x *= -0.3#coeficiente de bounce
		enable_mov = true#quando o player bate na parede, ele ganha o comando de volta
	

#*******************************************

#**********************************


func _input(event):
		if enable_mov:
			if event is InputEventScreenTouch:
				if event.pressed:
					_on_touch_pressed(event)
				else:
					_on_touch_released(event)

func _on_touch_pressed(event):
	global_position_i = event.position
	mousehold = true

func _on_touch_released(event):
	global_position_f = event.position
	if enable_mov:
		_velocity = calculate_impulse(global_position_i, global_position_f)
		mousehold = false
		enable_mov = false
#**********************************

func _process(delta: float) -> void:
	_update()

func _update():
	if !mousehold:#se o player nao esta segurando o botao do mouse
		play_animation(_velocity)#a animacao toca de acordo com a velocidade do player
	else:#se o player esta segurando o botao do mouse
		$AnimatedSprite.play("populo")#a animacao populo toca

#toca animacao
func play_animation(velocity: Vector2) -> void:
	#player *****************
	if is_on_floor():# and (velocity.x< (0.1) or velocity.x> (-0.1)):# ***o player detecta o chao como parede***, #sem a segudanda parte ele ficava girando o sprite sem parar
		$AnimatedSprite.play("idle")
	elif velocity.y > 0.0:
		if velocity.x == 0.0:
			$AnimatedSprite.flip_h = false
			if enable_mov:#se true, toca a animacao com outline
				$AnimatedSprite.play("fall_1")
			else: $AnimatedSprite.play("fall_0")#se false, toca a animacao sem outline
		elif velocity.x < 0.0:
			$AnimatedSprite.flip_h = true
			if enable_mov:#se true, toca a animacao com outline
				$AnimatedSprite.play("fall_1")
			else: $AnimatedSprite.play("fall_0")#se false, toca a animacao sem outline
		elif velocity.x > 0.0:
			$AnimatedSprite.flip_h = false
			if enable_mov:#se true, toca a animacao com outline
				$AnimatedSprite.play("fall_1")
			else: $AnimatedSprite.play("fall_0")#se false, toca a animacao sem outline
	elif velocity.y < 0.0:
		if velocity.x > 0.0:
			$AnimatedSprite.flip_h = false
			if enable_mov:
				$AnimatedSprite.play("jump_1")
			else: $AnimatedSprite.play("jump_0")
		elif velocity.x < 0.0:
			$AnimatedSprite.flip_h = true
			if enable_mov:
				$AnimatedSprite.play("jump_1")
			else: $AnimatedSprite.play("jump_0")
		else:
			if enable_mov:
				$AnimatedSprite.play("jump_1")
			else: $AnimatedSprite.play("jump_0")
