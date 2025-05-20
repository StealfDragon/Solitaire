require "vector"

DeckClass = {}

function DeckClass:new(x, y)
    local deck = {}
    setmetatable(deck, { __index = DeckClass })

    deck.size = Vector(50, 70)
    deck.position = Vector(x, y) - deck.size
    deck.cards = {}

    return deck
end

function DeckClass:addCard(card)
    card.flipped = false -- cards in the deck are face down
    table.insert(self.cards, card)
end

function DeckClass:draw()
    if #self.cards > 0 then
        local topCard = self.cards[#self.cards]
        -- Draw the top card as a red-outlined back
        love.graphics.setColor(1, 1, 1, 1) -- white fill
        love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)

        love.graphics.setColor(0.6, 0, 0, 1) -- dark red outline
        love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    else
        -- empty deck outline
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    end
end

function DeckClass:checkClick(x, y)
    return x > self.position.x and x < self.position.x + self.size.x
       and y > self.position.y and y < self.position.y + self.size.y
end

function DeckClass:drawCard()
    if #self.cards == 0 then return nil end
    local card = table.remove(self.cards)
    card.flipped = true
    return card
end