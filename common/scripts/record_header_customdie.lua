--
--  Please see the license.html file included with this distribution for
--  attribution and copyright information.
--

local _bInit = false;
function onInit()
	self.updateDisplay();

	local nodeActor = window.getDatabaseNode();
	DB.addHandler(DB.getPath(window.getDatabaseNode(), "customdie"), "onUpdate", self.updateDisplay);

	registerMenuItem(Interface.getString("clear"), "erase", 4);

	_bInit = true;
end
function onClose()
	local nodeActor = window.getDatabaseNode();
	DB.removeHandler(DB.getPath(window.getDatabaseNode(), "customdie"), "onUpdate", self.updateDisplay);
end

function onMenuSelection(selection)
	if selection == 4 then
		DB.setValue(window.getDatabaseNode(), "customdie", "string", "");
	end
end

function updateDisplay()
	local sDiceSkin = DB.getValue(window.getDatabaseNode(), "customdie", "");
	local tDiceSkin = DiceSkinManager.convertStringToTable(sDiceSkin);
	DiceSkinManager.setupCustomControl(self, tDiceSkin);

	if _bInit then
		window.update();
	end
end
