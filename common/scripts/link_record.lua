-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onDragStart(button, x, y, draginfo)
	local sClass, sRecord = getValue();

	draginfo.setType("shortcut");
	draginfo.setIcon("button_link");
	draginfo.setShortcutData(sClass, sRecord);
	
	local sDesc = RecordDataManager.getRecordDisplayName(window.getDatabaseNode(), sClass, true);
	if sDesc == "" and window.name then
		sDesc = window.name.getValue();
	end
	draginfo.setDescription(sDesc);
	return true;
end
