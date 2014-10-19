local storyboard = require( "storyboard" )

local scene = storyboard.newScene()
local width = display.contentWidth
local height = display.contentHeight
local backg

function scene:createScene( event )
	local group = self.view
	backg = display.newImage ("godofwar.png", width/2, height/2)
	backg.alpha = .5
	local msg = display.newText ("Final Score: " .. event.params.curScoree, width/2, height*.95, font, 20)
 	msg:setFillColor( 1, 0, 1 )
	local gameDone = display.newImage("game over.png", width/2, height/2)
	group:insert(gameDone)
	group:insert(msg)
	group:insert(backg)
end

scene:addEventListener ( "createScene", scene)
return scene