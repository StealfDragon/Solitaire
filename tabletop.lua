require "vector"
require "cardstack"

TableTopClass = {}

function TableTopClass:new(stackTable, aceStacks, drawPile, windowW, windowH)
    local tableTop = {}
    local metadata = {__index = TableTopClass} -- creates the table metadata
    setmetatable(tableTop, metadata) -- sets "metadata" as the metatable for the card table

    local width = 50
    local height = 70

    local function makeOutline(x, y, type)
        if type == "tableau" then
            table.insert(stackTable, CardStackClass:new(x, y, false))
        elseif type == "ace" then
            table.insert(aceStacks, AceStackClass:new(x, y)) -- add ace stack here
        elseif type == "deck" then
            deck = DeckClass:new(x, y)
        end
        return { pos = Vector(x - width, y - height), type = type }
    end
    outlinePositions = {
        makeOutline(windowW - 225, windowH - 50, "deck"),
        makeOutline(windowW - 150, windowH - 50, "depo"),
        
        makeOutline(windowW, windowH - 50, "ace"),
        makeOutline(windowW + 75, windowH - 50, "ace"),
        makeOutline(windowW + 150, windowH - 50, "ace"),
        makeOutline(windowW + 225, windowH - 50, "ace"),

        makeOutline(windowW - 225, windowH + 50, "tableau"),
        makeOutline(windowW - 150, windowH + 50, "tableau"),
        makeOutline(windowW - 75, windowH + 50, "tableau"),
        makeOutline(windowW, windowH + 50, "tableau"),
        makeOutline(windowW + 75, windowH + 50, "tableau"),
        makeOutline(windowW + 150, windowH + 50, "tableau"),
        makeOutline(windowW + 225, windowH + 50, "tableau"),
    }

    tableTop.outlines = {}

    for _, data in ipairs(outlinePositions) do
        table.insert(tableTop.outlines, {
            position = data.pos,
            size = Vector(width, height),
            type = data.type,
            occupied = false
        })
    end

    return tableTop
end

function TableTopClass:update()

end

function TableTopClass:draw()
    local bigFont = love.graphics.newFont(24)
    love.graphics.setFont(bigFont)

    for _, outline in ipairs(self.outlines) do
        love.graphics.setColor(0.48, 0.48, 0.48, 0.3)
        love.graphics.rectangle("fill", outline.position.x, outline.position.y, outline.size.x, outline.size.y, 6, 6)
        love.graphics.setColor(0.29, 0.29, 0.29, 1)
        love.graphics.rectangle("line", outline.position.x, outline.position.y, outline.size.x, outline.size.y, 6, 6)
        if outline.type == "ace" then
            local text = "A"
            local textWidth = bigFont:getWidth(text)
            local textHeight = bigFont:getHeight()
            
            local centerX = outline.position.x + (outline.size.x / 2) - (textWidth / 2)
            local centerY = outline.position.y + (outline.size.y / 2) - (textHeight / 2)

            love.graphics.print(text, centerX, centerY)
            --love.graphics.print("A", outline.position.x + (outline.size.x / 2 - 5), outline.position.y + (outline.size.y / 2 - 5))
        end
    end
end