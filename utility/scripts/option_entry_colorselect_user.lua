-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _sKey = nil;

function onInit()
	self.updateDisplay();
	UserManager.registerColorCallback(self.updateDisplay);
end
function onClose()
	UserManager.unregisterColorCallback(self.updateDisplay);
end

function initialize(sKey, tData)
	_sKey = sKey;
	
	self.updateDisplay();
	UserManager.registerColorCallback(self.updateDisplay);
end
function setLabel(s)
	label.setValue(s);
end
function setReadOnly(bReadOnly)
	-- Do nothing; user color should always be local
end

function updateDisplay()
	color.setValue(UserManager.getIdentityColor());
end
function onColorChanged(sColor)
	UserManager.setIdentityColor(sColor);
end

function onHover(bOnWindow)
	if bOnWindow then
		setFrame("rowshade");
	else
		setFrame(nil);
	end
end
function onDragStart(draginfo)
	if _sKey then
		draginfo.setType("shortcut");
		draginfo.setIcon("action_option");
		draginfo.setShortcutData("colorselect", "");
		draginfo.setDescription(label.getValue());
		return true;
	end
end
