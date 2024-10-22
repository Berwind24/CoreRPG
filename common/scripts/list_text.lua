-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onListChanged()
	self.update();
end
function update()
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

function getChildNameControl(wChild)
	return newfocus and wChild[newfocus[1]] or wChild.name;
end
function addEntry(bFocus)
	local w = createWindow();
	if bFocus then
		local cName = self.getChildNameControl(w);
		if cName then
			cName.setFocus();
		end
	end
	return w;
end
