-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if Session.IsHost then
		nonid_name.resetAnchor("left");
		nonid_name.setAnchor("left", nil, "center", "absolute", 22);
		self.onLayoutSizeChanged = self.update;
	end
	self.update();
end

function update()
	local nodeRecord = getDatabaseNode();

	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	name.setReadOnly(bReadOnly);
	nonid_name.setReadOnly(bReadOnly);
	
	local bID = RecordDataManager.getIDState("image", nodeRecord);
	if Session.IsHost then
		local bShow = true;
		if bReadOnly and nonid_name.getValue() == "" then
			bShow = false;
		else
			local w,h = getSize();
			bShow = (w >= 500);
		end
		nonid_icon.setVisible(bShow);
		nonid_name.setVisible(bShow);
	else
		name.setVisible(bID);
		nonid_name.setVisible(not bID);
	end
end
