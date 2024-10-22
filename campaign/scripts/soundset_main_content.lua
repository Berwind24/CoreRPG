--
--  Please see the license.html file included with this distribution for
--  attribution and copyright information.
--

function onInit()
	self.onSubtypeChanged();
end

function onSubtypeChanged()
	local nodeRecord = getDatabaseNode();

	local sSubtype = DB.getValue(nodeRecord, "subtype", "");
	if sSubtype == "story" then
		subtype_stats.setValue("soundset_main_content_story", nodeRecord);
	elseif sSubtype == "image" then
		subtype_stats.setValue("soundset_main_content_image", nodeRecord);
	elseif sSubtype == "npc" then
		subtype_stats.setValue("soundset_main_content_npc", nodeRecord);
	else
		subtype_stats.setValue("", "");
	end

	subtype_stats.update(WindowManager.getReadOnlyState(nodeRecord));
end

function update()
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());

	subtype.setReadOnly(bReadOnly);
	subtype_stats.update(bReadOnly);
end
