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

    cardStack.temp = temp
    cardStack.filled = false
    cardStack.numCards = 0
    
    return cardStack
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