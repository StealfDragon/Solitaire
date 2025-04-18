require "card"

TableTopClass = {}

function TableTopClass:new()
    local tableTop = {}
    local metadata = {__index = TableTopClass} -- creates the table metadata
    setmetatable(tableTop, metadata) -- sets "metadata" as the metatable for the card table
    local width = 50
    local height = 70
