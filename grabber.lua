require "vector"

GrabberClass = {}

function GrabberClass:new()
    local grabber = {}
    local metadata = {__index = GrabberClass}
    setmetatable(grabber, metadata)

    grabber.prevMousePos = nil
    grabber.currMousePos = nil

    grabber.grabbed = false
    grabber.currCard = 0
    grabber.currStack = 0

    grabber.grabPos = nil

    return grabber
end

function GrabberClass:update()
    self.currMousePos = Vector(
        love.mouse.getX(),
        love.mouse.getY()
    )

    if love.mouse.isDown(1) and self.grabPos == nil then
        self:grab()
    end

    if not love.mouse.isDown(1) and self.grabPos ~= nil then
        self:release()
    end
end

function GrabberClass:grab()
    self.grabPos = self.currMousePos

    if not isMoving then 
        self.grabbed = true
        isMoving = true
    end
    print("GRAB - " .. tostring(self.grabPos))
end

function GrabberClass:release()
    print("RELEASE - " .. tostring(self.grabPos))

    local dropped = false
    self.flipPending = false

    if self.grabbedStack then
        for _, stack in ipairs(stackTable) do
            if stack:isMouseOver() then
                if stack:isValidDrop(self.grabbedStack[1]) then
                    for _, card in ipairs(self.grabbedStack) do
                        stack:addCard(card)
                    end
                    dropped = true
                    break
                end
            end
        end

        if dropped and self.originalStack then
            local top = self.originalStack.cards[#self.originalStack.cards]
            if top and not top.flipped then
                top.flipped = true
            end
        end

        if not dropped then
            for _, card in ipairs(self.grabbedStack) do
                card:setPos(card.originalPos.x + card.width, card.originalPos.y + card.height)
                card.state = CARD_STATE.IDLE
                if self.originalStack then
                    self.originalStack:removeCard(card)
                    self.originalStack:addCard(card)
                end
            end
        end

    elseif self.currCard ~= 0 then
        for _, stack in ipairs(stackTable) do
            if stack:isMouseOver() then
                if self.originalStack then
                    local wasTopCard = self.originalStack:removeCard(self.currCard)
                    if wasTopCard then
                        self.flipPending = true
                    end
                end

                --[[ if self.originalStack and self.currCard ~= 0 then
                    local wasTop = self.originalStack:removeCard(self.currCard)
                    if wasTop then
                        self.flipPending = true
                    end
                end ]]

                if stack:tryDropCard(self.currCard) then
                    -- Remove from floating cards
                    for i, c in ipairs(cardTable) do
                        if c == self.currCard then
                            table.remove(cardTable, i)
                            break
                        end
                    end

                    self:flipTopIfNeeded()

                    dropped = true
                    break
                end
            end
        end

        if not dropped then
            for _, aceStack in ipairs(aceStacks) do
                if aceStack:checkMouseOver() then
                     if self.originalStack then
                        local wasTopCard = self.originalStack:removeCard(self.currCard)
                        if wasTopCard then
                            self.flipPending = true
                        end
                    end
                    if aceStack:isValidDrop(self.currCard) then
                        aceStack:addCard(self.currCard)
                        dropped = true

                        self:flipTopIfNeeded()

                        for i = #cardTable, 1, -1 do
                            if cardTable[i] == self.currCard then
                                table.remove(cardTable, i)
                                break
                            end
                        end

                        break
                    end
                end
            end
        end

        if not dropped then
            self.currCard:setPos(
                self.currCard.originalPos.x + self.currCard.width,
                self.currCard.originalPos.y + self.currCard.height
            )
            self.currCard.state = CARD_STATE.IDLE
            for i = #cardTable, 1, -1 do
                if cardTable[i] == self.currCard then
                    table.remove(cardTable, i)
                    break
                end
            end
            table.insert(cardTable, self.currCard)

            if self.originalStack then
                self.originalStack:removeCard(self.currCard)
                self.originalStack:addCard(self.currCard)
            end
        end
    end

    self.grabbed = false
    isMoving = false
    self.grabPos = nil
    self.currCard = 0
    self.grabbedStack = nil
    self.originalStack = nil

    --[[ if self.currCard ~= 0 then
        local grabbedCard = self.currCard

        if grabbedCard then
            for _, stack in ipairs(stackTable) do
                if stack:checkMouseOver() then
                    local success = stack:tryDropCard(grabbedCard)
                    if success then
                        for i, c in ipairs(cardTable) do
                            if c == grabbedCard then
                                table.remove(cardTable, i)
                                break
                            end
                        end
                        dropped = true
                        break
                    end
                end
            end
            if not dropped and grabbedCard.originalPos then
            grabbedCard:setPos(grabbedCard.originalPos.x + grabbedCard.width, grabbedCard.originalPos.y + grabbedCard.height)
            grabbedCard.state = CARD_STATE.IDLE
            end
        end
    end

    -- Reset grab state
    self.grabbed = false
    isMoving = false
    self.grabPos = nil
    self.currCard = 0 ]]
end

function GrabberClass:flipTopIfNeeded()
    if self.flipPending and self.originalStack then
        local top = self.originalStack.cards[#self.originalStack.cards]
        if top and not top.flipped then
            top.flipped = true
        end
    end
end