
// Project: Pong 
// Created: 2017-11-14

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "Pong" )
SetWindowSize( 640, 480, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 640,480) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts


// **** Create Sprites

// Player 1 Sprite
CreateImageColor(1, 255, 255, 255, 255)
CreateSprite(1, 1)
SetSpriteSize( 1, 15, 100)
SetSpritePosition( 1, 10, 10)

playery = GetVirtualHeight()/2 - GetSpriteHeight(1)/2
playerx = GetVirtualWidth()/2 - GetSpriteWidth(1)/2

// Player 2 Sprite
CreateImageColor(2, 255, 255, 255, 255)
CreateSprite(2, 1)
SetSpriteSize( 2, 15, 100)
SetSpritePosition( 2, 615, 10)

playery2 = GetVirtualHeight()/2 - GetSpriteHeight(2)/2
playerx2 = GetVirtualWidth()/2 - GetSpriteWidth(2)/2

// Ball Sprite

CreateImageColor(3, 255, 255, 255, 255)
CreateSprite(3, 1)
SetSpriteSize( 3, 30, 30)
SetSpritePosition(3, GetVirtualWidth()/2- GetSpriteWidth(3)/2, GetVirtualHeight()/2 -GetSpriteHeight(3)/2)


// Background Sprite
CreateImageColor(4, 0, 107, 0, 107)
CreateSprite(4, 4)
SetSpriteSize(4, GetVirtualWidth(), GetVirtualHeight())

// Net sprite

CreateImageColor(5, 255, 255, 255, 255)
CreateSprite(5, 5)
SetSpritePosition(5, GetVirtualWidth()/2 - GetSpriteWidth(5)/2,0)
SetSpriteSize(5, 5, GetVirtualHeight())
SetSpriteVisible(5, 0)

// Text Sprites for Start Screen

CreateText(1, "Welcome To PONG") 
SetTextSize(1, 70)
SetTextPosition(1, GetVirtualWidth()/2 - GetTextTotalWidth(1)/2, GetVirtualHeight()/2 - GetTextTotalHeight(1)/2 )

CreateText(2, " This is a two player game, please find a friend. " )
SetTextSize(2, 20)
SetTextPosition(2, 150, 280)

CreateText(3, " Instructions: Defend the ball from getting to the East and West walls. Player 1: Up,Down arrow keys. Player 2: WS keys. " )
SetTextSize(3, 15)
SetTextPosition(3, 2, 450) 

// Text Sprites for Game Over Screen
CreateText(4, " GAME OVER")
SetTextSize(4, 70)
SetTextPosition(4, GetVirtualWidth()/2 - GetTextTotalWidth(4)/2, GetVirtualHeight()/2 - GetTextTotalHeight(4)/2 )
SetTextVisible(4, 0)

CreateText(5, " Player 1 WINS")
SetTextSize(5, 60)
SetTextPosition(5, 170, 280)
SetTextVisible(5, 0)

CreateText(6, " Player 2 WINS")
SetTextSize(6, 60)
SetTextPosition(6, 170, 280)
SetTextVisible(6, 0)

CreateText(7, " Play Again: Y/N")
SetTextSize(7, 40)
SetTextPosition(7, 5, 10)
SetTextVisible(7, 0)

// P1 and P2 labels
CreateText(8, " P1")
SetTextSize(8, 20)
SetTextPosition(8, 615, 10)
SetTextVisible(8, 0)

CreateText(9, " P2")
SetTextSize(9, 20)
SetTextPosition(9, 10, 10)
SetTextVisible(9, 0)



// **** Variables

// Ball Movement
BallDirX = 1
BallDirY = 1

// StartScreen
start = 1

// Game Over Screen
Gameover = 0

// Speed
speed = 5


// Timer
count = 1

// Score
score = 0


do
	
	Gosub StartScreen
	Gosub Player1_moves
	Gosub Player2_moves
	Gosub Ballmoves
	Gosub BallCollision
	Gosub Gameover
	Gosub speedup

	
    Sync()
loop
    
// **** Subroutines

Player1_moves:


if GetRawKeyState(87) = 1 // W key
	playery = playery - 10
	if playery > GetVirtualHeight() - GetSpriteHeight(1)
		playery = GetVirtualHeight() - GetSpriteHeight(1)
	endif
	if playerx < 0
		playerx = 0
	endif
endif

if GetRawKeyState(83) = 1 // S Key
	playery = playery + 8
	if playery > GetVirtualHeight() - GetSpriteHeight(1)
		playery = GetVirtualHeight() - GetSpriteHeight(1)
	endif
	
