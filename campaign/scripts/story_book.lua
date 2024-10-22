-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	self.updateTitle();
	self.updateIndexHelperControls();
end

function onLockChanged()
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());
	if sub_index.subwindow then
		sub_index.subwindow.update(bReadOnly, true);
	end

	filter.setValue("");
	self.updateIndexHelperControls();
end

function showIndex(bShow)
	frame_index.setVisible(bShow);
	sub_index.setVisible(bShow);

	self.updateIndexHelperControls();
end

function updateTitle()
	local tModuleInfo = Module.getModuleInfo(DB.getModule(getDatabaseNode()));
	local sModuleDisplay = tModuleInfo and tModuleInfo.displayname or Interface.getString("campaign");
	local sTitle = string.format("%s - %s", Interface.getString("library_recordtype_single_story_book"), sModuleDisplay);
	title.setValue(sTitle);
	setTooltipText(sTitle);
end
function updateIndexHelperControls()
	local bIndexVisible = sub_index.isVisible();
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());

	button_index_expand.setVisible(bIndexVisible and bReadOnly);
	button_index_collapse.setVisible(bIndexVisible and bReadOnly);
	filter.setVisible(bIndexVisible and bReadOnly);
end

function handlePageTop()
	local _, sPath = content.getValue();
	StoryManager.handlePageTop(self, sPath);
end
function handlePagePrev()
	local _, sPath = content.getValue();
	StoryManager.handlePagePrev(self, sPath);
end
function handlePageNext()
	local _, sPath = content.getValue();
	StoryManager.handlePageNext(self, sPath);
end
