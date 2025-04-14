-- Cassian Jones
-- CMPM 121
-- 4/11/25
-- Credits: Vector Script from Zac Emerzian

require "card"
require "grabber"
require "tabletop"

function love.load()
    love.window.setMode(960, 640) -- Creates window and defines size
    love.graphics.setBackgroundColor(0.2, 0.60, 0.2, 1) -- Sets background color of the window

    grabber = GrabberClass:new() -- makes new grabber instance
    tableTop = TableTopClass:new()
    cardTable = {} -- makes a table in which to store cards -- CHANGE LATER

    -- inserts cards into table
    table.insert(cardTable, CardClass:new(275, 350, 1))
    table.insert(cardTable, CardClass:new(350, 350, 2))
end

function love.update()
    grabber:update() -- calls the grabber update function
    
    checkForMouseMoving() -- calls checkForMouseMoving function, which checks if the mouse is on top of any card
    
    tableTop:update()

    for _, card in ipairs(cardTable, card) do -- calls update function for every card
        card:update()
    end

    -- grabber.currCard = grabber.currCard + 1 -- no clue
end

function love.draw()
    tableTop:draw()

    local regFont = love.graphics.newFont(12)
    love.graphics.setFont(regFont)
    love.graphics.setColor(1, 1, 1, 1) -- sets color to white so we can put words in window
    love.graphics.print("Mouse:" .. tostring(grabber.currMousePos.x) .. ", " .. tostring(grabber.currMousePos.y))
    -- ^ displays the mouse x and y coordinates
    love.graphics.print("Current Card:" .. tostring(grabber.currCard), 110, 0)
    -- ^ prints number of the card which is being grabbed

    for _, card in ipairs(cardTable, card) do -- draws every card in the cardTable table
        card:draw()
    end
end

function checkForMouseMoving()
    if grabber.currMousePos == nil then -- no clue
        return
    end

    for _, card in ipairs(cardTable) do -- checks if the mouse is over any card in cardTable
        card:checkMouseOver(grabber)
        
        --[[
        if grabber:grab() then
            card:update()
        end
        ]]
    end
end