endif
if playery < 0
	playery = 0
	
endif

SetSpritePosition(1, 10, playery)

return


Player2_moves:


if GetRawKeyState(38) = 1 //Up arrow key
	playery2 = playery2 - 10
	if playery2 > GetVirtualHeight() - GetSpriteHeight(2)
		playery2 = GetVirtualHeight() - GetSpriteHeight(2)
	endif
endif
if GetRawKeyState(40) = 1 // Down arrow key
	playery2 = playery2 + 10
	if playery2 > GetVirtualHeight() - GetSpriteHeight(2)
		playery2 = GetVirtualHeight() - GetSpriteHeight(2)
	endif
endif
if playery2 < 0
	playery2 = 0
endif

SetSpritePosition(2, 615, playery2)

return


Ballmoves:

ballx = ballx + BallDirX * speed
if ballx > GetVirtualWidth() - GetSpriteWidth(3)
	gameover = 1
endif
if ballx < 0
	gameover = 1
endif

bally = bally + BallDirY * speed
if bally > GetVirtualHeight() - GetSpriteHeight(3)
	bally = GetVirtualHeight() - GetSpriteHeight(3)
	ballDirY = -1
endif

if bally < 0
	ballDirY = 1
endif

SetSpritePosition(3, ballx, bally)

return

BallCollision:
if GetSpriteCollision(1, 3) = 1
	ballDirX = 1
endif
if GetSpriteCollision(2, 3) = 1
	ballDirX = -1
endif

return


StartScreen:
while start = 1	
	
	Print( " Press ENTER to start" )
	Print( " Press ESC to exit")

	// Setting Text Sprites visible 
	SetTextVisible(1, 1)
	SetTextVisible(2, 1)
	SetTextVisible(3, 1)

	// Setting Sprites Invisible
	SetSpriteVisible(1, 0)
	SetSpriteVisible(2, 0)
	SetSpriteVisible(3, 0)

	// Enter Key
	if GetRawKeyPressed(13) = 1
		start = 0
		setspritevisible(5, 1)
		// P1 and P2 labels
		SetTextVisible(8, 1)
		SetTextVisible(9, 1)  
		
		// Setting Text Sprites Invisible
		SetTextVisible(1, 0)
		SetTextVisible(2, 0)
		SetTextVisible(3, 0)
		
		// Setting Sprites Visible
		SetSpriteVisible(1, 1)
		SetSpriteVisible(2, 1)
		SetSpriteVisible(3, 1)
		start = 0
	endif

	// Esc Key
	if GetRawKeyPressed(27) = 1
		end
	endif
	sync()
endwhile


return

Gameover:

while gameover = 1

	// Setting game over sprites visible, P1 and P2 labels not visible, paddles remain visible,net not visible, ball not visible
	SetTextVisible(8, 0)
	SetTextVisible(9, 0)
	SetTextVisible(4, 1)
	SetSpriteVisible(3, 0)
	SetSpriteVisible(5, 0)
	
	// Player 2 Wins
	if ballx > GetVirtualWidth() - GetSpriteWidth(3)
		SetTextVisible(6, 1) 
	endif
	
	// Player 1 wins
	if ballx < 0
		SetTextVisible(5, 1)  
	endif

	SetTextVisible(7, 1)
	
	// Key Functions
	
	if GetRawKeyPressed(78) = 1 // N key - Exit
		end
	endif
	
	if GetRawKeyPressed(89) = 1 // Y key - Play Again
		do
			gameover = 0
			speed = 5
			playery = GetVirtualHeight()/2 - GetSpriteHeight(1)/2
			playery2 = GetVirtualHeight()/2 - GetSpriteHeight(2)/2
			ballx= GetVirtualWidth() - GetSpriteWidth(3)
			bally = GetVirtualHeight()/2 
			SetSpriteVisible(5, 1)
			
			exit
			
			
			Sync()
		loop
		
		//  Set Game Over Sprites Invisible, ball sprite visible, P1 and P2 labels visible
		SetTextVisible(4, 0)
		SetTextVisible(5, 0)
		SetTextVisible(6, 0)
		SetTextVisible(7, 0)
		SetTextVisible(8, 1)
		SetTextVisible(9, 1)
		SetSpriteVisible(3, 1)
		
	endif
	sync()
endwhile
	
return

Speedup:
if mod(GetSeconds(), 10) = 9
	if count = 1
		speed = speed + 2
		count = 0
	endif
endif
if mod(GetSeconds(), 10) = 0
	count = 1
endif

return



