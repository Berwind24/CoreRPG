-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _sID = nil;

function getID()
	return _sID;
end

function setData(nOrder, sID)
	_sID = sID;
	order.setValue(nOrder);
	name.setValue(Interface.getString("diceskin_group_" .. sID));
	name.setColor("FF808080");
	button_store.productid = { DiceSkinManager.getDiceSkinGroupStoreID(sID) };
end
function setOwned()
	if owned.getValue() == 0 then
		owned.setValue(1);
		name.setColor(nil);
		button_store.setVisible(false);
		self.toggleVisibility();
	end
end

function toggleVisibility()
	list.setVisible(not list.isVisible());
	status.setValue(list.isVisible() and 0 or 1);
end
