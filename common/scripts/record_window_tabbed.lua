-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	self.populate();
	self.onIDChanged();
end
function populate()
	local sClass = getClass();

	local sHeaderClass = header.getValue();
	if sHeaderClass == "" or sHeaderClass == "record_header" then
		local sDefaultClass = string.format("%s_header", sClass);
		if Interface.isWindowClass(sDefaultClass) then
			header.setValue(sDefaultClass, getDatabaseNode());
		end
	end

	WindowTabManager.populate(self);
end

function onLockChanged()
	self.onStateChanged();
end
function onIDChanged()
	WindowManager.updateTooltip(self);
	self.onStateChanged();
end
function onNameUpdated()
	WindowManager.updateTooltip(self);
end

function onStateChanged()
	if header and header.subwindow then
		if header.subwindow.update then
			header.subwindow.update();
		end
	end
	local tTabs = WindowTabManager.getTabsData(self);
	for _,v in ipairs(tTabs) do
		local c = self[v.sName];
		if c and c.subwindow then
			if c.subwindow.update then
				c.subwindow.update();
			end
		end
	end
end
