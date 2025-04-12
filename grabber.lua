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

    self.grabbed = false
    isMoving = false

    self.grabPos = nil
end
