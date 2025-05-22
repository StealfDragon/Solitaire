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
    -- Don't draw the card if it's currently being grabbed
        if card ~= grabber.currCard and (not grabber.grabbedStack or not tableContains(grabber.grabbedStack, card)) then
            card.position.x = self.position.x
            self.totalYOffset = (i - 1) * self.yOffset
            card.position.y = self.position.y + self.totalYOffset
            card:draw()
        end
    end
end

function CardStackClass:addCard(card)
    table.insert(self.cards, card)
    self.numCards = self.numCards + 1
    self.filled = true
    --self.position.y = self.position.y
end

function CardStackClass:removeCard(card)
    local wasTopCard = (self.cards[#self.cards] == card)

    for i, c in ipairs(self.cards) do
        if c == card then
            table.remove(self.cards, i)
            self.totalYOffset = self.totalYOffset - self.yOffset
            break
        end
    end

    self.numCards = self.numCards - 1

    if self.numCards <= 0 then
        self.filled = false
        if self.temp then
            self:kill()
        end
    end

    return wasTopCard
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

function CardStackClass:checkMouseOver()
    local mousePos = grabber.currMousePos
    --[[ return (
        mousePos.x > self.position.x and
        mousePos.x < self.position.x + self.size.x and
        mousePos.y > self.position.y + self.totalYOffset and
        mousePos.y < self.position.y + self.totalYOffset + self.size.y
    ) ]]
    for i, card in ipairs(self.cards) do
        local x = self.position.x
        local y = self.position.y + ((i - 1) * self.yOffset)
        if (
            mousePos.x > x and mousePos.x < x + card.width and
            mousePos.y > y and mousePos.y < y + card.height
        ) then
            return card, i
        end
    end
    return nil, nil
end

function CardStackClass:tryDropCard(card)
    if self:isValidDrop(card) then
        self:addCard(card)
        return true
    end
    return false
end

function CardStackClass:isValidDrop(card)
    local top = self.cards[#self.cards]

    if not top then
        return card.num == 13 -- Only Kings can go in empty tableau slots
    end

    -- Must be opposite color and one rank lower
    local color1 = (card.suit == "heart" or card.suit == "diamond") and "red" or "black"
    local color2 = (top.suit == "heart" or top.suit == "diamond") and "red" or "black"

    return color1 ~= color2 and card.num == top.num - 1
    --return true
end

function CardStackClass:isMouseOver()
    local mouse = grabber.currMousePos
    return (
        mouse.x > self.position.x and
        mouse.x < self.position.x + self.size.x and
        mouse.y > self.position.y and
        mouse.y < self.position.y + self.size.y + self.totalYOffset
    )
end

function tableContains(tbl, item)
    for _, v in ipairs(tbl) do
        if v == item then return true end
    end
    return false
end