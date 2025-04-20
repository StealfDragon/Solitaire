require "card"

DeckClass = {}

function DeckClass:new()
    local deck = {}
    local metadata = {__index = DeckClass} -- creates the table metadata
    setmetatable(deck, metadata) -- sets "metadata" as the metatable for the card table
    local width = 50
    local height = 70

    deck.empty = true

    deck.position = Vector(xPos - deck.width, yPos - deck.height)
    deck.size = Vector(deck.width, deck.height)
end

function DeckClass:update()

end

function DeckClass:draw()

end

function DeckClass:add()

end