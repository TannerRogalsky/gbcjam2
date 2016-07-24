-- Generated with TexturePacker (http://www.codeandweb.com/texturepacker)
-- with a custom export by Stewart Bracken (http://stewart.bracken.bz)
--
-- $TexturePacker:SmartUpdate:0da63b4f100b16742477e3f869bae2bf:eeab3c516f899ffebafdcaccb1686a39:ce59e0ef6b4af9fefc088af809f682f1$
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

Quads["asteroid_1"] = love.graphics.newQuad(515, 1, 32, 32, 548, 485 )
Quads["asteroid_2"] = love.graphics.newQuad(515, 35, 32, 32, 548, 485 )
Quads["asteroid_3"] = love.graphics.newQuad(515, 69, 32, 32, 548, 485 )
Quads["speech_1"] = love.graphics.newQuad(1, 1, 512, 95, 548, 485 )
Quads["speech_2"] = love.graphics.newQuad(1, 98, 512, 95, 548, 485 )
Quads["speech_3"] = love.graphics.newQuad(1, 195, 512, 95, 548, 485 )
Quads["speech_4"] = love.graphics.newQuad(1, 292, 512, 95, 548, 485 )
Quads["speech_5"] = love.graphics.newQuad(1, 389, 512, 95, 548, 485 )

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
