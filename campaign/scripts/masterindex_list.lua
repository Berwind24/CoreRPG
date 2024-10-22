-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onMenuSelection(selection)
	if selection == 5 then
		window.addEntry(true);
	end
end

function onListChanged()
	window.onListChanged();
end

function onSortCompare(w1, w2)
	return window.onSortCompare(w1, w2);
end

function onDrop(x, y, draginfo)
	local vReturn = nil;
	if draginfo.isType("shortcut") or (draginfo.isType("token") and draginfo.getShortcutData()) then
		vReturn = CampaignDataManager.handleDrop(window.getRecordType(), draginfo);
	elseif draginfo.isType("file") then
		vReturn = CampaignDataManager.handleFileDrop(window.getRecordType(), draginfo);
	elseif StringManager.contains({ "image", "portrait", "token" }, draginfo.getType()) then
		vReturn = CampaignDataManager.handleImageAssetDrop(window.getRecordType(), draginfo);
	end
	return vReturn;
end
