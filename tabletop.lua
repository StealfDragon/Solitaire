require "vector"

TableTopClass = {}

function TableTopClass:new()
    local tableTop = {}
    local metadata = {__index = TableTopClass} -- creates the table metadata
    setmetatable(tableTop, metadata) -- sets "metadata" as the metatable for the card table

    local function makeOutline(x, y, type)
        return { pos = Vector(x, y), type = type }
    end
    outlinePositions = {
        makeOutline(200, 200, "deck"),
        makeOutline(275, 200, "depo"),
        
        makeOutline(425, 200, "ace"),
        makeOutline(500, 200, "ace"),
        makeOutline(575, 200, "ace"),
        makeOutline(650, 200, "ace"),

        makeOutline(200, 300, "stack"),
        makeOutline(275, 300, "stack"),
        makeOutline(350, 300, "stack"),
        makeOutline(425, 300, "stack"),
        makeOutline(500, 300, "stack"),
        makeOutline(575, 300, "stack"),
        makeOutline(650, 300, "stack")
    }

    tableTop.outlines = {}

    local width = 50
    local height = 70

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