-- Cassian Jones
-- CMPM 121
-- 4/11/25
-- Credits: Vector Script from Zac Emerzian

require "card"
require "grabber"
require "tabletop"
local cardFlippedThisClick = false

function love.load()
    love.window.setMode(960, 640) -- Creates window and defines size
    love.window.setTitle("Cassian Jones's Solitaire")
    love.graphics.setBackgroundColor(0.2, 0.60, 0.2, 1) -- Sets background color of the window

    width = 50
    height = 70

    grabber = GrabberClass:new() -- makes new grabber instance
    stackTable = {}
    tableTop = TableTopClass:new(stackTable)
    cardTable = {} -- makes a table in which to store cards -- CHANGE LATER

    -- inserts cards into table
    -- table.insert(cardTable, CardClass:new(275, 350, 1))
    -- table.insert(cardTable, CardClass:new(350, 350, 2))
    instantiateCards()
end

function love.update()
    require("lovebird").update()
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

    for _, stack in ipairs(stackTable, stack) do
        stack:draw()
    end
end

function checkForMouseMoving()
    if grabber.currMousePos == nil then
        return
    end

    for i = #cardTable, 1, -1 do    
        local card = cardTable[i]
        local cardGrabbed = card:checkMouseOver(grabber)
        if cardGrabbed then 
            table.remove(cardTable, i)
            table.insert(cardTable, card)
            break
        end
    end
end

function instantiateCards()
    suit = nil
    num = nil
    for i = 1, 4 do
        if i == 1 then
            suit = "club"
        end
        if i == 2 then
            suit = "heart"
        end
        if i == 3 then
            suit = "spade"
        end
        if i == 4 then
            suit = "diamond"
        end
        for j = 1, 13 do
            num = j
            table.insert(cardTable, CardClass:new(275, 250, suit, num))
        end
    end
    stackTable[5]:addCard(cardTable[52])
    table.remove(cardTable, 52)
    stackTable[5]:addCard(cardTable[51])
    table.remove(cardTable, 51)
end