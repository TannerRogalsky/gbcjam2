-- Generated with TexturePacker (http://www.codeandweb.com/texturepacker)
-- with a custom export by Stewart Bracken (http://stewart.bracken.bz)
--
-- $TexturePacker:SmartUpdate:e1d1cf4764202a5cfe08ec2cae7065c9:35cc6571da91846bbd0323d04b8a5c5a:ce59e0ef6b4af9fefc088af809f682f1$
--
--[[------------------------------------------------------------------------
-- Example Usage --

function love.load()
	myAtlas = require("sprites")
	batch = love.graphics.newSpriteBatch( myAtlas.texture, 100, "stream" )
end
function love.draw()
	batch:clear()
	batch:bind()
		batch:add( myAtlas.quads['mySpriteName'], love.mouse.getX(), love.mouse.getY() )
	batch:unbind()
	love.graphics.draw(batch)
end

--]]------------------------------------------------------------------------

local TextureAtlas = {}
local Quads = {}
local Texture = game.preloaded_images["sprites.png"]

Quads["asteroid_1"] = love.graphics.newQuad(12, 1, 24, 19, 413, 449 )
Quads["asteroid_2"] = love.graphics.newQuad(38, 1, 28, 21, 413, 449 )
Quads["asteroid_3"] = love.graphics.newQuad(68, 1, 32, 30, 413, 449 )
Quads["flare-2"] = love.graphics.newQuad(1, 35, 411, 413, 413, 449 )
Quads["juno_face"] = love.graphics.newQuad(1, 1, 9, 9, 413, 449 )
Quads["juno_panels"] = love.graphics.newQuad(102, 1, 31, 32, 413, 449 )

function TextureAtlas:getDimensions(quadName)
	local quad = self.quads[quadName]
	if not quad then
		return nil
	end
	local x, y, w, h = quad:getViewport()
    return w, h
end

TextureAtlas.quads = Quads
TextureAtlas.texture = Texture

return TextureAtlas
