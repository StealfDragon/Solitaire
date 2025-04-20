require "card"

CardStackClass = {}

function CardStackClass:new()
    local cardStack = {}
    local metadata = {__index = CardStackClass} -- creates the table metadata
    setmetatable(cardStack, metadata) -- sets "metadata" as the metatable for the card table
    local width = 50
    local height = 70

    cardStack.filled = true
    cardStack.numCards = 0
    cardStack.removeable = false

    cardStack.position = Vector(xPos - cardStack.width, yPos - cardStack.height)
    cardStack.size = Vector(cardStack.width, cardStack.height)
end

function CardStackClass:update()

end

function CardStackClass:draw()

end

function CardStackClass:setTemp()

end

function CardStackClass:addCard(card)

end

function CardStackClass:removeCard(card)

end

function CardStackClass:kill()

end