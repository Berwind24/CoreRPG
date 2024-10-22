-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	self.populate();
	WindowManager.updateTooltip(self);
	self.onStateChanged();
end
function populate()
	if header then
		local sHeaderClass = header.getValue();
		if sHeaderClass == "" or sHeaderClass == "record_header" then
			local sDefaultClass = string.format("%s_header", getClass());
			if Interface.isWindowClass(sDefaultClass) then
				header.setValue(sDefaultClass, getDatabaseNode());
			end
		end
	end
	if content then
		local sContentClass = content.getValue();
		if sContentClass == "" then
			local sDefaultClass = string.format("%s_main", getClass());
			if Interface.isWindowClass(sDefaultClass) then
				content.setValue(sDefaultClass, getDatabaseNode());
			end
		end
	end
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
	
	if content and content.subwindow then
		if content.subwindow.update then
			content.subwindow.update();
		end
	elseif main and main.subwindow then
		if main.subwindow.update then
			main.subwindow.update();
		end
	end
	
	if text then
		local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());
		text.setReadOnly(bReadOnly);
	elseif notes then
		local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());
		notes.setReadOnly(bReadOnly);
	elseif description then
		local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());
		description.setReadOnly(bReadOnly);
	end
end
