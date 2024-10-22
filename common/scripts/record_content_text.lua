-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	parentcontrol.onLayoutSizeChanged = self.onParentLayoutSizeChanged;
	self.onParentLayoutSizeChanged();
end

function getTextControlName()
	return "text" or (target and target[1]);
end
function getTextControl()
	return self[self.getTextControlName()];
end

function onParentLayoutSizeChanged()
	if not self then
		return;
	end
	local c = self.getTextControl();
	if not c then
		return;
	end

	local _,hWin = parentcontrol.getSize();
	c.setAnchoredHeight(nil, hWin - 10);
end

function update()
	local c = self.getTextControl();
	if not c then
		return;
	end

	local node = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(node);
	c.setReadOnly(bReadOnly);

	if not skipid then
		local sRecordType = WindowManager.getRecordType(self);
		local bID = RecordDataManager.getIDState(sRecordType, node);
		c.setVisible(bID);
	end
end
