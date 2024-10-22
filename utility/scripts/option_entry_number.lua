-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _sKey = nil;

function onClose()
	if _sKey then
		OptionsManager.unregisterCallback(_sKey, self.onOptionChanged);
	end
end
function onOptionChanged(sKey)
	if _sKey then
		self.setOptionValue(OptionsManager.getOption(_sKey));
	end
end

function initialize(sKey, aCustom)
	_sKey = sKey;
	
	if _sKey then
		self.setOptionValue(OptionsManager.getOption(_sKey));
		OptionsManager.registerCallback(_sKey, onOptionChanged);

		if aCustom then
			value.setMinValue(aCustom.min);
			value.setMaxValue(aCustom.max);
		end
	end
end
function setReadOnly(bValue)
	value.setReadOnly(bValue);
end

function getLabel()
	return label.getValue();
end
function setLabel(s)
	label.setValue(s);
end

local _bUpdating = false;
function getOptionValue()
	return tostring(value.getValue());
end
function setOptionValue(sValue)
	_bUpdating = true;
	value.setValue(tonumber(sValue) or 0);
	_bUpdating = false;
end
function onValueChanged()
	if not _bUpdating and _sKey then
		OptionsManager.setOption(_sKey, self.getOptionValue());
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
		draginfo.setType("string");
		draginfo.setIcon("action_option");
		draginfo.setDescription(self.getLabel() .. " = " .. self.getOptionValue());
		draginfo.setStringData("/option " .. _sKey .. " " .. self.getOptionValue());
		return true;
	end
end
