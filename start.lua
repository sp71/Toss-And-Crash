--[[
	Satinder Paul Singh	
	May 8, 2014
--]]


local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local width = display.contentWidth
local height = display.contentHeight
local options = 
{
    effect = "zoomOutInRotate",
    time = 400
}

function scene:createScene( event )
    local group = self.view
    local bg = display.newImage("gotham.png", width/2, height/2)
    bg:scale(.3,.3)
    local begin = display.newImage("begin.png", width/2, height/2)
    begin:scale(.5,.5)
    begin.alpha = 0.80
  	group:insert(bg)   
  	group:insert(begin) 
  	local msg = display.newText ("Toss Game by Satinder Singh", width/2, height*.20, font, 28)
  	group:insert (msg)

  	local function beginListener (event)
 		if (event.phase == "began") then
 			storyboard.gotoScene ("lev1", options)
 		end
 		return true
 	end
 	begin:addEventListener ("touch", beginListener)
end

function scene:exitScene( event )
	Runtime:removeEventListener("enterFrame", self.onUpdate)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene)
return scene