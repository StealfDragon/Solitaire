require "vector"
require "card"

CardStackClass = {}

function CardStackClass:new(xPos, yPos, temp)
    local cardStack = {}
    local metadata = {__index = CardStackClass} -- creates the table metadata
    setmetatable(cardStack, metadata) -- sets "metadata" as the metatable for the card table
    cardStack.width = 50
    cardStack.height = 70

    cardStack.position = Vector(xPos - cardStack.width, yPos - cardStack.height)
    cardStack.size = Vector(cardStack.width, cardStack.height)
    cardStack.yOffset = 20
    cardStack.totalYOffset = 0

    cardStack.temp = temp
    cardStack.filled = false
    cardStack.numCards = 0

    cardStack.cards = {}

    --table.insert(stackTable, cardStack)
    return cardStack
end

function CardStackClass:update()

end

function CardStackClass:draw()
    for i, card in ipairs(self.cards) do
        card.position.x = self.position.x
        self.totalYOffset = (i - 1) * self.yOffset
        card.position.y = self.position.y + self.totalYOffset
        card:draw()
    end
end

function CardStackClass:addCard(card)
    table.insert(self.cards, card)
    self.numCards = self.numCards + 1
    self.filled = true
    --self.position.y = self.position.y
end

function CardStackClass:removeCard(card)
    for i, c in ipairs(self.cards) do
        if c == card then
            table.remove(self.cards, i)
            self.totalYOffset = self.totalYOffset - self.yOffset
            break
        end
    end
    self.numCards = self.numCards - 1
    if numCards <= 0 then
        self.filled = false
        if self.temp then
            self.kill()
        end
    end
    --self.position.y = self.position.y
end

function CardStackClass:kill()
    if not self.temp then
        return
    end

    for i, stack in ipairs(stackTable) do
        if stack == self then
            table.remove(stackTable, i)
            break
        end
    end
end

function CardStackClass:checkMouseOver(x, y)
    return (
        x > self.position.x and
        x < self.position.x + self.size.x and
        y > self.position.y + self.totalYOffset and
        y < self.position.y + self.totalYOffset + self.size.y
    )
end