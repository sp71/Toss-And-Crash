local storyboard = require( "storyboard" )
fsm = require("fsm")
local scene = storyboard.newScene()
local width = display.contentWidth
local height = display.contentHeight
local group, bg, level, pillar2, pig, pig2, ground, bird, msg, msg2, tapMsg, scoreMsg, bamboo, gold
local curLevel = 2
local numThrows = 0
local score = 0
local birdHomex
local sound2 = audio.loadSound("pop.wav")
local maxTap = 1 -- this bird can only have user tap once
local numTaps = 0
local numPig = 1
local options = 
{
    effect = "zoomOutInRotate",
    time = 400
}
local sheets = {
 		{sheet = graphics.newImageSheet( "bar1.png", { width=60, height=20, numFrames=1})},
 		{sheet = graphics.newImageSheet( "bar2.png", { width=60, height=20, numFrames=1})},
 		{sheet = graphics.newImageSheet( "bar3.png", { width=60, height=20, numFrames=1})}
 	}
local sequenceData = {
        { name="seq1", sheet=sheets[1].sheet, start=1, count=1, time=1, loopCount=0 },
        { name="seq2", sheet=sheets[2].sheet, start=1, count=1, time=1, loopCount=0 },
        { name="seq3", sheet=sheets[3].sheet, start=1, count=1, time=1, loopCount=0 }
    }

local pigSheets = {
	{sheet = graphics.newImageSheet( "pig_happy.png", { width=60, height=45, numFrames=1})},
 	{sheet = graphics.newImageSheet( "pig_sad.png", { width=60, height=45, numFrames=1})}
}

local pigSequenceData = {
	  { name="seq1", sheet=pigSheets[1].sheet, start=1, count=1, time=1, loopCount=0 },
      { name="seq2", sheet=pigSheets[2].sheet, start=1, count=1, time=1, loopCount=0 }
}

local boomSheet = graphics.newImageSheet("boom.png", { width = 134, height = 134, numFrames = 12 })
local boomSequenceData = { name = "explosion", start = 1, count = 10, time = 300, loopCount = 1, loopDirection = "forward" }
local boomEvent2 = display.newSprite(boomSheet, boomSequenceData)

local physics = require("physics")
physics.start()

happyState = {}
baconState = {}
pigEntires = {}

--physics.setDrawMode ("hybrid")
function scene:createScene( event )  ----------------------------------- MAIN CODE -----------------------------------
 	score = event.params.curScoree
 	group = self.view
 	printScreen()
 	displayObjects() 

 	physicsAdding()
 	insertGroup()
 	local function beginListener (event)
 		if (event.phase == "began") then
 			 audio.dispose(sound2)
			storyboard.gotoScene("lev3", { effect = "flipFadeOutIn", time = 400, params = {curScoree = score}})
 		end
 		return true
 	end
 	nextLevel:addEventListener ("touch", beginListener)
 	 --   local pigGroup01 = display.newGroup ()
end ---------------------------------------------   MAIN CODE COMPLETEE --------------------------------------------- 

function displayObjects()
	bg = display.newImage ("green.png", width/2, height/2)
 	bg.alpha = .5
 	gold = display.newImage("gold.png", width*.70, height*.7)
 	gold.name = "gold"
 	pillar2 = display.newImage("Pillar.png", width*.90, height*.70)
 	pig = baconMaker(width*.90, height*.50, height*.9)  
 	pig2 = baconMaker(width*.70, height*.40,height*.6)
 	ground = display.newRect(width/2,height*1.02,width*1.5,height*.001)
 	bird =  display.newImage("bird2.png", width*.10, height*.10)
 	birdHomex = bird.x
 	bird.startTime = -1 ---- Start time has not occured yet

 	nextLevel = display.newImage("go-next.png", width*.10, height*.30)
 	nextLevel.alpha = 0
end

function physicsAdding()
 	physics.addBody(pillar2, "static")
 	physics.addBody(gold, {bounce = 0})
 	physics.addBody(pig)
 	physics.addBody(pig2)
 	physics.addBody(ground, "static")
 	physics.addBody(bird, "static", {bounce = 0.5})
