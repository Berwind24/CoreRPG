-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _sKey = nil;
local _sButtonClass = nil;
local _sButtonPath = nil;

function initialize(sKey, tData)
	_sKey = sKey;
	
	if _sKey then
		if tData then
			_sButtonClass = tData.buttonclass;
			_sButtonPath = tData.buttonpath;
			button.setStateText(0, Interface.getString(tData.buttonlabelres));
		end
		self.setOptionValue(OptionsManager.getOption(_sKey));
		OptionsManager.registerCallback(_sKey, self.onOptionChanged);
	end
end
function onOptionChanged(sKey)
	if _sKey then
		self.setOptionValue(OptionsManager.getOption(_sKey));
	end
end
function onClose()
	if _sKey then
		OptionsManager.unregisterCallback(_sKey, self.onOptionChanged);
	end
end

function setLabel(s)
	label.setValue(s);
end
function setReadOnly(bReadOnly)
	checkbox.setReadOnly(bReadOnly);
	button.setVisible(not bReadOnly);
	if bReadOnly then
		checkbox.setAnchor("right", nil, "right", "absolute", -58);
	else
		checkbox.setAnchor("right", nil, "right", "absolute", -105);
	end
end

local _bUpdating = false;
function getOptionValue()
	if checkbox.getValue() ~= 0 then
		return "on";
	end
	return "off";
end
function setOptionValue(sValue)
	_bUpdating = true;

	if sValue == "on" then
		checkbox.setValue(1);
	else
		checkbox.setValue(0);
	end

	_bUpdating = false;
end
function onValueChanged()
	if not _bUpdating and _sKey then
		OptionsManager.setOption(_sKey, getOptionValue());
	end
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
		local sValue = self.getOptionValue();

		draginfo.setType("string");
		draginfo.setIcon("action_option");
		draginfo.setDescription(string.format("%s = %s", label.getValue(), Interface.getString("option_val_" .. sValue)));
		draginfo.setStringData(string.format("/option %s %s", _sKey, sValue));
		return true;
	end
end
function onButtonPress()
	if _sButtonClass then
		Interface.openWindow(_sButtonClass, _sButtonPath or "");
	end
end
