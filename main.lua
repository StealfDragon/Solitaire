-- Cassian Jones
-- CMPM 121
-- 4/11/25
-- Credits: Vector Script from Zac Emerzian

require "card"
require "grabber"

function love.load()
    love.window.setMode(960, 640)
    love.graphics.setBackgroundColor(0.2, 0.60, 0.2, 1)

    grabber = GrabberClass:new()
    cardTable = {}

    --isMoving = false

    
    table.insert(cardTable, CardClass:new(100, 100, 1))
    table.insert(cardTable, CardClass:new(100, 200, 2))
end

function love.update()
    grabber:update()
    
    checkForMouseMoving()
    
    for _, card in ipairs(cardTable, card) do
        card:update()
    end
end

function love.draw()
    for _, card in ipairs(cardTable, card) do
        card:draw()
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Mouse:" .. tostring(grabber.currMousePos.x) .. ", " .. tostring(grabber.currMousePos.y))
    love.graphics.print("Current Card:" .. tostring(grabber.currCard), 100, 0)
end

function checkForMouseMoving()
    if grabber.currMousePos == nil then
        return
    end

    for _, card in ipairs(cardTable) do
        card:checkMouseOver(grabber)
        
        --[[
        if grabber:grab() then
            card:update()
        end
        ]]
    end
end