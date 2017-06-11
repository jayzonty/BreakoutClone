extends KinematicBody2D

const ballScene = preload( "res://Subscenes/Ball.tscn" )

func _ready():
	# Enable _fixed_process() callback
	set_fixed_process( true )
	
	# Enable process_input() callback
	set_process_input( true )

func _fixed_process(delta):
	var y = get_pos().y
	var mouseX = get_viewport().get_mouse_pos().x
	
	set_pos( Vector2( mouseX, y ) )

func _input(event):
	if ( event.type == InputEvent.MOUSE_BUTTON ) && ( event.is_pressed() ):
		var worldNode = get_node( "/root/World" )
		if ( !worldNode.isGameOver() && ( worldNode.numBallsInField == 0 ) ):
			var ball = ballScene.instance()
			ball.set_pos( get_pos() - Vector2( 0, 16 ) )
		
			worldNode.add_child( ball )
			
			worldNode.numBallsInField += 1