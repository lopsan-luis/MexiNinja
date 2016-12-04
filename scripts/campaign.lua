Campaign = {
	'0-01.dat',

	'1-01.dat',	'1-02.dat',	'1-03.dat',	'1-04.dat',	'1-05.dat',
	'1-06.dat',	'1-07.dat',	'1-08.dat',	'1-09.dat',	'1-10.dat',
	'1-11.dat',	'1-12.dat',	'1-13.dat',	'1-14.dat',	'1-15.dat',

	'2-01.dat',	'2-02.dat',	'2-03.dat',	'2-04.dat',	'2-05.dat',
	'2-06.dat', '2-07.dat',	'2-08.dat',	'2-09.dat',	'2-10.dat',
	'2-11.dat',	'2-12.dat',	'2-13.dat',	'2-14.dat',	'2-15.dat',

	'3-01.dat',	'3-02.dat',	'3-03.dat',	'3-04.dat',	'3-05.dat',
	'3-06.dat', '3-07.dat',	'3-08.dat',	'3-09.dat',	'3-10.dat',
	'3-11.dat',	'3-12.dat',	'3-13.dat',	'3-14.dat',	'3-15.dat',

	'4-01.dat',	'4-02.dat',	'4-03.dat',	'4-04.dat',	'4-05.dat',
	'4-06.dat', '4-07.dat',	'4-08.dat',	'4-09.dat',	'4-10.dat',
	'4-11.dat',	'4-12.dat',	'4-13.dat',	'4-14.dat',	'4-15.dat',

	'5-01.dat',	'5-02.dat',	'5-03.dat',	'5-04.dat',	'5-05.dat',
	'5-06.dat', '5-07.dat',	'5-08.dat',	'5-09.dat',	'5-10.dat',
	'5-11.dat',	'5-12.dat',	'5-13.dat',	'5-14.dat',	'5-15.dat',

	'6-01.dat', '6-02.dat',
	}

Campaign.current = 0
Campaign.worldNumber = 1
Campaign.last = 0
Campaign.bandana = 'blank'

local num2bandana = {'blank','white','yellow','green','blue','red'}
local bandana2num = {blank=1,white=2,yellow=3,green=4,blue=5,red=6}

function Campaign:showUpgrade( color )
	print("show upgrade", color)
end

function Campaign:upgradeBandana(color)
-- apply new bandana and return the color, if it is new, 'none' otherwise
	local current = bandana2num[self.bandana]
	local new = bandana2num[color]
	if new > current then
		self.bandana = num2bandana[new]
		p:setBandana(self.bandana)
		self:showUpgrade( color )
		config.setValue('bandana', self.bandana )
		return self.bandana
	end
	return 'none'
end

function Campaign:init()
	print("Initializing Campaign")
	local lastIndex = 1
	local lastLevel = config.getValue( "lastLevel")
	if lastLevel then
		lastIndex = utility.tableFind(self, lastLevel)
	end
	self.last = lastIndex
	local currentLevel = config.getValue( "level")
	local currentIndex = 1
	if currentLevel then
		currentIndex = utility.tableFind(self, currentLevel)
	end
	self:setLevel(currentIndex)
end
function Campaign:reset()
	print("Resetting Campaign")
	self.last = 1
	self:setLevel(1)
	menu:resetWorldButtons()
	menu:createWorldButtons()
	self.bandana = 'blank'
	config.setValue('bandana', self.bandana )
  --myMap = Map:loadFromFile( "levels/" .. self[self.current])
end

function Campaign:proceed()
	menu:createWorldButtons()
	local worldChange, nextIsNew = self:setLevel(self.current+1)

	if worldChange and nextIsNew then
		-- go to animation for world transition
		--menu:proceedToNextLevel( self.current )


		menu:nextWorld( self.worldNumber )	-- (shows new bridge)
		menu:show()
	elseif self[self.current] then
		-- go to next level
		--myMap = Map:loadFromFile( "levels/" .. self[self.current])
		--levelEnd:reset()
		--myMap:start()
		--mode = 'game'

		fader:fadeTo(self.current)
		gui:newLevelName( self.names[ self[self.current] ] )
	else -- if there is no next level
		menu:proceedToNextLevel( self.current )
		self:setLevel(self.current-1)
		menu:switchToSubmenu( "Worldmap" )
		menu:show()
	end
	self:saveState()
end

function Campaign:saveState()
	-- remember the level which was last played
	config.setValue( "level", self[self.current] )
	--config.setValue( "lastLevel", self[self.last] )

	-- if this level is further down the list than the
	-- saved "last level", then save the current level
	-- as the "last level":
	local lastLevel = config.getValue( "lastLevel")
	if not lastLevel then
		--print("saving new last level:", self[self.current])
		config.setValue( "lastLevel", self[self.current])
	else
		local curIndex = utility.tableFind(self, self[self.current])
		local lastIndex = utility.tableFind(self, lastLevel)
		-- If the saved lastlevel is higher than my current last level, then we just reset the game.
		-- In this case, overwrite what's written in the file:
		if lastIndex and curIndex then
			lastIndex = math.min( self.last, lastIndex )
		-- If the saved lastlevel is higher than my current last level, then we just reset the game.
			lastIndex = math.max( curIndex, lastIndex )
		--print("curIndex, lastIndex", curIndex, lastIndex, #lastLevel, #self[self.current])
			config.setValue( "lastLevel", self[lastIndex])
		end
	end--]]
end

