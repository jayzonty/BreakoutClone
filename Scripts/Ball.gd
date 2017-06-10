extends RigidBody2D

export var speedUp = 4
export var maxSpeed = 400

func _ready():
	set_fixed_process( true )

func _fixed_process(delta):
	var bodies = get_colliding_bodies()
	
	for body in bodies:
		if body.is_in_group( "Bricks" ):
			var worldNode = get_node( "/root/World" )
			worldNode.score += body.blockValue
			worldNode.blocksRemaining -= 1
			
			body.queue_free()
			
		elif body.get_name() == "Paddle":
			var magnitude = get_linear_velocity().length()
			var direction = ( get_pos() - body.get_node( "Anchor" ).get_global_pos() ).normalized()
			
			var velocity = direction * min( magnitude + speedUp, maxSpeed )
			set_linear_velocity( velocity )
	
	if get_pos().y > get_viewport_rect().end.y:
		# Update number of lives
		get_node( "/root/World" ).lives -= 1
		
		# Remove ball from play
		queue_free()