end
function printScreen()
 	msg = display.newText ("Pig1: ", width*.10, height*.80, font, 20)
 	msg:setFillColor( 1, 0, 1 )
 	msg2 = display.newText ("Pig2: ", width*.10, height*.50, font, 20)
  	msg2:setFillColor( 1, 0, 1 )
  	level = display.newText ("Level ".. curLevel, width*.90, height*.10, font, 20)
  	tapMsg = display.newText("Taps Left: " .. maxTap - numTaps, width*.10, height*.70, font, 15)
  	tapMsg:setFillColor(1,0,1)
  	tapMsg.alpha = .7
  	scoreMsg = display.newText("Score: " .. score, width*.70, height*.10, font, 20)
end

function insertGroup()
	group:insert (msg)
  	group:insert (msg2)
 	group:insert(ground)
 	group:insert (bg)
 	group:insert (level)
 	group:insert(pillar2)
 	group:insert(pig)
 	group:insert(pig2)
 	group:insert(ground)
 	group:insert(bird)
 	group:insert(pig.myHP)
 	group:insert(pig2.myHP)
 	group:insert(tapMsg)
 	group:insert(scoreMsg)
 	group:insert(boomEvent2) 	
 	group:insert(nextLevel)
 	group:insert(gold)
end

function tap(event)
	if numTaps < maxTap then -- LIMITED TO 1 TAP1 --------
		local X1 = bird.x
		local Y1 = bird.y
		local X2 = event.x
		local Y2 = event.y
		bird.bodyType = "dynamic"
		bird:applyLinearImpulse( (X2-X1)/500, (Y2-Y1)/500, bird.x, bird.y)
		numTaps = numTaps + 1
		bird.startTime = system.getTimer() -------- RECORD TIME -----
	end	
	tapMsg.text = "Taps Left: " .. maxTap - numTaps  --math.max(maxTap - numTaps, 0)
	scoreMsg.text = "Score: " .. score
	nextLevel.alpha = 1
--	curLevel = curLevel + 1
--	level.text = "Level: ".. curLevel
end

function onCollision(event)
	if (event.object2.name == "pig2" or event.object2.name == "pig1") and event.phase == "ended" and bird.x ~= birdHomex then
		audio.play(sound2)
		if event.object1.name == "gold" then
				gold:setFillColor(1,0,0)
		end
		if numThrows == 0 then 
			event.object2:setSequence("seq2")
			event.object2.numHits = 1
			event.object2.myHP:setSequence ("seq2")
			score = score + 1 
--			bird:removeSelf() 
		else 
			event.object2:removeSelf()
			event.object2.myHP:setSequence ("seq3")
			event.object2.numHits = 2
			score = score + 2
		end
		scoreMsg.text = "Score: " .. score
		numThrows = numThrows + 1
		boomEvent2.x = event.object2.x  
		boomEvent2.y = event.object2.y  
	    boomEvent2:play()
	end
end

function baconMaker(x, y, HPY)
	local piggy = display.newSprite(pigSheets[1].sheet, pigSequenceData)
	piggy.homex = x
	piggy.homey = y
	piggy.fsm = fsm.new(piggy)
	piggy.fsm:changeState ( happyState )
	piggy.myHP = display.newSprite (sheets[1].sheet, sequenceData)
	piggy.myHP.x = width*.10
	piggy.myHP.y = HPY
	piggy.name = "pig" .. numPig -- number of pigs
	piggy.numHits = 0 -- # of times it has been hit
	numPig = numPig + 1
	table.insert(pigEntires, piggy)
	return piggy
end

function happyState:enter(owner)
	owner.x = owner.homex
	owner.y = owner.homey
--	display.newRect(width/2, height/2, 50, 50)
end

function happyState:execute(owner)
	--print("Nothing on me\n")
	if owner.numHits == 2 then
		owner.fsm:changeState(baconState)
	end 
end

function happyState:exit(owner)

end

function baconState:enter(owner) -- bacon state means sad state
	print("Now I am sad ") -- only print seems to work. owner.x and owner.y do nothing
		Runtime:removeEventListener( "collision", onCollision )
end

function baconState:execute(owner)
--	print("In sad state executing")
--	if owner.numHits <= 1 then
--		owner:setSequence("seq2")
--	end
end

function baconState:exit(owner)
	Runtime:removeEventListener( "collision", onCollision )
end

-- Calls Execute Method in states!
function update ( event )
	for i=1,#pigEntires do
		pigEntires[i].fsm:update(event)
	end
end

scene:addEventListener( "createScene", scene )
display.currentStage:addEventListener("tap", tap)
Runtime:addEventListener("collision", onCollision)
Runtime:addEventListener("enterFrame", update)

return scene