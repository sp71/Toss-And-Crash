--[[
	Satinder Paul Singh	
	May 8, 2014
--]]
local storyboard = require("storyboard")
storyboard.purgeOnSceneChange = true --erases previous scene 
local options = 
{
    effect = "crossFade",
    time = 600
}
-- Hide status bar
display.setStatusBar(display.HiddenStatusBar)
storyboard.gotoScene("start", options)