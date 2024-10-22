-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if Session.IsHost then
		registerMenuItem(Interface.getString("list_menu_createitem"), "insert", 5);
	end
end
function onMenuSelection(selection)
	if selection == 5 then
		self.addEntry();
	end
end
function addEntry()
	return DB.createChild(window.getDatabaseNode());
end

function onListChanged()
	WindowManager.callOuterWindowFunction(window, "onListChanged");
end

function onDrop(x, y, draginfo)
	if Session.IsHost then
		if draginfo.getType() == "number" then
			local node = addEntry(true);
			if node then
				DB.setValue(node, "label", "string", draginfo.getDescription());
				DB.setValue(node, "bonus", "number", draginfo.getNumberData());
			end
			return true;
		end
	end
end
