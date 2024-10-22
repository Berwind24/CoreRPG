-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	addHandler(getDatabaseNode());
end
function onClose()
	removeHandler();
end

local _node;
function addHandler(node)
	if node then
		_node = node;
		DB.addHandler(_node, "onDelete", onDelete);
	end
end
function removeHandler()
	if _node then
		DB.removeHandler(_node, "onDelete", onDelete);
		_node = nil;
	end
end
function onDelete(node)
	ItemManager.onCharRemoveEvent(node);
	removeHandler();
end
