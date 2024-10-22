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
	local bID = RecordDataManager.getIDState("npc", nodeRecord);

	local bSection2 = false;
	if WindowManager.callSafeControlUpdate(self, "type", bReadOnly) then bSection2 = true; end;
	divider2.setVisible(bSection2);

	space.setReadOnly(bReadOnly);
	reach.setReadOnly(bReadOnly);
	WindowManager.callSafeControlUpdate(self, "cost", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "weight", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "speed", bReadOnly);
	
	notes.setReadOnly(bReadOnly);
end
