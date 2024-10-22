-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	OptionsManager.registerCallback("CTSI", onOptionCTSIChanged);
	self.onOptionCTSIChanged();
end
function onClose()
	OptionsManager.unregisterCallback("CTSI", onOptionCTSIChanged);
end

function onOptionCTSIChanged()
	if label_init then
		local bShowInit = not OptionsManager.isOption("CTSI", "off");
		label_init.setVisible(bShowInit);
	end
	if list and list.onOptionCTSIChanged then
		list.onOptionCTSIChanged();
	end
end
