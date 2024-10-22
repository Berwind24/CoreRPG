-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- DEPRECATED - 2023-12-12 (Long Release) - 2024-05-28 (Chat Notice)

function onInit()
	Debug.console("list_psmain_helper: ps/scripts/ps_list.lua - DEPRECATED - 2023-12-12 - Use PartyManager.onDrop instead");
	ChatManager.SystemMessage("list_psmain_helper: ps/scripts/ps_list.lua - DEPRECATED - 2023-12-12 - Contact ruleset/extension/forge author");
end
function onDrop(x, y, draginfo)
	return PartyManager.onDrop(draginfo);
end
