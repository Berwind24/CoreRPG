-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	StoryManager.initRecordLegacyText(self);
	StoryManager.onRecordRebuild(self);
	self.update();
end

function update()
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());
	if not bReadOnly then
		StoryManager.migrateRecordLegacyTextToBlock(self);
	end
	
	for _,wBlock in pairs(blocks.getWindows()) do
		StoryManager.onBlockUpdate(wBlock, bReadOnly);
	end

	button_iadd_block_text.setVisible(not bReadOnly);
	button_iadd_block_dualtext.setVisible(not bReadOnly);
	button_iadd_block_header.setVisible(not bReadOnly);
	button_iadd_block_image.setVisible(not bReadOnly);
	button_iadd_block_textlimager.setVisible(not bReadOnly);
	button_iadd_block_textrimagel.setVisible(not bReadOnly);
end
