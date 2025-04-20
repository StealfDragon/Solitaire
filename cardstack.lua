require "card"

CardStackClass = {}

function CardStackClass:new()
    local cardStack = {}
    local metadata = {__index = CardStackClass} -- creates the table metadata
    setmetatable(cardStack, metadata) -- sets "metadata" as the metatable for the card table
    local width = 50
    local height = 70

    cardStack.filled = true
    cardStack.temp = false

    cardStack.position = Vector(xPos - card.width, yPos - card.height)

end

function CardStackClass:update()

end

function CardStackClass:draw()

end

function CardStackClass:add()

end