-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if super and super.onInit then
		super.onInit();
	end
	
	if isReadOnly() then
		self.update(true);
	else
		local node = getDatabaseNode();
		if not node or DB.isReadOnly(node) then
			self.update(true);
		end
	end
end

function onListChanged()
	self.updateDisplay();
end
function updateDisplay()
	local sEdit = getName() .. "_iedit";
	if window[sEdit] then
		local bEdit = (window[sEdit].getValue() == 1);
		for _,w in ipairs(getWindows()) do
			if w.idelete then
				w.idelete.setVisible(bEdit);
			end
		end
	end
end

function update(bReadOnly, bForceHide)
	local bLocalShow;
	if bForceHide then
		bLocalShow = false;
	else
		bLocalShow = true;
		if bReadOnly and not nohide and isEmpty() then
			bLocalShow = false;
		end
	end
	
	setVisible(bLocalShow);
	setReadOnly(bReadOnly);

	local sName = getName();
	if window[sName .. "_label"] then
		window[sName .. "_label"].setVisible(bLocalShow);
	elseif window[sName .. "_header"] then
		window[sName .. "_header"].setVisible(bLocalShow);
	end
	
	local bEditMode = false;
	local cButtonEdit = window[sName .. "_iedit"];
	if cButtonEdit then
		cButtonEdit.setVisible(not bReadOnly);
		bEditMode = (cButtonEdit.getValue() ~= 0);
	end
	local cButtonAdd = window[sName .. "_iadd"];
	if cButtonAdd then
		if bReadOnly then
			cButtonAdd.setVisible(false);
		else
			cButtonAdd.setVisible(true);
		end
	end

	for _,w in ipairs(getWindows()) do
		if w.update then
			w.update(bReadOnly);
		elseif w.name then
			w.name.setReadOnly(bReadOnly);
		end
		w.idelete.setVisible(bEditMode);
	end
	
	return bLocalShow;
end
