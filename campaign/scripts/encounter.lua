-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if super and super.onInit then
		super.onInit();
	end
	Debug.console("campaign/scripts/encounter.lua - DEPRECATED - 2024-03-05");
end

function onLockChanged()
	if header.subwindow then
		header.subwindow.update();
	end
	
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());
	
	npcs_iedit.setVisible(not bReadOnly);

	npcs.setReadOnly(bReadOnly);
	for _,w in pairs(npcs.getWindows()) do
		w.count.setReadOnly(bReadOnly);
		w.token.setReadOnly(bReadOnly);
		w.name.setReadOnly(bReadOnly);
	end
end
