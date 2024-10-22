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

	space.setReadOnly(bReadOnly);
	reach.setReadOnly(bReadOnly);
	senses.setReadOnly(bReadOnly);
	
	local bSection2 = false;
	if WindowManager.callSafeControlUpdate(self, "skills", bReadOnly) then bSection2 = true; end;
	if WindowManager.callSafeControlUpdate(self, "items", bReadOnly) then bSection2 = true; end;
	if WindowManager.callSafeControlUpdate(self, "languages", bReadOnly) then bSection = true; end;
	divider2.setVisible(bSection2);
end