function Campaign:setLevel(lvlnum)
	local nextIsNew = (lvlnum > self.last)
	self.current = lvlnum
	self.last = math.max(self.last, self.current)
	local newWorld = math.floor((self.current-2)/15)+1
	if newWorld == self.worldNumber then
		return false, nextIsNew
	else
		self.worldNumber = newWorld
		return true, nextIsNew
	end
end

Campaign.names = {}

Campaign.names['0-01.dat'] = "Casa del Maestro Coshi"

Campaign.names['1-01.dat'] = 'Blanco como el Santo'
Campaign.names['1-02.dat'] = 'Remolino'
Campaign.names['1-03.dat'] = 'La primera muerte'
Campaign.names['1-04.dat'] = 'Salto de fe'
Campaign.names['1-05.dat'] = 'Llegan las criaturas!'
Campaign.names['1-06.dat'] = 'Clavado'
Campaign.names['1-07.dat'] = 'Deslice'
Campaign.names['1-08.dat'] = 'A lo profundo'
Campaign.names['1-09.dat'] = 'La choza'
Campaign.names['1-10.dat'] = 'Las chuchillas'
Campaign.names['1-11.dat'] = 'Subiendo'
Campaign.names['1-12.dat'] = 'Sin suelo'
Campaign.names['1-13.dat'] = 'Con hambre'
Campaign.names['1-14.dat'] = 'Its a trap!!'
Campaign.names['1-15.dat'] = 'Finale'

Campaign.names['2-01.dat'] = 'El amarillo sol de Hermosillo'
Campaign.names['2-02.dat'] = 'Le Parcours'
Campaign.names['2-03.dat'] = 'Saltos Avanzados'
Campaign.names['2-04.dat'] = 'Low rider'
Campaign.names['2-05.dat'] = 'Presiona el boton'
Campaign.names['2-06.dat'] = 'La casa de los chuchillos'
Campaign.names['2-07.dat'] = 'El compa'
Campaign.names['2-08.dat'] = 'Vertical'
Campaign.names['2-09.dat'] = 'Horizontal'
Campaign.names['2-10.dat'] = 'La jaiva te va a morder'
Campaign.names['2-11.dat'] = 'Vueltas, vueltas y mas vueltas'
Campaign.names['2-12.dat'] = 'Licuadora'
Campaign.names['2-13.dat'] = 'Sensible'
Campaign.names['2-14.dat'] = 'Cortina'
Campaign.names['2-15.dat'] = 'Acseso autorizado'

Campaign.names['3-01.dat'] = 'Verde significa independencia'
Campaign.names['3-02.dat'] = 'Tierra'
Campaign.names['3-03.dat'] = 'Con cuidado!!'
Campaign.names['3-04.dat'] = 'Arriba'
Campaign.names['3-05.dat'] = 'Saltos'
Campaign.names['3-06.dat'] = 'El tunel de espinas'
Campaign.names['3-07.dat'] = 'Tu yo pedo'
Campaign.names['3-08.dat'] = 'La persecucion'
Campaign.names['3-09.dat'] = 'Meditacion'
Campaign.names['3-10.dat'] = 'Trabajo en equipo'
Campaign.names['3-11.dat'] = 'Evolucion'
Campaign.names['3-12.dat'] = 'Saca raite'
Campaign.names['3-13.dat'] = 'Viento arriba'
Campaign.names['3-14.dat'] = 'Las entrañas reverseada'
Campaign.names['3-15.dat'] = 'Esta lloviendo?...en Hermosillo?'

Campaign.names['4-01.dat'] = 'Blue Demon'
Campaign.names['4-02.dat'] = 'Negado'
Campaign.names['4-03.dat'] = 'Ascension'
Campaign.names['4-04.dat'] = 'Aprieta'
Campaign.names['4-05.dat'] = 'Barril'
Campaign.names['4-06.dat'] = 'Plomazos'
Campaign.names['4-07.dat'] = 'Las bandanas'
Campaign.names['4-08.dat'] = 'El jardin'
Campaign.names['4-09.dat'] = 'Horizontal'
Campaign.names['4-10.dat'] = 'Desatado'
Campaign.names['4-11.dat'] = 'Te veo'
Campaign.names['4-12.dat'] = 'Hacia la banderita'
Campaign.names['4-13.dat'] = 'Sin escondite'
Campaign.names['4-14.dat'] = 'Elefante'
Campaign.names['4-15.dat'] = 'Entonces...'

Campaign.names['5-01.dat'] = 'Rojo es la sangre derramada'
Campaign.names['5-02.dat'] = 'Balistica'
Campaign.names['5-03.dat'] = 'Infiltracion'
Campaign.names['5-04.dat'] = 'Sin suelo'
Campaign.names['5-05.dat'] = 'El rapidito'
Campaign.names['5-06.dat'] = 'El lentito'
Campaign.names['5-07.dat'] = 'Balance'
Campaign.names['5-08.dat'] = 'El vuelo'
Campaign.names['5-09.dat'] = 'Abre ojos'
Campaign.names['5-10.dat'] = '007'
Campaign.names['5-11.dat'] = 'Hace calorsito no?'
Campaign.names['5-12.dat'] = 'Sube'
Campaign.names['5-13.dat'] = 'Lana sube lana baja'
Campaign.names['5-14.dat'] = 'JUSTU CLONES DE SOMBRA!!'
Campaign.names['5-15.dat'] = 'Yuppy'

Campaign.names['6-01.dat'] = 'Cutscene (boooring!)'
Campaign.names['6-02.dat'] = 'The End'
