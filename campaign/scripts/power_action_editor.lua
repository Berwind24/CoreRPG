-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	self.onTypeChanged();
end

function onTypeChanged()
	local sType = type.getValue();
	if sType ~= "" then
		local node = getDatabaseNode();
		
		title.setValue(Interface.getString("power_title_" .. sType));
		main.setValue("power_action_editor_" .. sType, node);

		if main.subwindow and main.subwindow.name then
			main.subwindow.name.setValue(DB.getValue(node, "...name", ""));
		end
	else
		title.setValue("");
		main.setValue("", "");
	end
	main.setVisible(true);
end
