-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local bUpdating = false;

function onInit()
	super.onInit();

	onObserverUpdated();
	local sPath = DB.getPath(getDatabaseNode());
	DB.addHandler(sPath, "onObserverUpdate", onObserverUpdated);
end
function onClose()
	local sPath = DB.getPath(getDatabaseNode());
	DB.removeHandler(sPath, "onObserverUpdate", onObserverUpdated);
end

function onObserverUpdated()
	local node = getDatabaseNode();
	
	owner.setValue(DB.getOwner(node));
	
	if not bUpdating then
		bUpdating = true;

		if DB.isPublic(node) then
			ispublic.setValue(1);
		else
			ispublic.setValue(0);
		end
		
		bUpdating = false;
	end
end

function onPublicChanged()
	if not bUpdating then
		bUpdating = true;
		DB.setPublic(getDatabaseNode(), (ispublic.getValue() == 1));
		bUpdating = false;
	end
end

function update()
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());
	name.setReadOnly(bReadOnly);
	ispublic.setReadOnly(bReadOnly);
end
