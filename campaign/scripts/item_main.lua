-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	self.update();
end
function VisDataCleared()
	self.update();
end
function InvisDataAdded()
	self.update();
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID = RecordDataManager.getIDState("item", nodeRecord);
	
	if sub_nonid then
		sub_nonid.update(bReadOnly, bID);
	end
	if sub_standard then
		sub_standard.update(bReadOnly, bID);
	end
	if sub_type then
		sub_type.update(bReadOnly, bID);
	end
	
	if notes then
		notes.setVisible(bID);
		notes.setReadOnly(bReadOnly);
	end
	if description then
		description.setVisible(bID);
		description.setReadOnly(bReadOnly);
	end
		
	if sub_pack then
		sub_pack.update(bReadOnly, bID);
	end
end

-- Backward compatibility for Savage Worlds (remove once updated)
function updateControl(sControl, bReadOnly, bID)
	WindowManager.callSafeControlUpdate(self, sControl, bReadOnly, not bID);
end

function onDrop(x, y, draginfo)
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	if bReadOnly then
		return false;
	end
	return ItemManager.handleAnyDropOnItemRecord(nodeRecord, draginfo);
end
