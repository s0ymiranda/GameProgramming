
local PROJECTILE_SPEED = 1
--local PROJECTILE_MAX_TILES = 5

FireBallProjectile = Class{__includes = Projectile}

function FireBallProjectile:init(obj, target)
    --para este caso obj sera la fire ball
    --position la posicion del player
    self.obj = obj
    self.target = target
    self.distance_x = 0
    self.distance_y = 0
    self.dead = false
    self.final_position_x = target.x
    self.final_position_y = target.y 
    self.initial_position_x = obj.x
    self.initial_position_y = obj.y 
end

function FireBallProjectile:update(dt)
    
    if self.dead then
        return
    end

    local disty = PROJECTILE_SPEED*(self.final_position_y - self.initial_position_y)*dt
    local distx = PROJECTILE_SPEED*(self.final_position_x - self.initial_position_x)*dt
    
    self.obj.y = self.obj.y + disty
    self.obj.x = self.obj.x + distx

    self.distance_x = self.distance_x + math.abs(distx)
    self.distance_y = self.distance_y + math.abs(disty)

    if self.distance_x >= math.abs(self.final_position_x - self.initial_position_x) and self.distance_y >= math.abs(self.final_position_y - self.initial_position_y) then
        self.dead = true
    end


    -- if self.dead then
    --     SOUNDS['pot-wall']:play()
    --     return
    -- end

    -- self.distance = self.distance + d

    -- if self.distance > PROJECTILE_MAX_TILES*TILE_SIZE then
    --     self.dead = true
    -- end
end