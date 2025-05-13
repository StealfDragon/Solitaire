require "vector"

CardClass = {} -- creates cardClass table, for which we make functions

CARD_STATE = { -- stores possible card states
    IDLE = 0,
    MOUSE_OVER = 1,
    GRABBED = 2
}

function CardClass:new(xPos, yPos, suit, num)
    local card = {} -- makes a card "class"
    local metadata = {__index = CardClass} -- creates the table metadata
    setmetatable(card, metadata) -- sets "metadata" as the metatable for the card table
    -- Both lines combined make it so that if any key accessed in the card table doesn't exist,
    -- it can be searched for in CardClass

    card.width = 50 -- sets card dimensions
    card.height = 70

    card.flipped = true -- important card info
    card.redrawn = false

    card.position = Vector(xPos - card.width, yPos - card.height) -- makes a vector that stores card position
    card.suit = suit
    card.num = num -- sets card num, CHANGE LATER
    card.size = Vector(card.width, card.height)
    card.state = CARD_STATE.IDLE
    return card
end

function CardClass:update()
    
    if self.state == CARD_STATE.GRABBED and self.num == grabber.currCard then
        self.position = grabber.currMousePos - (self.size / 2)
        if not grabber.grabbed then
            self.state = CARD_STATE.MOUSE_OVER
            grabber.currCard = 0
        end
    end

    --[[
    if self.flipped == true and self.redrawn == false then
        
    end
    ]]
    
    --[[
    if grabber.grabbed then 
        self.position = grabber.currMousePos - (self.size / 2)
        self.state = CARD_STATE.GRABBED
    end
    ]]
end

function CardClass:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    
    if not self.flipped then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    end

    if self.flipped then
        love.graphics.setColor(0, 0, 0, 1)
        s = string.sub(self.suit, 1, 1) .. tostring(self.num)
        love.graphics.print(s, self.position.x + (self.size.x / 2 - 2), self.position.y --[[+ (self.size.y / 2 - 5)]])
    end
end

function CardClass:checkMouseOver()
    if self.state == CARD_STATE.GRABBED then
        return
    end

    -- self.grabbedBy = grabber

    local mousePos = grabber.currMousePos
    local isMouseOver = 
        mousePos.x > self.position.x and
        mousePos.x < self.position.x + self.size.x
        and
        mousePos.y > self.position.y and
        mousePos.y < self.position.y + self.size.y

    --self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE

    if isMouseOver and grabber.currCard == 0 then
        self.state = CARD_STATE.MOUSE_OVER
        if grabber.grabbed then
            if not self.flipped then
                -- self.flipped = true
            else -- if card already flipped, then is moveable
                self.state = CARD_STATE.GRABBED
                grabber.currCard = self.num
                return true
            end
        end
    end
    
    if not isMouseOver then
        self.state = CARD_STATE.IDLE
        --grabber.currCard = 0
    end

    return false
end

function CardClass:setPos(newX, newY)
    self.position = Vector(newX - self.width, newY - self.height)
end