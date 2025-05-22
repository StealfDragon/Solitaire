-- Cassian Jones
-- CMPM 121
-- 4/11/25
-- Credits: Vector Script from Zac Emerzian

require "card"
require "grabber"
require "tabletop"
require "deck"
require "acestack"
local cardFlippedThisClick = false

function love.load()
    math.randomseed(os.time())
    love.window.setMode(960, 640) -- Creates window and defines size
    love.window.setTitle("Cassian Jones's Solitaire")
    love.graphics.setBackgroundColor(0.2, 0.60, 0.2, 1) -- Sets background color of the window

    width = 50
    height = 70

    grabber = GrabberClass:new() -- makes new grabber instance
    stackTable = {}
    aceStacks = {}
    tableTop = TableTopClass:new(stackTable, aceStacks)
    deck = DeckClass:new(275, 250)
    drawPile = {}
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
    deck:draw()

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

    for _, stack in ipairs(aceStacks) do
        stack:draw()
    end

    if grabber.grabbedStack then
        for i, card in ipairs(grabber.grabbedStack) do
            local offsetY = (i - 1) * 20
            card.position = grabber.currMousePos - (card.size / 2) + Vector(0, offsetY)
            card:draw()
        end
    elseif grabber.currCard ~= 0 then
        grabber.currCard.position = grabber.currMousePos - (grabber.currCard.size / 2)
        grabber.currCard:draw()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and deck:checkClick(x, y) then
        if #deck.cards == 0 then
            for i = 1, #drawPile do
                local card = drawPile[i]

                -- Only remove from cardTable if it's still floating (not played)
                for j = #cardTable, 1, -1 do
                    if cardTable[j] == card then
                        table.remove(cardTable, j)
                        break
                    end
                end

                card.flipped = false
                card:setPos(deck.position.x + card.width, deck.position.y + card.height)
                deck:addCardToBottom(card) -- preserves original draw order
            end

            drawPile = {}

        else
            for _, card in ipairs(drawPile) do
                -- Push them back so they are "under" the new cards (invisible)
                card:setPos(-100, -100)  -- off-screen or under deck
            end

            -- Draw up to 3 new cards
            for i = 1, 3 do
                local card = deck:drawCard()
                if not card then break end

                card.flipped = true
                card:setPos(350 + ((i - 1) * 20), 250)

                table.insert(drawPile, card)
                table.insert(cardTable, card)
            end
        end
    end
end

function checkForMouseMoving()
    if grabber.currMousePos == nil then return end

    for _, stack in ipairs(stackTable) do
        local card, index = stack:checkMouseOver()
        if card and grabber.currCard == 0 and grabber.grabbed then
            local stackSize = #stack.cards

            if index == stackSize then
                -- Top card: grab single card
                grabber.currCard = card
                grabber.grabbedStack = nil
                grabber.originalStack = stack
                card.originalPos = Vector(card.position.x, card.position.y)
                card.state = CARD_STATE.GRABBED

                -- Make sure card is in cardTable for drawing if needed
                if not tableContains(cardTable, card) then
                    table.insert(cardTable, card)
                end
            else
                -- Not top card: grab full segment
                local grabbedSegment = {}
                grabber.originalStack = stack
                for i = index, stackSize do
                    table.insert(grabbedSegment, stack.cards[i])
                end

                -- Remove them from the stack
                for i = stackSize, index, -1 do
                    stack:removeCard(stack.cards[i])
                end

                grabber.currCard = grabbedSegment[1]
                grabber.grabbedStack = grabbedSegment

                for _, c in ipairs(grabbedSegment) do
                    c.originalPos = Vector(c.position.x, c.position.y)
                    c.state = CARD_STATE.GRABBED
                end
            end

            break
        end
    end

    if #drawPile > 0 then
        local topDrawn = drawPile[#drawPile]
        if topDrawn:checkMouseOver() then
            -- Move to top of draw order
            for i = #cardTable, 1, -1 do
                if cardTable[i] == topDrawn then
                    table.remove(cardTable, i)
                    table.insert(cardTable, topDrawn)
                    break
                end
            end
        end
    end
end

function instantiateCards()
    local suits = {"club", "heart", "spade", "diamond"}
    local cards = {}

    -- Create 52 cards
    for _, suit in ipairs(suits) do
        for num = 1, 13 do
            table.insert(cards, CardClass:new(200, 250, suit, num))
        end
    end

    -- Shuffle
    for i = #cards, 2, -1 do
        local j = math.random(i)
        cards[i], cards[j] = cards[j], cards[i]
    end

    local cardIndex = 1
    for i = 1, 7 do
        for j = 1, i do
            local card = cards[cardIndex]
            cardIndex = cardIndex + 1
            stackTable[i]:addCard(card)
            card.flipped = j == i -- Only the top card is face-up
        end
    end

    -- Remaining go into deck
    for i = cardIndex, #cards do
        deck:addCard(cards[i])
    end
end

function tableContains(tbl, item)
    for _, v in ipairs(tbl) do
        if v == item then return true end
    end
    return false
end

function checkWinCondition()
    local total = 0
    for _, stack in ipairs(aceStacks) do
        total = total + #stack.cards
    end

    if total == 52 then
        print("🎉 You win!")
        gameWon = true
    end
end