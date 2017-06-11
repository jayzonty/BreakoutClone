extends Node2D

# Keep track of number of balls in
# the field
var numBallsInField

# External variable for setting
# number of levels
export var numLevels = 3

# Keeps track of blocks remaining in the current level
var blocksRemaining setget setBlocksRemaining

# Keeps track of the player's score
var score setget setScore

# External variable for setting
# initial lives of player
export var initialLives = 3

# Keeps track of the player's lives
var lives setget setLives

# Keeps track of current level
var levelIndex

# Cache variable for current level node
var levelNode

# Variable for keeping track whether player
# has already won
var isWin

func _ready():
	# Initialize score, lives, levelIndex, and win variable
	score = 0
	lives = initialLives
	levelIndex = 1
	isWin = false
	
	numBallsInField = 0
	
	# Update labels for score and lives
	updateScoreLabel()
	updateLivesLabel()
	
	# Update game over label
	updateGameOverLabel()
	
	# Hide win label
	get_node( "WinLabel" ).hide()
	
	# Load level based on levelIndex
	loadLevel( levelIndex )

# This function is called whenever we
# change the score variable.
func setScore( newVal ):
	score = newVal
	
	updateScoreLabel()

# This function is called whenever we
# change the lives variable.
func setLives( newVal ):
	lives = newVal
	
	updateLivesLabel()
	
	# If player has exhausted all lives,
	# Game Over!
	if ( lives == 0 ):
		updateGameOverLabel()

func setBlocksRemaining( newVal ):
	blocksRemaining = newVal
	
	if( blocksRemaining <= 0 ):
		handleLevelFinished()

# Updates score label based on the current
# value of score.
func updateScoreLabel():
	get_node( "ScoreLabel" ).set_text( "Score: " + str( score ) )

# Updates lives label based on the current
# value of lives.
func updateLivesLabel():
	get_node( "LivesLabel" ).set_text( "Lives: " + str( lives ) )
	
func updateGameOverLabel():
	var gameOverLabel = get_node( "GameOverLabel" )
	if ( lives > 0 ):
		gameOverLabel.hide()
	else:
		gameOverLabel.show()

func isGameOver():
	return ( lives == 0 ) || isWin

func loadLevel( index ):
	# Destroy current level
	if( levelNode != null ):
		levelNode.queue_free()
	
	# Load next level
	levelNode = load( "res://Subscenes/Level" + str( index ) + ".tscn" ).instance()
	
	add_child( levelNode )
	
	# Update level index
	levelIndex = index
	
	# Update blocks remaining
	blocksRemaining = levelNode.get_child_count()
	
	# Reset balls in field
	numBallsInField = 0

func handleLevelFinished():
	get_node( "Ball" ).queue_free()
	
	if ( levelIndex == numLevels ):
		get_node( "WinLabel" ).show()
		
		isWin = true
	else:
		loadLevel( levelIndex + 1 )