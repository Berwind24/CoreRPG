-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _nodeSrc = nil;

function onInit()
	_nodeSrc = window.getDatabaseNode();
	if _nodeSrc then
		local sPath = DB.getPath(_nodeSrc, "isidentified");
		DB.addHandler(sPath, "onUpdate", self.onUpdate);
	end
	self.notify();
end
function onClose()
	if _nodeSrc then
		local sPath = DB.getPath(_nodeSrc, "isidentified");
		DB.removeHandler(sPath, "onUpdate", self.onUpdate);
	end
end

function onDelete(node, sChild)
	if sChild == "isidentified" then
		self.onUpdate();
		self.notify();

		-- Re-add specific handlers, since specific handlers get cleared on specific node deletion
		local sPath = DB.getPath(_nodeSrc, "isidentified");
		DB.addHandler(sPath, "onAdd", self.onUpdate);
		DB.addHandler(sPath, "onUpdate", self.onUpdate);
	end
end
function onUpdate()
	self.notify();
end

function notify()
	if not window then
		return;
	end
	if window.onIDChanged then
		window.onIDChanged();
	elseif class then
		local bID = RecordDataManager.getIDState(class[1], _nodeSrc, ignorehost and true or false);
		window.name.setVisible(bID);
		window.nonid_name.setVisible(not bID);
	end
end
