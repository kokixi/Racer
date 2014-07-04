local composer = require( "composer" )

local sceneRace = composer.newScene()

local physics = require "physics"
physics.start( )
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local car
local runButton
local cwButton
local ccwButton
local DEBUG = true



---------------------------------

local function nextScene(event)

    if event.phase == "ended" then

    end

end

local function reappearIfOutBoundaries()
    if car.x > display.contentWidth then
        car.x = 0
    elseif car.x < 0 then
        car.x = display.contentWidth
    end
    if car.y > display.contentHeight then
        car.y = 0
    elseif car.y < 0 then
        car.y = display.contentHeight
    end
end

local function moving( event )

    if car.accelerating == true then
        car:setLinearVelocity( car.speed * math.cos(math.rad(car.rotation)), car.speed * math.sin(math.rad(car.rotation)) )
        car.speed = car.speed + 10  
    else
        if car.speed > 0 then
            car.speed = car.speed - 10
            car:setLinearVelocity( car.speed * math.cos(math.rad(car.rotation)), car.speed * math.sin(math.rad(car.rotation)) )
        end
    end

    if car.rotating == 1 then
        car.rotation = (car.rotation - 1)%360
    elseif car.rotating == 2 then
        car.rotation = (car.rotation + 1)%360
    end

    
    reappearIfOutBoundaries()
end

local function accelerate(event)
    if event.phase == "began" then
        car.accelerating = true
    end 
            
    if event.phase == "ended" then 
        car.accelerating = false
    end
end

local function rotateCW(event)
    if event.phase == "began" then
        car.rotating = 1
    end 
            
    if event.phase == "ended" then 
        car.rotating = 0
    end
end

local function rotateCCW(event)
    if event.phase == "began" then
        car.rotating = 2
    end 
            
    if event.phase == "ended" then 
        car.rotating = 0
    end
end

-- "scene:create()"
function sceneRace:create( event )

    car = display.newRect(0,0,40,20)
    car.x = display.contentWidth * 0.5
    car.y = display.contentHeight * 0.5
    car.speed = 0
    car.accelerating = false
    car.rotating = 0
    car.orientation = 0
    car:setFillColor(255,255,255)

    physics.addBody( car, "kinematic" )

    runButton = display.newRect(0,0,display.contentWidth *0.5, display.contentHeight)
    cwButton = display.newRect(0,0,display.contentWidth *0.5, display.contentHeight * 0.5)
    ccwButton = display.newRect(0,0,display.contentWidth *0.5, display.contentHeight * 0.5)

    runButton.x = display.contentWidth * 0.25
    runButton.y = display.contentHeight * 0.5

    cwButton.x = display.contentWidth * 0.75
    cwButton.y = display.contentHeight * 0.25
    ccwButton.x = display.contentWidth * 0.75
    ccwButton.y = display.contentHeight * 0.75

    if DEBUG == true then
        runButton:setFillColor(255,0,0)
        runButton.alpha = 0.2

        cwButton:setFillColor( 0,255,0 )
        cwButton.alpha = 0.2

        ccwButton:setFillColor( 0,0,255 )
        ccwButton.alpha = 0.2
    end

    runButton:addEventListener( "touch", accelerate )
    cwButton:addEventListener( "touch", rotateCW )
    ccwButton:addEventListener( "touch", rotateCCW )

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function sceneRace:show( event )

    local sceneGroup = self.view
    local phase = event.phase



    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        Runtime:addEventListener( "enterFrame", moving )
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.

    end

end


-- "scene:hide()"
function sceneRace:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
        

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function sceneRace:destroy( event )
    local sceneGroup = self.view


    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
sceneRace:addEventListener( "create", sceneRace )
sceneRace:addEventListener( "show", sceneRace )
sceneRace:addEventListener( "hide", sceneRace )
sceneRace:addEventListener( "destroy", sceneRace )

-- -------------------------------------------------------------------------------

return sceneRace