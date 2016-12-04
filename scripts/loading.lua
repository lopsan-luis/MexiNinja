local startTime
local loading = {
	step = -1,
	msg = "Scripts",
	done = false,		-- set to true when everything has been loaded
}
local proverb
local source

-- Every time this function is called, the next step will be loaded.
-- Important: the loading.msg must be set to the name of the NEXT module, not the current one,
-- because love.draw gets called after love.update.
function loading.update()

	if not startTime then
		startTime = love.timer.getTime()
	end
	if loading.step == 0 then

		love.filesystem.createDirectory("userlevels")

		menu = require("scripts/menu/menu")
		parallax = require("scripts/parallax")
		BambooBox = require("scripts/bambooBox")

		-- loads all scripts and puts the necessary values into the global
		-- environment:
		keys = require("scripts/keys")
		--require("scripts/misc")
		shaders = require("scripts/shaders")

		require 'scripts/utility'
		require 'scripts/game'
		--require 'scripts/spritefactory'
		Map = require 'editor/editorMap'
		Sound = require 'scripts/sound'
		require 'scripts/sounddb'
		Sound:loadAll()
		require 'scripts/campaign'
		require 'scripts/levelEnd'
		Bridge = require 'scripts/bridge'
		objectClasses = require 'scripts/objectclasses'

		gui = require('scripts/gui')

		fader = require('scripts/fader')

		loading.msg = "Camera"
	elseif loading.step == 1 then
		Camera:applyScale()
		loading.msg = "Keyboard Setup"
	elseif loading.step == 2 then
		keys.load()
		loading.msg = "Gamepad Setup"
	elseif loading.step == 3 then
		keys.loadGamepad()
		loading.msg = "Menu"
	elseif loading.step == 4 then
		gui.init()
		menu:init()	-- must be called after AnimationDB:loadAll()
		--BambooBox:init()
		upgrade = require("scripts/upgrade")
		love.keyboard.setKeyRepeat( true )
		loading.msg = "Shaders"
	elseif loading.step == 5 then
		if settings:getShadersEnabled() then
			shaders.load()
		end
		loading.msg = "Editor"
	elseif loading.step == 6 then
		editor = require("editor/editor")
		editor.init()
		loading.msg = "Campaign"
	elseif loading.step == 7 then
		recorder = false
		screenshots = {}
		recorderTimer = 0
		timer = 0
		Campaign:init()
		Campaign.bandana = config.getValue("bandana") or 'blank'
		loading.msg = "Shadows"
	elseif loading.step == 8 then
		shadows = require("scripts/monocle")
		loading.msg = "Levels"
	elseif loading.step == 9 then
		levelEnd:init()	-- must be called AFTER requiring the editor
		loading.msg = "Menu"
	elseif loading.step == 10 then
		loading.done = true
		-- temporary
		--springtime = love.graphics.newImage('images/transition/silhouette.png')
		--bg_test = love.graphics.newImage('images/menu/bg_main.png')

	threadInterface.new( "version info",	-- thread name (only used for printing debug messages)
		"scripts/levelsharing/get.lua",	-- thread script
		"get",	-- function to call (inside script)
		menu.downloadedVersionInfo, nil,	-- callback events when done
		-- the following are arguments passed to the function:
		"version.php" )
	end
	if loading.done and love.timer.getTime() > startTime + 5 then
		menu:switchToSubmenu( "Main" )
		menu:show()
	end
	loading.step = loading.step + 1
end

function loading.draw()
	--os.execute("sleep .5")
	love.graphics.setColor(colors.white)
	local str = "Loading: " .. loading.msg
	--print(str)
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()

	if not loading.done then
		love.graphics.setColor(colors.grayText)
		love.graphics.setFont(fontSmall)
		love.graphics.print(str, math.floor(Camera.scale*5), math.floor(love.graphics.getHeight()-Camera.scale*8))
	end

	local width, lines = fontLarge:getWrap(proverb, 0.6*w)
	lines = #lines
	local textH = fontLarge:getHeight() * lines

	love.graphics.setColor(colors.blueText)
	love.graphics.setFont(fontLarge)
	love.graphics.printf(proverb, math.floor(0.2*w), math.floor(0.5*h-0.5*textH), 0.6*w, 'center')

	love.graphics.setColor(colors.grayText)
	love.graphics.setFont(fontSmall)
	love.graphics.printf(source, math.floor(0.5*w-0.5*width), math.floor(0.5*h + textH * 1), width,'right')

	if loading.done then
		love.graphics.printf( "Any Key to Start",
			math.floor(0.2*w), math.floor(love.graphics.getHeight()-Camera.scale*8),
			0.6*w, 'center' )
	end
end

function loading.preload()
-- This function does everything that is necessary before the loading
-- screen can be shown: Set graphical mode and load font.
	settings:loadAll()
	Camera:init()
	loadFont()

	-- hide mouse
	love.mouse.setVisible(false)

	local proverbs = {
	{"No hay mal que por bien no venga.",'Dicho Mexicano'},
	{"Es mejor morir de pie que de rodillas.",'Emiliano Zapata'},
	{"La indiferencia del Mexicano ante la muerte,\n se nutre de su indiferencia ante la vida.",'Octavio Paz'},
	{"No sigas proverbios ciegamente!",'Viejo proverbio Japones'},
	{"Si caes ocho veces,\n levantate nueve.",'Proverbio'},
	{"A fuerza, ni los zapatos entran.",'Dicho Mexicano'},
	{"Lo dificl lo hago de inmediato,\n lo imposible me tardo un poquito mas",'Cantinflas'},
	{"Many skills is no skill",'Proverb'},
	{"Para que tanto brinco,\n estando el suelo tan parejo?",'Dicho Mexicano'},
	{"Nunca dije la ni la mitad\n de las cosas que dicen que dije",'Buddha'},
	}
	local nr = love.math.random(#proverbs)
	proverb = proverbs[nr][1]
	source = proverbs[nr][2]

	mode = 'loading'
end

function loading.keypressed()
	if loading.done then
		menu:switchToSubmenu( "Main" )
		menu:show()
	end
end

return loading
