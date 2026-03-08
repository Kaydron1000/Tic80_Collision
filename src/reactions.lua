--------------------------
function ClampTowardZero(v)
    if v > 0 then
        return math.floor(v)
    elseif v < 0 then
        return math.ceil(v)
    end
    return 0
end
--------------------------
function SortedEvents(events)
    local items = {}
    for sp, e in pairs(events) do
        items[#items+1] = {sp = sp, e = e}
    end
    table.sort(items, function(a, b)
        return a.sp.sIdx < b.sp.sIdx
    end)
    return items
end
--------------------------
function ShouldDependOn(sprite, other, hitevent, currEvent)
    -- Static objects never move - nobody depends on them for movement.
    if other.layer & LAY_WORLD_STATIC > 0 then
        return false
    end

    -- Dynamic blocks can depend on other dynamic blocks when they are
    -- already in contact or have a swept hit in this frame.
    if sprite.layer & LAY_WORLD_DYNAMIC > 0 and
       other.layer & LAY_WORLD_DYNAMIC > 0 then
        if hitevent then
            return true
        end
        if currEvent and currEvent.hit and currEvent.hit ~= NONE then
            return true
        end
    end

    -- Dynamic blocks depend on pushing players.
    if sprite.layer & LAY_WORLD_DYNAMIC > 0 and
       other.layer & LAY_PLAYERS > 0 and
       hitevent then
        return other.a1 == true
    end

    -- Players moving into dynamics create dependency.
    if sprite.layer & LAY_PLAYERS > 0 and
       other.layer & LAY_WORLD_DYNAMIC > 0 and
       hitevent then
        return true
    end

    return false
end
--------------------------
function BuildDependencyGraph(sprites)
    local graph = {}

    for i=1,#sprites do
        graph[i] = {
            sprite = sprites[i],
            depends_on = {},
            depth = 0
        }
    end

    for i=1,#sprites do
        local sprite = sprites[i]
        for _, item in ipairs(SortedEvents(sprite.eventsNext)) do
            local other = item.sp
            local event = item.e
            local currEvent = sprite.eventsCurr[other]
            if ShouldDependOn(sprite, other, event.hit, currEvent) then
                table.insert(graph[i].depends_on, other.sIdx)
            end
        end
    end

    return graph
end
--------------------------
function TopologicalSort(graph)
    local sorted = {}
    local visited = {}
    local temp_mark = {}

    local function visit(idx)
        if visited[idx] then return true end
        if temp_mark[idx] then
            -- Cycle detected - for now, just break it.
            return false
        end

        temp_mark[idx] = true

        for _, dep_idx in ipairs(graph[idx].depends_on) do
            visit(dep_idx)
        end

        temp_mark[idx] = false
        visited[idx] = true
        table.insert(sorted, idx)
    end

    for i=1,#graph do
        if not visited[i] then
            visit(i)
        end
    end

    return sorted
end
--------------------------
function StopOnHit(self, hit, velX, velY)
    local dx = velX or self.dx
    local dy = velY or self.dy
    local adjustX = 0
    local adjustY = 0

    if hit.enx ~= 0 and (dx * hit.enx) < 0 then
        local targetX = ClampTowardZero(dx * hit.t_entry)
        if math.abs(targetX) < math.abs(dx) then
            adjustX = targetX - dx
        end
    end
    if hit.eny ~= 0 and (dy * hit.eny) < 0 then
        local targetY = ClampTowardZero(dy * hit.t_entry)
        if math.abs(targetY) < math.abs(dy) then
            adjustY = targetY - dy
        end
    end

    return adjustX, adjustY
end
--------------------------
function Reactions(sprites)
    local graph = BuildDependencyGraph(sprites)

--#if DEBUG
    local yPos = 80
    print("=== DEPENDENCY GRAPH ===", 5, yPos, 14)
    yPos = yPos + 8
    for i=1,#graph do
        if #graph[i].depends_on > 0 then
            local depStr = ""
            for _, dep in ipairs(graph[i].depends_on) do
                depStr = depStr .. dep .. ","
            end
            print("S"..i.." depends on: "..depStr, 5, yPos, 6)
            yPos = yPos + 6
        end
    end
--#else
--#endif

    local order = TopologicalSort(graph)

--#if DEBUG
    yPos = yPos + 2
    print("=== EXEC ORDER ===", 5, yPos, 14)
    yPos = yPos + 8
    local orderStr = ""
    for _, idx in ipairs(order) do
        orderStr = orderStr .. idx .. " "
    end
    print(orderStr, 5, yPos, 11)
--#else
--#endif

    -- Send push-force events down the dependency tree.
    local function PropagateMovementDown(sprites, graph, order)
        local incoming = {}
        for i=1,#sprites do
            incoming[i] = {dx = sprites[i].dx, dy = sprites[i].dy}
        end

        -- parents -> dependencies so chain pushes can cascade.
        for oi=#order,1,-1 do
            local idx = order[oi]
            local sprite = sprites[idx]
            local sourceDx = incoming[idx].dx
            local sourceDy = incoming[idx].dy

            for _, depIdx in ipairs(graph[idx].depends_on) do
                local other = sprites[depIdx]
                local event = sprite.eventsNext[other]
                if event then
                    local hit = event.hit
                    local pushScale = 1

                    if hit then
                        pushScale = 1 - hit.t_entry
                        if pushScale < 0 then pushScale = 0 end
                        if pushScale > 1 then pushScale = 1 end
                    else
                        local currEvent = sprite.eventsCurr[other]
                        if not (currEvent and currEvent.hit and currEvent.hit ~= NONE) then
                            pushScale = 0
                        end
                    end

                    if pushScale > 0 then
                        local pushDx = ClampTowardZero(sourceDx * pushScale)
                        local pushDy = ClampTowardZero(sourceDy * pushScale)

                        incoming[depIdx].dx = incoming[depIdx].dx + pushDx
                        incoming[depIdx].dy = incoming[depIdx].dy + pushDy

                        local dependentEvent = other.eventsNext[sprite]
                        if dependentEvent then
                            if dependentEvent.pushForce then
                                dependentEvent.pushForce.dx = dependentEvent.pushForce.dx + pushDx
                                dependentEvent.pushForce.dy = dependentEvent.pushForce.dy + pushDy
                            else
                                dependentEvent.pushForce = {
                                    dx = pushDx,
                                    dy = pushDy,
                                    enx = hit and hit.enx or 0,
                                    eny = hit and hit.eny or 0,
                                    t_entry = hit and hit.t_entry or 0
                                }
                            end
                        end
                    end
                end
            end
        end
    end

    PropagateMovementDown(sprites, graph, order)

    for _, idx in ipairs(order) do
        sprites[idx]:Reaction()
    end
end
--------------------------
function PlayerReaction(self)
    local moveX = self.dx
    local moveY = self.dy

    for _, item in ipairs(SortedEvents(self.eventsNext)) do
        local e = item.e
        local mx, my = 0, 0
        local hit = e.hit

        if hit then
            if e.spriteHit.layer & LAY_WORLD_DYNAMIC > 0 then
                if not self.a1 then
                    mx, my = StopOnHit(self, hit, moveX, moveY)
                else
                    if e.resolved then
                        mx = e.resolved.correctionDx or 0
                        my = e.resolved.correctionDy or 0
                    else
                        mx, my = StopOnHit(self, hit, moveX, moveY)
                    end
                end
            else
                mx, my = StopOnHit(self, hit, moveX, moveY)
            end
        end

        moveX = moveX + mx
        moveY = moveY + my
    end

    self.dx = ClampTowardZero(moveX)
    self.dy = ClampTowardZero(moveY)

    self.x = self.x + self.dx
    self.y = self.y + self.dy
end
--------------------------
function BlockReaction(self)
    local baseDx = self.dx
    local baseDy = self.dy
    local moveX = self.dx
    local moveY = self.dy

    -- Track requested push by pusher for upward correction events.
    local pushRequestByPusher = {}

    for _, item in ipairs(SortedEvents(self.eventsNext)) do
        local sp = item.sp
        local e = item.e
        local mx, my = 0, 0

        if e.pushForce then
            moveX = moveX + e.pushForce.dx
            moveY = moveY + e.pushForce.dy

            local req = pushRequestByPusher[sp]
            if not req then
                req = {dx = 0, dy = 0}
                pushRequestByPusher[sp] = req
            end
            req.dx = req.dx + e.pushForce.dx
            req.dy = req.dy + e.pushForce.dy
        end

        if sp.layer & (LAY_WORLD_DYNAMIC | LAY_WORLD_STATIC) > 0 then
            if sp.layer & LAY_WORLD_DYNAMIC > 0 and e.resolved then
                mx = e.resolved.correctionDx or 0
                my = e.resolved.correctionDy or 0
            else
                -- Recompute against current accumulated movement.
                local probeSelf = {
                    x = self.x, y = self.y,
                    dx = moveX, dy = moveY,
                    xl = self.xl, xr = self.xr,
                    yt = self.yt, yb = self.yb
                }
                local probeOther = {
                    x = sp.x, y = sp.y,
                    dx = sp.dx or 0, dy = sp.dy or 0,
                    xl = sp.xl, xr = sp.xr,
                    yt = sp.yt, yb = sp.yb
                }
                local liveHit = Swept_aabb(probeSelf, probeOther)
                if liveHit then
                    mx, my = StopOnHit(self, liveHit, moveX, moveY)
                end
            end
        end

        moveX = moveX + mx
        moveY = moveY + my
    end

    self.dx = ClampTowardZero(moveX)
    self.dy = ClampTowardZero(moveY)

    self.x = self.x + self.dx
    self.y = self.y + self.dy

    for pusher, req in pairs(pushRequestByPusher) do
        local pusherEvent = pusher.eventsNext[self]
        if pusherEvent then
            local resolvedDx = ClampTowardZero(self.dx - baseDx)
            local resolvedDy = ClampTowardZero(self.dy - baseDy)
            pusherEvent.resolved = {
                requestedDx = req.dx,
                requestedDy = req.dy,
                resolvedDx = resolvedDx,
                resolvedDy = resolvedDy,
                correctionDx = ClampTowardZero(resolvedDx - req.dx),
                correctionDy = ClampTowardZero(resolvedDy - req.dy)
            }
        end
    end
end
