
--------------------------
function Reactions(sprites)
    for i=1,#sprites do
		local s = sprites[i]

		s:Reaction()
	end
end
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
function StopOnHit(self, hit)
	local moveX = self.dx
	local moveY = self.dy

	if hit.enx~=0 and (self.dx * hit.enx) < 0 then
		local candidateX = ClampTowardZero(self.dx * hit.t_entry)
		if math.abs(candidateX) < math.abs(moveX) then
			moveX = candidateX
		end
	end
	if hit.eny~=0 and (self.dy * hit.eny) < 0 then
		local candidateY = ClampTowardZero(self.dy * hit.t_entry)
		if math.abs(candidateY) < math.abs(moveY) then
			moveY = candidateY
		end
	end
	return moveX, moveY
end
--------------------------
function PlayerReaction(self)
	local moveX = self.dx
    local moveY = self.dy
    for sp, e in pairs(self.eventsNext) do
        local hit = e.hit

        if hit then
            --if e.spriteHit.layer&LAY_WORLD_STATIC>0 then
            --	moveX, moveY = StopOnHit(self, hit)
            if e.spriteHit.layer&LAY_WORLD_DYNAMIC>0 then
                if not self.a1 then
                    moveX, moveY = StopOnHit(self, hit)
                end
            else
                moveX, moveY = StopOnHit(self, hit)
            end
        end
    end

    self.dx = moveX
    self.dy = moveY
    --if self.a1 then self.spd=0.5 end
    --self.dx = self.dx * SpeedAdjust(TICK_CNT, self.spd)
    --self.dy = self.dy * SpeedAdjust(TICK_CNT, self.spd)

    self.x = self.x + self.dx
    self.y = self.y + self.dy
end
--------------------------
function BlockReaction(self)
	local moveX = self.dx
    local moveY = self.dy
    for sp, e in pairs(self.eventsNext) do
        local hit = e.hit
        if sp.layer&LAY_PLAYERS>0 then
            if sp.a1==true then
                if hit then
                    local pushScale = 1 - hit.t_entry
                    if pushScale < 0 then pushScale = 0 end
                    if pushScale > 1 then pushScale = 1 end

                    --print("enx"..hit.t_entry,180,72,6)
                    if hit.enx~=0 and (sp.dx * hit.enx) > 0 then
                        moveX = sp.dx * pushScale
                    end
	                if hit.eny~=0 and (sp.dy * hit.eny) > 0 then
                        moveY = sp.dy * pushScale
                    end
                end
            end
        end            
        if sp.layer&(LAY_WORLD_DYNAMIC|LAY_WORLD_STATIC)>0 then
                    print("AANN",180,72,6)
            if hit then
                moveX, moveY = StopOnHit(self, hit)
            end
        end
    end
    self.dx = moveX
    self.dy = moveY

    self.x = self.x + self.dx
    self.y = self.y + self.dy
end