require "vector"

AceStackClass = {}

function AceStackClass:new(x, y)
    local stack = {}
    setmetatable(stack, { __index = AceStackClass })

    stack.position = Vector(x, y)
    stack.size = Vector(50, 70)
    stack.cards = {}

    return stack
end

function AceStackClass:addCard(card)
    table.insert(self.cards, card)
end

function AceStackClass:isValidDrop(card)
    local top = self.cards[#self.cards]
    if not top then
        return card.num == 1 -- Only accept Ace if empty
    else
        return card.suit == top.suit and card.num == top.num + 1
    end
end

function AceStackClass:checkMouseOver()
    local mouse = grabber.currMousePos
    return (
        mouse.x > self.position.x and
        mouse.x < self.position.x + self.size.x and
        mouse.y > self.position.y and
        mouse.y < self.position.y + self.size.y
    )
end

function AceStackClass:draw()
    love.graphics.setColor(0.7, 0.7, 0.7, 0.3)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)

    if #self.cards > 0 then
        local top = self.cards[#self.cards]
        top:setPos(self.position.x + top.width, self.position.y + top.height)
        top:draw()
    end
end