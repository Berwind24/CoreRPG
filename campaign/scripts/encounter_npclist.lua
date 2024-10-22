-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if super and super.onInit then
		super.onInit();
	end
	Debug.console("campaign/scripts/encounter_npclist.lua - DEPRECATED - 2024-03-05");
end

function onListChanged()
	update();
end

function update()
	local bEditMode = (window.npcs_iedit.getValue() == 1);
	if window.idelete_header then
		window.idelete_header.setVisible(bEditMode);
	end
	for _,w in ipairs(getWindows()) do
		w.idelete.setVisible(bEditMode);
	end
end

function onDrop(x, y, draginfo)
	if isReadOnly() then
		return;
	end
	
	if draginfo.isType("shortcut") then
		local sClass,sRecord = draginfo.getShortcutData();
		NPCManager.addLinkToBattle(window.getDatabaseNode(), sClass, sRecord);
		return true;
	end
end
