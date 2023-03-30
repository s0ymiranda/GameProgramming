
local PROJECTILE_SPEED = 50
local PROJECTILE_MAX_TILES = 5

FireBallProjectile = Class{__includes = Projectile}

function FireBallProjectile:init(obj, position)
    --para este caso obj sera la fire ball
    --position la posicion del player
    self.obj = obj
    self.position = position
end

function FireBallProjectile:update(dt)
    
end