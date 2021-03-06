
local color = require 'scripts/colors'
local motivationalMessages = {
	"Has Muerto :)",
	"Nadie nace siendo un maestro!",
}
local currentMessage = motivationalMessages[1]
local deathScreen = {}

function deathScreen:chooseMotivationalMessage()
	currentMessage = motivationalMessages[math.random(1,#motivationalMessages)]
end

function deathScreen:draw()
	if game.deathtimer >= 0.25*game.fullDeathtimer then
		love.graphics.setColor( color.white )
		--deathScreenMessageVis:draw( love.graphics.getWidth()/2, love.graphics.getHeight() - Camera.scale*10, true )
		love.graphics.setFont(fontLarge)
		love.graphics.printf( currentMessage,
			0, love.graphics.getHeight() - 120,
			love.graphics.getWidth(), "center" )
		love.graphics.setFont(fontSmall)
		love.graphics.printf( "Presiona cualquier boton para reintentar.",
			0, love.graphics.getHeight() - 60,
			love.graphics.getWidth(), "center" )
	end
end
return deathScreen
