require "vector"

CardClass = {}

CARD_STATE = {
    IDLE = 0,
    MOUSE_OVER = 1,
    GRABBED = 2
}

function CardClass:new(xPos, yPos, num)
    local card = {}
    local metadata = {__index = CardClass}
    setmetatable(card, metadata)

    card.width = 50
    card.height = 70

    card.position = Vector(xPos - card.width, yPos - card.height)
    card.num = num
    card.size = Vector(card.width, card.height)
    card.state = CARD_STATE.IDLE


    return card
end

function CardClass:update()
    
    if self.state == CARD_STATE.GRABBED and self.num == grabber.currCard then
        self.position = grabber.currMousePos - (self.size / 2)
        if not grabber.grabbed then
            self.state = CARD_STATE.MOUSE_OVER
        end
    end
    
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

    love.graphics.print(tostring(self.state), self.position.x + 20, self.position.y - 20)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(self.num), self.position.x + (self.size.x / 2 - 5), self.position.y + (self.size.y / 2 - 5))
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

    if isMouseOver then
        self.state = CARD_STATE.MOUSE_OVER 
        if grabber.grabbed then
            self.state = CARD_STATE.GRABBED
            grabber.currCard = self.num
        end
    end
    
    if not isMouseOver then
        self.state = CARD_STATE.IDLE
        grabber.currCard = 0
    end
end