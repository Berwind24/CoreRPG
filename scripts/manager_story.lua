-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

DEFAULT_BOOK_INDEX = "reference.refmanualindex";
DEFAULT_BOOK_CONTENT = "reference.refmanualdata";

DEFAULT_BOOK_INDEX_CHAPTER_LIST = "chapters";
DEFAULT_BOOK_INDEX_SECTION_LIST = "subchapters";
DEFAULT_BOOK_INDEX_PAGE_LIST = "refpages";

-- NOTE: Assume that only one manual exists per module
-- NOTE: Assume that the reference manual exists in a specific location in each module
--			(unless alternate read-only location specified)

function onTabletopInit()
	StoryManager.registerCopyPasteToolbarButtons();

	StoryManager.initStoryIndex();
	StoryManager.initBookPaths();
end

--
--	STORY - DATA - INDEX
--

function initStoryIndex()
	local tMappings = RecordDataManager.getDataPaths("story");
	for _,sMapping in ipairs(tMappings) do
		DB.addHandler(DB.getPath(sMapping, "*@*"), "onAdd", StoryManager.onStoryRecordAdd);
		DB.addHandler(DB.getPath(sMapping, "*@*"), "onDelete", StoryManager.onStoryRecordDelete);
		DB.addHandler(DB.getPath(sMapping, "*@*"), "onCategoryChange", StoryManager.onStoryRecordCategoryChange);
		DB.addHandler(DB.getPath(sMapping, "*.name@*"), "onUpdate", StoryManager.onStoryRecordRename);
	end

	local sPath = string.format("%s.*@*", StoryManager.DEFAULT_BOOK_CONTENT);
	DB.addHandler(sPath, "onIntegrityChange", StoryManager.onStoryAdvancedRecordIntegrityChange);
end
function onStoryRecordAdd(node)
	StoryManager.addStoryIndexRecord(node);
end
function onStoryRecordDelete(node)
	StoryManager.removeStoryIndexRecord(node);
	if DB.getModule(node) == "" then
		StoryManager.deleteBookIndexRecordByTargetRecord(DB.getPath(node));
	end
end
function onStoryRecordCategoryChange(node)
	StoryManager.updateStoryIndexRecordCategory(node);
end
function onStoryRecordRename(nodeName)
	StoryManager.updateStoryIndexRecordName(DB.getParent(nodeName));
end
function onStoryAdvancedRecordIntegrityChange(node)
	StoryManager.onRecordNodeRebuild(node);
end

local _tStoryRecords = {};
function getStoryIndex(sModule, bInit)
	local tRecords = _tStoryRecords[sModule or ""];
	if not tRecords then
		if bInit then
			tRecords = {};
			_tStoryRecords[sModule or ""] = tRecords;
			RecordManager.callForEachModuleRecord("story", sModule, StoryManager.addStoryIndexRecord);
		else
			return;
		end
	end
	return tRecords;
end
function addStoryIndexRecord(node, bInit)
	if not node then
		return;
	end

	local sModule = DB.getModule(node);
	local tRecords = StoryManager.getStoryIndex(sModule, bInit);
	if not tRecords then
		return;
	end
	
	local tRecord = {};
	tRecord.vNode = node;
	tRecord.sCategory = DB.getCategory(node);
	tRecord.sDisplayName = DB.getValue(node, "name", "");
	tRecord.sDisplayNameLower = Utility.convertStringToLower(tRecord.sDisplayName);
	tRecords[node] = tRecord;
end
function removeStoryIndexRecord(node)
	local sModule = DB.getModule(node);
	local tRecords = StoryManager.getStoryIndex(sModule);
	if not tRecords then
		return;
	end

	tRecords[node] = nil;
end
function updateStoryIndexRecordCategory(node)
	local sModule = DB.getModule(node);
	local tRecords = StoryManager.getStoryIndex(sModule);
	if not tRecords then
		return;
	end
	local tRecord = tRecords[node];
	if not tRecord then
		return;
	end
	tRecord.sCategory = DB.getCategory(node);
end
function updateStoryIndexRecordName(node)
	local sModule = DB.getModule(node);
	local tRecords = StoryManager.getStoryIndex(sModule);
	if not tRecords then
		return;
	end
	local tRecord = tRecords[node];
	if not tRecord then
		return;
	end
	tRecord.sDisplayName = DB.getValue(node, "name", "");
	tRecord.sDisplayNameLower = Utility.convertStringToLower(tRecord.sDisplayName);
end

function rebuildStoryPageIndexes(sModule)
	StoryManager.rebuildBookIndex(sModule);
	StoryManager.rebuildNonBookIndex(sModule);
end

-- NOTE: Book pages are added via index order; so no need to sort additionally
function rebuildBookIndex(sModule)
	local sIndexPath = StoryManager.getBookIndexPath(sModule);
	if not sIndexPath then
		return;
	end

	local tBookPages = StoryManager.clearBookPages(sModule);
	for _,nodeChapter in ipairs(UtilityManager.getSortedNodeList(DB.getChildList(sIndexPath), { "order" })) do
		for _,nodeSection in ipairs(UtilityManager.getSortedNodeList(DB.getChildList(nodeChapter, StoryManager.DEFAULT_BOOK_INDEX_SECTION_LIST), { "order" })) do
			for _,nodePage in ipairs(UtilityManager.getSortedNodeList(DB.getChildList(nodeSection, StoryManager.DEFAULT_BOOK_INDEX_PAGE_LIST), { "order" })) do
				local sClass, sRecord = DB.getValue(nodePage, "listlink", "", "");
				if sRecord ~= "" then
					table.insert(tBookPages, { sPageRecord = DB.getPath(nodePage), sTargetRecord = sRecord, });
				end
			end
		end
	end
end
local _tBookIndexPath = {};
function getBookIndexPath(sModule)
	if not _tBookIndexPath[sModule or ""] then
		local node = StoryManager.getModuleBookRecordNode(sModule);
		if node then
			_tBookIndexPath[sModule or ""] = DB.getPath(node, StoryManager.DEFAULT_BOOK_INDEX_CHAPTER_LIST);
		else
			_tBookIndexPath[sModule or ""] = string.format("%s@%s", DB.getPath(StoryManager.DEFAULT_BOOK_INDEX, StoryManager.DEFAULT_BOOK_INDEX_CHAPTER_LIST), sModule or "");
		end
	end
	return _tBookIndexPath[sModule or ""];
end
local _tBookPages = {};
function getBookPages(sModule)
	return _tBookPages[sModule or ""] or {};
end
function clearBookPages(sModule)
	_tBookPages[sModule or ""] = {};
	return _tBookPages[sModule or ""];
end
function isBookRecord(sModule, sRecord, bRebuild)
	if bRebuild then
		StoryManager.rebuildBookIndex(sModule);
	end
	local tBookPages = StoryManager.getBookPages(sModule);
	for _,v in ipairs(tBookPages) do
		if v.sTargetRecord == sRecord then
			return true;
		end
	end
	return false;
end
function deleteBookIndexRecordByTargetRecord(sRecord)
	local sModule = DB.getModule(sRecord) or "";
	StoryManager.rebuildBookIndex(sModule);
	local tBookPages = StoryManager.getBookPages(sModule);
	for kPage,v in ipairs(tBookPages) do
		if v.sTargetRecord == sRecord then
			DB.deleteNode(v.sPageRecord);
			table.remove(tBookPages, kPage);
			break;
		end
	end
end

-- NOTE: Non-book pages are added in any order; so additional sort needed
function rebuildNonBookIndex(sModule)
	local tRecords = StoryManager.getStoryIndex(sModule, true);
	local tModulePages = StoryManager.clearNonBookPages(sModule);
	for k,v in pairs(tRecords) do
		if not StoryManager.isBookRecord(sModule, DB.getPath(k)) then
			local sCategory = DB.getCategory(v.vNode);
			tModulePages[sCategory] = tModulePages[sCategory] or {};
			table.insert(tModulePages[sCategory], v);
		end
	end
	for _,tPages in pairs(tModulePages) do
		table.sort(tPages, StoryManager.sortFuncStoryIndex);
	end
end
local _tNonBookPages = {};
function getNonBookPages(sModule, sCategory)
	if not _tNonBookPages[sModule or ""] then
		return {};
	end
	return _tNonBookPages[sModule or ""][sCategory or ""] or {};
end
function clearNonBookPages(sModule)
	_tNonBookPages[sModule or ""] = {};
	return _tNonBookPages[sModule or ""];
end
function sortFuncStoryIndex(a, b)
	if a.sDisplayNameLower ~= b.sDisplayNameLower then
		return a.sDisplayNameLower < b.sDisplayNameLower;
	end

	return DB.getPath(a.vNode) < DB.getPath(b.vNode);
end

function getStoryPrevRecord(sModule, sRecord, bRebuild)
	if bRebuild then
		StoryManager.rebuildStoryPageIndexes(sModule);
	end
	
	local tBookPages = StoryManager.getBookPages(sModule);
	for kPage,v in ipairs(tBookPages) do
		if v.sTargetRecord == sRecord then
			if tBookPages[kPage - 1] then
				return tBookPages[kPage - 1].sTargetRecord;
			else
				return nil;
			end
		end
	end
	
	local sCategory = DB.getCategory(sRecord);
	local tNonBookPages = StoryManager.getNonBookPages(sModule, sCategory);
	for kPage,v in ipairs(tNonBookPages) do
		if DB.getPath(v.vNode) == sRecord then
			if tNonBookPages[kPage - 1] then
				return DB.getPath(tNonBookPages[kPage - 1].vNode);
			else
				return nil;
			end
		end
	end
	return nil;
end
function getStoryNextRecord(sModule, sRecord, bRebuild)
	if bRebuild then
		StoryManager.rebuildStoryPageIndexes(sModule);
	end

	local tBookPages = StoryManager.getBookPages(sModule);
	for kPage,v in ipairs(tBookPages) do
		if v.sTargetRecord == sRecord then
			if tBookPages[kPage + 1] then
				return tBookPages[kPage + 1].sTargetRecord;
			else
				return nil;
			end
		end
	end
	
	local sCategory = DB.getCategory(sRecord);
	local tNonBookPages = StoryManager.getNonBookPages(sModule, sCategory);
	for kPage,v in ipairs(tNonBookPages) do
		if DB.getPath(v.vNode) == sRecord then
			if tNonBookPages[kPage + 1] then
				return DB.getPath(tNonBookPages[kPage + 1].vNode);
			else
				return nil;
			end
		end
	end
	return nil;
end

--
--	GENERAL - THEMING
--

local _nTextFrameOffsetX = 25;
local _nTextFrameOffsetY = 35;
local _nTextWithFrameOffsetX = 35;
local _nTextSansFrameOffsetX = 20;

local _nHeaderFrameOffsetX = 20;
local _nHeaderFrameOffsetY = 20;
local _nHeaderWithFrameOffsetY = 20;
local _nHeaderWithFrameOffsetX = 30;
local _nHeaderSansFrameOffsetX = 20;
local _nHeaderSansFrameOffsetY = 0;

local _nGraphicOffsetX = 35;

local _nMinImageWidth = 100;
local _nMaxSingleImageWidth = 600;
local _nMaxColumnImageWidth = 300;

local _sBlockTextEditBackColor = "18000000";

local _sBlockIconColor = "000000";
function setBlockButtonIconColor(s)
	_sBlockIconColor = s;
end
function getBlockButtonIconColor()
	return _sBlockIconColor;
end

--
--	GENERAL - THEMING - FRAMES
--

local _tBlockFrames = {
	"sidebar",
	"text1",
	"text2",
	"text3",
	"text4",
	"text5",
	"book",
	"page",
	"picture",
	"pink",
	"blue",
	"brown",
	"green",
	"yellow",
};

function getBlockFrames()
	return _tBlockFrames;
end
function addBlockFrame(sName)
	if (sName or "") == "" then
		return;
	end
	for _,s in ipairs(_tBlockFrames) do
		if sName == s then
			return;
		end
	end
	table.insert(_tBlockFrames, sName);
end
function removeBlockFrame(sName)
	if (sName or "") == "" then
		return;
	end
	for k,s in ipairs(_tBlockFrames) do
		if sName == s then
			table.remove(_tBlockFrames, k);
			return;
		end
	end
end

--
--	GENERAL - PAGE CONTROLS
--

function updatePageSub(cSub, sRecord)
	if not cSub or not cSub.subwindow then
		return;
	end

	local sModule = DB.getModule(sRecord);

	StoryManager.rebuildStoryPageIndexes(sModule);

	local bBookRecord = StoryManager.isBookRecord(sModule, sRecord);
	local sPrevPath = StoryManager.getStoryPrevRecord(sModule, sRecord) or "";
	local sNextPath = StoryManager.getStoryNextRecord(sModule, sRecord) or "";

	if not bBookRecord and (sPrevPath == "") and (sNextPath == "") then
		cSub.setVisible(false);
		return;
	end

	cSub.setVisible(true);
	cSub.subwindow.page_top.setVisible(bBookRecord and (UtilityManager.getTopWindow(cSub.subwindow).getClass() ~= "reference_manual"));
	cSub.subwindow.page_prev.setVisible(sPrevPath ~= "");
	cSub.subwindow.page_next.setVisible(sNextPath ~= "");
end

function handlePageTop(w, sRecord)
	if (sRecord or "") == "" then
		return;
	end
	local sModule = DB.getModule(sRecord);
	local wBook = StoryManager.openBook(sModule);
	if wBook then
		StoryManager.activateLink(wBook, w.getClass(), sRecord);
	end
end
function handlePagePrev(w, sRecord)
	if (sRecord or "") == "" then
		return;
	end
	local sModule = DB.getModule(sRecord);
	local sPrevPath = StoryManager.getStoryPrevRecord(sModule, sRecord, true) or "";
	if sPrevPath ~= "" then
		StoryManager.activateLink(w, nil, sPrevPath);
	end
end
function handlePageNext(w, sRecord)
	if (sRecord or "") == "" then
		return;
	end
	local sModule = DB.getModule(sRecord);
	local sNextPath = StoryManager.getStoryNextRecord(sModule, sRecord, true) or "";
	if sNextPath ~= "" then
		StoryManager.activateLink(w, nil, sNextPath);
	end
end

--
--	GENERAL - LINK HANDLING
--

function onLinkActivated(w, sClass, sRecord)
	local wTop = UtilityManager.getTopWindow(w);
	local sTopClass = wTop.getClass();
	if sTopClass == "reference_manual" then
		StoryManager.activateLink(w, sClass, sRecord, Input.isShiftPressed());
	else
		StoryManager.activateLink(w, sClass, sRecord, true);
	end
end
function activateLink(w, sClass, sRecord, bPopOut)
	local wTop = UtilityManager.getTopWindow(w);
	local sTopClass = wTop.getClass();
	if (sTopClass ~= "reference_manual") then
		local tRecordTypes = RecordDataManager.getAllRecordTypesFromDisplayClass(sTopClass);
		if not StringManager.contains(tRecordTypes, "story") then
			if sClass then
				Interface.openWindow(sClass, sRecord);
			end
			return;
		end
	end

	if not sClass then
		sClass = RecordDataManager.getRecordTypeDisplayClass(RecordDataManager.getRecordTypeFromRecordPath(sRecord), sRecord);
	end
	if (sClass or "") == "" then
		-- Handle special legacy case of embedded reference manual page data
		if StoryManager.isBookRecord(DB.getModule(sRecord), sRecord, true) then
			sClass = "referencemanualpage";
		else
			return;
		end
	end
	if sClass == "reference_manualtextwide" then
		sClass = "referencemanualpage";
	end

	if sTopClass == "reference_manual" then
		local sModule = DB.getModule(sRecord);
		if (sModule ~= "") and (sModule ~= DB.getModule(w.getDatabaseNode())) then
			if StoryManager.isBookRecord(sModule, sRecord, true) then
				local wNew = Interface.openWindow("reference_manual", string.format("%s@%s", StoryManager.DEFAULT_BOOK_INDEX, sModule));
				StoryManager.activateLink(wNew, sClass, sRecord);
				return;
			end
			StoryManager.openLinkInNewWindow(sClass, sRecord);
			return;
		end
	end

	if bPopOut then
		StoryManager.openLinkInNewWindow(sClass, sRecord);
	else
		StoryManager.activateEmbeddedLink(wTop, sClass, sRecord);
	end
end
function activateEmbeddedLink(w, sClass, sRecord)
	local bManual = (w.getClass() == "reference_manual");

	if not bManual or (sClass ~= "story_book_page_simple" and sClass ~= "story_book_page_advanced") then
		local sRecordType = RecordDataManager.getRecordTypeFromDisplayClass(sClass);
		if sRecordType ~= "story" then
			if (sClass or "") ~= "" then
				Interface.openWindow(sClass, sRecord);
			end
			return;
		end
	end

	if w.getClass() == "reference_manual" then
		local _, sCurrentRecord = w.content.getValue();
		if (sCurrentRecord or "") ~= sRecord then
			if sClass == "encounter" then
				w.content.setValue("story_book_page_simple", sRecord);
			else
				w.content.setValue("story_book_page_advanced", sRecord);
			end
		end
		w.content.setVisible(true);

		StoryManager.updatePageSub(w.sub_paging, sRecord);

		SoundsetManager.updateStoryContext();
	else
		local wNew = Interface.openWindow(sClass, sRecord);
		if wNew and (w.getDatabaseNode() ~= wNew.getDatabaseNode()) then
			local nWinX,nWinY = w.getPosition();
			local nWinW,nWinH = w.getSize();
			wNew.setPosition(nWinX, nWinY);
			wNew.setSize(nWinW, nWinH);
			w.close();
		end
	end
end
function openLinkInNewWindow(sClass, sRecord)
	if StringManager.contains({ "story_book_page_advanced", "reference_manualtextwide", }, sClass) then
		sClass = "referencemanualpage";
	elseif sClass == "story_book_page_simple" then
		sClass = "encounter";
	end
	Interface.openWindow(sClass, sRecord);
end

--
--	GENERAL - UTILITY
--

function getWindowOrderValue(w)
	return DB.getValue(w.getDatabaseNode(), "order", 0);
end
function setWindowOrderValue(w, nOrder)
	DB.setValue(w.getDatabaseNode(), "order", "number", nOrder);
end

function updateOrderValues(cList)
	local tChildRecords = {};
	for _,wChild in ipairs(cList.getWindows()) do
		local nodeChild = wChild.getDatabaseNode();
		table.insert(tChildRecords, { win = wChild, sName = DB.getName(nodeChild), nOrder = DB.getValue(nodeChild, "order", 0) });
	end
 	table.sort(tChildRecords, function (a, b) if a.nOrder ~= b.nOrder then return a.nOrder < b.nOrder; end return a.sName < b.sName end);

 	local tResults = {};
 	for kChildWinRecord,tChildWinRecord in ipairs(tChildRecords) do
 		if tChildWinRecord.nOrder ~= kChildWinRecord then
			StoryManager.setWindowOrderValue(tChildWinRecord.win, kChildWinRecord);
 		end
 		tResults[kChildWinRecord] = tChildWinRecord.win;
 	end
 	return tResults;
end

--
--	BOOK - DATA - INDEX
--

local _tBookPaths = {};
function initBookPaths()
	StoryManager.addBookPath(StoryManager.DEFAULT_BOOK_INDEX);
end
function getBookPaths()
	return _tBookPaths;
end
function addBookPath(s)
	if (s or "") == "" then
		return;
	end
	table.insert(_tBookPaths, s);
end

function getBookRecordNodes()
	local tResults = {};
	for _,sModule in ipairs(Module.getModules()) do
		local node = StoryManager.getModuleBookRecordNode(sModule);
		if node then
			table.insert(tResults, node);
		end
	end
	return tResults;
end
function getModuleBookRecordNode(sModule)
	for _,sPath in ipairs(StoryManager.getBookPaths()) do
		local node = DB.findNode(string.format("%s@%s", sPath, sModule or ""));
		if node then
			return node;
		end
	end
	return nil;
end

--
--	BOOK - UI - INDEX EDIT/DROP
--

function openBook(sModule)
	local node = StoryManager.getModuleBookRecordNode(sModule);
	if not node then
		if Session.IsHost and (sModule or "") == "" then
			node = DB.createNode(StoryManager.DEFAULT_BOOK_INDEX);
		end
		if not node then
			return nil;
		end
	end
	return Interface.openWindow("reference_manual", node);
end

function onBookIndexAdd(w)
	local nodeList = w.list.getDatabaseNode();
	if not nodeList or DB.isStatic(nodeList) then
		return;
	end

	local sClass = w.getClass();
	if sClass == "story_book_index" then
		local wChapter = StoryManager.onBookIndexAddEndHelper(w.list);
		if wChapter then
			wChapter.name.setFocus();
		end
	elseif sClass == "story_book_index_chapter" then
		local wSection = StoryManager.onBookIndexAddEndHelper(w.list);
		if wSection then
			wSection.name.setFocus();
		end
	elseif sClass == "story_book_index_section" then
		local wRecord = StoryManager.onBookIndexAddEndHelper(w.list);
		if wRecord then
			local sContentPath = StoryManager.DEFAULT_BOOK_CONTENT;
			local nodePage = DB.createChild(sContentPath);
			wRecord.setLink("story_book_page_advanced", DB.getPath(nodePage));
			wRecord.name.setFocus();
		end
	end
end
function onBookIndexAddEndHelper(cList)
	local nCount = #(StoryManager.updateOrderValues(cList));
	return StoryManager.onBookIndexAddHelper(cList, nCount + 1);
end
function onBookIndexAddHelper(cList, nOrder)
	local wAdd = cList.createWindow();
	StoryManager.setWindowOrderValue(wAdd, nOrder);
	return wAdd;
end

function onBookIndexDelete(w)
	local node = w.getDatabaseNode();
	if not node or DB.isStatic(node) then
		return;
	end
	if w.getClass() == "story_book_index_page" then
		local wTop = UtilityManager.getTopWindow(w);
		if wTop.getClass() == "reference_manual" then
			local _, sPath = wTop.content.getValue();
			if sPath ~= "" then
				local _, sLinkPath = w.listlink.getValue();
				if sLinkPath == sPath then
					wTop.content.setValue("", "");
				end
			end
		end
	end
	DB.deleteNode(node);
end

function onBookIndexMoveUp(w)
	local cParentList = w.windowlist;
	local nodeList = cParentList.getDatabaseNode();
	if not nodeList or DB.isStatic(nodeList) then
		return;
	end
	local tOrderedChildren = StoryManager.updateOrderValues(cParentList);

	local sClass = w.getClass();
	if sClass == "story_book_index_chapter" then
		local nOrder = StoryManager.getWindowOrderValue(w);
		if nOrder > 1 then
			StoryManager.setWindowOrderValue(tOrderedChildren[nOrder - 1], nOrder);
			StoryManager.setWindowOrderValue(tOrderedChildren[nOrder], nOrder - 1);
			cParentList.applySort();
		end
	end
	if sClass == "story_book_index_section" then
		local nOrder = StoryManager.getWindowOrderValue(w);
		if nOrder > 1 then
			StoryManager.setWindowOrderValue(tOrderedChildren[nOrder - 1], nOrder);
			StoryManager.setWindowOrderValue(tOrderedChildren[nOrder], nOrder - 1);
			cParentList.applySort();
		elseif nOrder == 1 then
			local wChapter = w.windowlist.window;
			local cChapterParentList = wChapter.windowlist;
			local tChapterOrderedChildren = StoryManager.updateOrderValues(cChapterParentList);
			local nChapterOrder = StoryManager.getWindowOrderValue(wChapter);
			local wPrevChapter = nil;
			if nChapterOrder > 1 then
				wPrevChapter = tChapterOrderedChildren[nChapterOrder - 1];
			end
			if wPrevChapter then
				StoryManager.onBookIndexMoveHelper(w, wPrevChapter.list, false);
			end
		end
	end
	if sClass == "story_book_index_page" then
		local nOrder = StoryManager.getWindowOrderValue(w);
		if nOrder > 1 then
			StoryManager.setWindowOrderValue(tOrderedChildren[nOrder - 1], nOrder);
			StoryManager.setWindowOrderValue(tOrderedChildren[nOrder], nOrder - 1);
			cParentList.applySort();
		elseif nOrder == 1 then
			local wSection = w.windowlist.window;
			local cSectionParentList = wSection.windowlist;
			local tSectionOrderedChildren = StoryManager.updateOrderValues(cSectionParentList);
			local nSectionOrder = StoryManager.getWindowOrderValue(wSection);
			local wPrevSection = nil;
			if nSectionOrder > 1 then
				wPrevSection = tSectionOrderedChildren[nSectionOrder - 1];
			elseif nSectionOrder == 1 then
				local wChapter = wSection.windowlist.window;
				local cChapterParentList = wChapter.windowlist;
				local tChapterOrderedChildren = StoryManager.updateOrderValues(cChapterParentList);
				local nChapterOrder = StoryManager.getWindowOrderValue(wChapter);
				if nChapterOrder > 1 then
					local wPrevChapter = tChapterOrderedChildren[nChapterOrder - 1];
					local tPrevChapterOrderedChildren = StoryManager.updateOrderValues(wPrevChapter.list);
					if #tPrevChapterOrderedChildren > 0 then
						wPrevSection = tPrevChapterOrderedChildren[#tPrevChapterOrderedChildren];
					else
						wPrevSection = StoryManager.onBookIndexAddHelper(wPrevChapter.list, 1);
					end
				end
			end
			if wPrevSection then
				StoryManager.onBookIndexMoveHelper(w, wPrevSection.list, false);
			end
		end
	end
end
function onBookIndexMoveDown(w)
	local cParentList = w.windowlist;
	local nodeList = cParentList.getDatabaseNode();
	if not nodeList or DB.isStatic(nodeList) then
		return;
	end
	local tOrderedChildren = StoryManager.updateOrderValues(cParentList);

	local sClass = w.getClass();
	if sClass == "story_book_index_chapter" then
		local nOrder = StoryManager.getWindowOrderValue(w);
		if nOrder < #tOrderedChildren then
			StoryManager.setWindowOrderValue(tOrderedChildren[nOrder + 1], nOrder);
			StoryManager.setWindowOrderValue(tOrderedChildren[nOrder], nOrder + 1);
			cParentList.applySort();
		end
	end
	if sClass == "story_book_index_section" then
		local nOrder = StoryManager.getWindowOrderValue(w);
		if nOrder < #tOrderedChildren then
			StoryManager.setWindowOrderValue(tOrderedChildren[nOrder + 1], nOrder);
			StoryManager.setWindowOrderValue(tOrderedChildren[nOrder], nOrder + 1);
			cParentList.applySort();
		elseif nOrder == #tOrderedChildren then
			local wChapter = w.windowlist.window;
			local cChapterParentList = wChapter.windowlist;
			local tChapterOrderedChildren = StoryManager.updateOrderValues(cChapterParentList);
			local nChapterOrder = StoryManager.getWindowOrderValue(wChapter);
			local wNextChapter = nil;
			if nChapterOrder < #tChapterOrderedChildren then
				wNextChapter = tChapterOrderedChildren[nChapterOrder + 1];
			end
			if wNextChapter then
				StoryManager.onBookIndexMoveHelper(w, wNextChapter.list, true);
			end
		end
	end
	if sClass == "story_book_index_page" then
		local nOrder = StoryManager.getWindowOrderValue(w);
		if nOrder < #tOrderedChildren then
			StoryManager.setWindowOrderValue(tOrderedChildren[nOrder + 1], nOrder);
			StoryManager.setWindowOrderValue(tOrderedChildren[nOrder], nOrder + 1);
			cParentList.applySort();
		elseif nOrder == #tOrderedChildren then
			local wSection = w.windowlist.window;
			local cSectionParentList = wSection.windowlist;
			local tSectionOrderedChildren = StoryManager.updateOrderValues(cSectionParentList);
			local nSectionOrder = StoryManager.getWindowOrderValue(wSection);
			local wNextSection = nil;
			if nSectionOrder < #tSectionOrderedChildren then
				wNextSection = tSectionOrderedChildren[nSectionOrder + 1];
			elseif nSectionOrder == #tSectionOrderedChildren then
				local wChapter = wSection.windowlist.window;
				local cChapterParentList = wChapter.windowlist;
				local tChapterOrderedChildren = StoryManager.updateOrderValues(cChapterParentList);
				local nChapterOrder = StoryManager.getWindowOrderValue(wChapter);
				if nChapterOrder < #tChapterOrderedChildren then
					local wNextChapter = tChapterOrderedChildren[nChapterOrder + 1];
					local tNextChapterOrderedChildren = StoryManager.updateOrderValues(wNextChapter.list);
					if #tNextChapterOrderedChildren > 0 then
						wNextSection = tNextChapterOrderedChildren[1];
					else
						wNextSection = StoryManager.onBookIndexAddHelper(wNextChapter.list, 1);
					end
				end
			end
			if wNextSection then
				StoryManager.onBookIndexMoveHelper(w, wNextSection.list, true);
			end
		end
	end
end
function onBookIndexMoveHelper(w, cList, bDown)
	local tOrderedChildren = StoryManager.updateOrderValues(cList);
	if bDown then
		for kChild,wChild in ipairs(tOrderedChildren) do
			StoryManager.setWindowOrderValue(wChild, kChild + 1);
		end
	end

	local wNew = cList.createWindow();
	local nodeOld = w.getDatabaseNode();
	DB.copyNode(nodeOld, wNew.getDatabaseNode());
	DB.deleteNode(nodeOld);

	if bDown then
		StoryManager.setWindowOrderValue(wNew, 1);
	else
		StoryManager.setWindowOrderValue(wNew, #tOrderedChildren + 1);
	end
end

function onBookIndexDrop(w, draginfo)
	if draginfo.isType("shortcut") then
		local sClass, sRecord = draginfo.getShortcutData();
		local sRecordType = RecordDataManager.getRecordTypeFromRecordPath(sRecord);
		if sRecordType == "story" then
			return StoryManager.onBookIndexStoryDrop(w, sClass, sRecord);
		end
	end
end
function onBookIndexStoryDrop(w, sClass, sRecord)
	local sIndexClass = w.getClass();
	if sIndexClass == "story_book_index_chapter" then
		local tOrderedSections = StoryManager.updateOrderValues(w.list);
		local wSection = tOrderedSections[1] or StoryManager.onBookIndexAddEndHelper(w.list);
		return StoryManager.onBookIndexStoryDrop(wSection, sClass, sRecord);

	elseif sIndexClass == "story_book_index_section" then
		local tOrderedPages = StoryManager.updateOrderValues(w.list);
		for i = 1, #tOrderedPages do
			StoryManager.setWindowOrderValue(tOrderedPages[i], i + 1);
		end
		local wPage = StoryManager.onBookIndexAddHelper(w.list, 1);
		wPage.setLink(sClass, sRecord);
		return true;

	elseif sIndexClass == "story_book_index_page" then
		local tOrderedPages = StoryManager.updateOrderValues(w.windowlist);
		local nOrder = StoryManager.getWindowOrderValue(w);
		for i = nOrder + 1, #tOrderedPages do
			StoryManager.setWindowOrderValue(tOrderedPages[i], i + 1);
		end
		local wPage = StoryManager.onBookIndexAddHelper(w.windowlist, nOrder + 1);
		wPage.setLink(sClass, sRecord);
		return true;

	elseif sIndexClass == "story_book_index" then
		local tOrderedChapters = StoryManager.updateOrderValues(w.list);
		local wChapter = tOrderedChapters[#tOrderedChapters];
		if not wChapter then
			wChapter = StoryManager.onBookIndexAddEndHelper(w.list);
		end
		local tOrderedSections = StoryManager.updateOrderValues(wChapter.list);
		local wSection = tOrderedSections[#tOrderedSections];
		if not wSection then
			wSection = StoryManager.onBookIndexAddEndHelper(wChapter.list);
		end
		local wPage = StoryManager.onBookIndexAddEndHelper(wSection.list);
		wPage.setLink(sClass, sRecord);
		return true;
	end
end

-- 
--	BOOK - EXPORT - KEYWORD GEN
--

local tKeywordIgnore = {
	["a"] = true,
	["about"] = true,
	["above"] = true,
	["after"] = true,
	["again"] = true,
	["against"] = true,
	["all"] = true,
	["am"] = true,
	["an"] = true,
	["and"] = true,
	["any"] = true,
	["are"] = true,
	["aren't"] = true,
	["as"] = true,
	["at"] = true,
	["be"] = true,
	["because"] = true,
	["been"] = true,
	["before"] = true,
	["being"] = true,
	["below"] = true,
	["between"] = true,
	["both"] = true,
	["but"] = true,
	["by"] = true,
	["can't"] = true,
	["cannot"] = true,
	["could"] = true,
	["couldn't"] = true,
	["did"] = true,
	["didn't"] = true,
	["do"] = true,
	["does"] = true,
	["doesn't"] = true,
	["doing"] = true,
	["don't"] = true,
	["down"] = true,
	["during"] = true,
	["each"] = true,
	["few"] = true,
	["for"] = true,
	["from"] = true,
	["further"] = true,
	["got"] = true,
	["had"] = true,
	["hadn't"] = true,
	["has"] = true,
	["hasn't"] = true,
	["have"] = true,
	["haven't"] = true,
	["having"] = true,
	["he"] = true,
	["he'd"] = true,
	["he'll"] = true,
	["he's"] = true,
	["her"] = true,
	["here"] = true,
	["here's"] = true,
	["hers"] = true,
	["herself"] = true,
	["him"] = true,
	["himself"] = true,
	["his"] = true,
	["how"] = true,
	["how's"] = true,
	["i"] = true,
	["i'd"] = true,
	["i'll"] = true,
	["i'm"] = true,
	["i've"] = true,
	["if"] = true,
	["in"] = true,
	["into"] = true,
	["is"] = true,
	["isn't"] = true,
	["it"] = true,
	["it's"] = true,
	["its"] = true,
	["itself"] = true,
	["let's"] = true,
	["like"] = true,
	["me"] = true,
	["more"] = true,
	["most"] = true,
	["mustn't"] = true,
	["my"] = true,
	["myself"] = true,
	["no"] = true,
	["nor"] = true,
	["not"] = true,
	["of"] = true,
	["off"] = true,
	["on"] = true,
	["once"] = true,
	["only"] = true,
	["or"] = true,
	["other"] = true,
	["ought"] = true,
	["our"] = true,
	["ours"] = true,
	["ourselves"] = true,
	["out"] = true,
	["over"] = true,
	["own"] = true,
	["same"] = true,
	["shan't"] = true,
	["she"] = true,
	["she'd"] = true,
	["she'll"] = true,
	["she's"] = true,
	["should"] = true,
	["shouldn't"] = true,
	["so"] = true,
	["some"] = true,
	["such"] = true,
	["than"] = true,
	["that"] = true,
	["that's"] = true,
	["the"] = true,
	["their"] = true,
	["theirs"] = true,
	["them"] = true,
	["themselves"] = true,
	["then"] = true,
	["there"] = true,
	["there's"] = true,
	["these"] = true,
	["they"] = true,
	["they'd"] = true,
	["they'll"] = true,
	["they're"] = true,
	["they've"] = true,
	["this"] = true,
	["those"] = true,
	["through"] = true,
	["to"] = true,
	["too"] = true,
	["under"] = true,
	["until"] = true,
	["up"] = true,
	["very"] = true,
	["was"] = true,
	["wasn't"] = true,
	["we"] = true,
	["we'd"] = true,
	["we'll"] = true,
	["we're"] = true,
	["we've"] = true,
	["were"] = true,
	["weren't"] = true,
	["what"] = true,
	["what's"] = true,
	["when"] = true,
	["when's"] = true,
	["where"] = true,
	["where's"] = true,
	["which"] = true,
	["while"] = true,
	["who"] = true,
	["who's"] = true,
	["whom"] = true,
	["why"] = true,
	["why'd"] = true,
	["why's"] = true,
	["with"] = true,
	["won't"] = true,
	["would"] = true,
	["wouldn't"] = true,
	["you"] = true,
	["you'd"] = true,
	["you'll"] = true,
	["you're"] = true,
	["you've"] = true,
	["your"] = true,
	["yours"] = true,
	["yourself"] = true,
	["yourselves"] = true,
}

function onBookKeywordGen()
	for _,nodeChapter in ipairs(DB.getChildList(DB.getPath(StoryManager.DEFAULT_BOOK_INDEX, StoryManager.DEFAULT_BOOK_INDEX_CHAPTER_LIST))) do
		for _,nodeSection in ipairs(DB.getChildList(nodeChapter, StoryManager.DEFAULT_BOOK_INDEX_SECTION_LIST)) do
			for _,nodePage in ipairs(DB.getChildList(nodeSection, StoryManager.DEFAULT_BOOK_INDEX_PAGE_LIST)) do
				StoryManager.onBookKeywordGenPage(nodePage);
			end
		end
	end
end
function onBookKeywordGenPage(nodePage)
	local tKeywords = {};

	StoryManager.helperGetKeywordsFromText(DB.getValue(nodePage, "name", ""), tKeywords);

	local _,sRecord = DB.getValue(nodePage, "listlink", "", "");
	local nodeRefPage = DB.findNode(sRecord);
	if nodeRefPage then
		for _,nodeBlock in ipairs(DB.getChildList(nodeRefPage, "blocks")) do
			StoryManager.helperGetKeywordsFromText(DB.getText(nodeBlock, "text", ""), tKeywords);
			StoryManager.helperGetKeywordsFromText(DB.getText(nodeBlock, "text2", ""), tKeywords);
		end
	end

	local tKeywords2 = {};
	for sWord,_ in pairs(tKeywords) do
		table.insert(tKeywords2, sWord);
	end
	DB.setValue(nodePage, "keywords", "string", table.concat(tKeywords2, " "));
end
function helperGetKeywordsFromText(sText, tKeywords)
	local tWords = StringManager.parseWords(sText);
	for _,sWord in pairs(tWords) do
		local sWordLower = sWord:lower();
		if not tKeywordIgnore[sWordLower] and not sWord:match("^%d+$") then
			tKeywords[sWordLower] = true;
		end
	end
end

--
--	STORY (ADVANCED) - UI - BLOCK EDIT/DROP
--

function onBlockAddEndHelper(cList)
	local nCount = #(StoryManager.updateOrderValues(cList));
	return StoryManager.onBookIndexAddHelper(cList, nCount + 1);
end
function onBlockAddHelper(cList, nOrder)
	local wAdd = cList.createWindow();
	StoryManager.setWindowOrderValue(wAdd, nOrder);
	return wAdd;
end

function onBlockAdd(wRecord, sBlockType)
	local nodeList = wRecord.blocks.getDatabaseNode();
	if not nodeList or DB.isStatic(nodeList) then
		return;
	end

	local wNew = StoryManager.onBlockAddEndHelper(wRecord.blocks);

	-- Setting block type should come last, since it forces block rebuild
	local nodeBlock = wNew.getDatabaseNode()
	if sBlockType == "textrimagel" then
		DB.setValue(nodeBlock, "align", "string", "right,left");
		DB.setValue(nodeBlock, "imagelink", "windowreference", "", "");
		DB.setValue(nodeBlock, "blocktype", "string", "imageleft");
	elseif sBlockType == "textlimager" then
		DB.setValue(nodeBlock, "align", "string", "left,right");
		DB.setValue(nodeBlock, "imagelink", "windowreference", "", "");
		DB.setValue(nodeBlock, "blocktype", "string", "imageright");
	elseif sBlockType == "image" then
		DB.setValue(nodeBlock, "frame", "string", "picture");
		DB.setValue(nodeBlock, "imagelink", "windowreference", "", "");
		DB.setValue(nodeBlock, "blocktype", "string", "image");
	elseif sBlockType == "header" then
		DB.setValue(nodeBlock, "blocktype", "string", "header");
	elseif sBlockType == "dualtext" then
		DB.setValue(nodeBlock, "align", "string", "left,right");
		DB.setValue(nodeBlock, "blocktype", "string", "dualtext");
	elseif sBlockType == "text" then
		DB.setValue(nodeBlock, "blocktype", "string", "singletext");
	end

	StoryManager.onBlockNodeRebuild(wNew.getDatabaseNode());
end
function onBlockDelete(wBlock)
	DB.deleteNode(wBlock.getDatabaseNode());
end

function onBlockMoveUp(wBlock)
	local cParentList = wBlock.windowlist;
	local nodeList = cParentList.getDatabaseNode();
	if not nodeList or DB.isStatic(nodeList) then
		return;
	end
	local tOrderedChildren = StoryManager.updateOrderValues(cParentList);

	local nOrder = StoryManager.getWindowOrderValue(wBlock);
	if nOrder > 1 then
		StoryManager.setWindowOrderValue(tOrderedChildren[nOrder - 1], nOrder);
		StoryManager.setWindowOrderValue(tOrderedChildren[nOrder], nOrder - 1);
		cParentList.applySort();
	end
end
function onBlockMoveDown(wBlock)
	local cParentList = wBlock.windowlist;
	local nodeList = cParentList.getDatabaseNode();
	if not nodeList or DB.isStatic(nodeList) then
		return;
	end
	local tOrderedChildren = StoryManager.updateOrderValues(cParentList);

	local nOrder = StoryManager.getWindowOrderValue(wBlock);
	if nOrder < #tOrderedChildren then
		StoryManager.setWindowOrderValue(tOrderedChildren[nOrder + 1], nOrder);
		StoryManager.setWindowOrderValue(tOrderedChildren[nOrder], nOrder + 1);
		cParentList.applySort();
	end
end

function onBlockDrop(wBlock, draginfo)
	if not wBlock then
		return false;
	end

	local bReadOnly = WindowManager.getReadOnlyState(wBlock.windowlist.window.getDatabaseNode());
	if bReadOnly then
		return false;
	end

	local sDragType = draginfo.getType();
	if sDragType == "shortcut" then
		local sClass,sRecord = draginfo.getShortcutData();
		if RecordDataManager.getRecordTypeFromDisplayClass(sClass) == "image" then
			local nodeDrag = draginfo.getDatabaseNode();
			local sAsset = DB.getText(nodeDrag, "image", "");
			local sName = DB.getValue(nodeDrag, "name", "");

			StoryManager.onBlockImageDropHelper(wBlock, sAsset, sName, sClass, sRecord);
			return true;
		end
	elseif (sDragType == "image") or (sDragType == "token") then
		local sAsset = draginfo.getTokenData();
		StoryManager.onBlockImageDropHelper(wBlock, sAsset);
		return true;
	end

	return false;
end
function onBlockImageDropHelper(wBlock, sAsset, sName, sClass, sRecord)
	if sAsset == "" then
		return;
	end

	local nodeWin = wBlock.getDatabaseNode();
	DB.setValue(nodeWin, "image", "image", sAsset);
	DB.setValue(nodeWin, "caption", "string", sName or "");
	DB.setValue(nodeWin, "imagelink", "windowreference", sClass or "", sRecord or "");

	-- Remove any old scaling/size information from previous images
	DB.deleteChild(nodeWin, "scale");
	DB.deleteChild(nodeWin, "size");

	StoryManager.onBlockNodeRebuild(wBlock.getDatabaseNode());
end

function onBlockScaleUp(wBlock)
	local nScale = StoryManager.getBlockImageScale(wBlock);
	if nScale < 100 then
		local nodeWin = wBlock.getDatabaseNode();
		nScale = math.min(nScale + 10, 100);
		DB.setValue(nodeWin, "scale", "number", nScale);
		DB.deleteChild(nodeWin, "size");

		StoryManager.onBlockNodeRebuild(wBlock.getDatabaseNode());
	end
end
function onBlockScaleDown(wBlock)
	local nScale = StoryManager.getBlockImageScale(wBlock);
	if nScale > 10 then
		local nodeWin = wBlock.getDatabaseNode();
		nScale = math.max(nScale - 10, 10);
		DB.setValue(nodeWin, "scale", "number", nScale);
		DB.deleteChild(nodeWin, "size");

		StoryManager.onBlockNodeRebuild(wBlock.getDatabaseNode());
	end
end
function onBlockSizeClear(wBlock)
	local nodeWin = wBlock.getDatabaseNode();
	DB.deleteChild(nodeWin, "size");

	StoryManager.onBlockNodeRebuild(wBlock.getDatabaseNode());
end

--
--	STORY (ADVANCED) - UI - DISPLAY
--

function onBlockUpdate(wBlock, bReadOnly)
	StoryManager.updateBlockControls(wBlock, bReadOnly);
end

function updateBlockControls(wBlock, bReadOnly)
	StoryManager.updateBlockTextControls(wBlock, bReadOnly);
	StoryManager.updateBlockImageControls(wBlock, bReadOnly);
	StoryManager.updateBlockEditControls(wBlock, bReadOnly);
end
function updateBlockTextControls(wBlock, bReadOnly)
	updateBlockTextControlHelper(wBlock.header, bReadOnly);
	updateBlockTextControlHelper(wBlock.text, bReadOnly);
	updateBlockTextControlHelper(wBlock.text_left, bReadOnly);
	updateBlockTextControlHelper(wBlock.text_right, bReadOnly);

	if bReadOnly then
		if wBlock.button_frameselect then
			wBlock.button_frameselect.destroy();
		end
		if wBlock.button_frameselect_right then
			wBlock.button_frameselect_right.destroy();
		end
	else
		if wBlock.header or wBlock.text or wBlock.text_left then
			if not wBlock.button_frameselect then
				if wBlock.text_left then
					wBlock.createControl("button_story_block_frameselect_left", "button_frameselect");
				else
					wBlock.createControl("button_story_block_frameselect", "button_frameselect");
				end
			end
		else
			if wBlock.button_frameselect then
				wBlock.button_frameselect.destroy();
			end
		end
		if wBlock.text_right then
			if not wBlock.button_frameselect_right then
				local cFrame = wBlock.createControl("button_story_block_frameselect", "button_frameselect_right");
				cFrame.setAnchor("left", "text_right", "left", "absolute", -20);
			end
		else
			if wBlock.button_frameselect_right then
				wBlock.button_frameselect_right.destroy();
			end
		end
	end
end
function updateBlockTextControlHelper(c, bReadOnly)
	if c then
		c.setReadOnly(bReadOnly);
		if bReadOnly then
			c.setBackColor();
		else
			c.setBackColor(_sBlockTextEditBackColor);
		end
	end
end
function updateBlockImageControls(wBlock, bReadOnly)
	if wBlock.caption then
		local bCaptionEmpty = (wBlock.caption.getValue() == "");

		wBlock.caption.setVisible(not bReadOnly or not bCaptionEmpty);
		wBlock.caption.setReadOnly(bReadOnly);
		if bReadOnly then
			wBlock.caption.setBackColor();
		else
			wBlock.caption.setBackColor(_sBlockTextEditBackColor);
		end
	end

	if wBlock.image then
		wBlock.image.setReadOnly(bReadOnly);
		if bReadOnly then
			if wBlock.button_image_sizeclear then
				wBlock.button_image_sizeclear.destroy();
			end
			if wBlock.button_image_scaleup then
				wBlock.button_image_scaleup.destroy();
			end
			if wBlock.button_image_scaledown then
				wBlock.button_image_scaledown.destroy();
			end
		else
			local tLegacySize = StoryManager.getBlockImageLegacySize(wBlock);
			if tLegacySize then
				if not wBlock.button_image_sizeclear then
					wBlock.createControl("button_story_block_image_sizeclear", "button_image_sizeclear");
				end
				if wBlock.button_image_scaleup then
					wBlock.button_image_scaleup.destroy();
				end
				if wBlock.button_image_scaledown then
					wBlock.button_image_scaledown.destroy();
				end
			else
				if wBlock.button_image_sizeclear then
					wBlock.button_image_sizeclear.destroy();
				end
				local nScale = StoryManager.getBlockImageScale(wBlock);
				if nScale < 100 then
					if not wBlock.button_image_scaleup then
						wBlock.createControl("button_story_block_image_scaleup", "button_image_scaleup");
					end
				else
					if wBlock.button_image_scaleup then
						wBlock.button_image_scaleup.destroy();
					end
				end
				if nScale > 10 then
					if not wBlock.button_image_scaledown then
						wBlock.createControl("button_story_block_image_scaledown", "button_image_scaledown");
					end
				else
					if wBlock.button_image_scaledown then
						wBlock.button_image_scaledown.destroy();
					end
				end
			end
		end
	else
		if wBlock.button_image_scaleup then
			wBlock.button_image_scaleup.destroy();
		end
		if wBlock.button_image_scaledown then
			wBlock.button_image_scaledown.destroy();
		end
		if wBlock.button_image_sizeclear then
			wBlock.button_image_sizeclear.destroy();
		end
	end
end
function updateBlockEditControls(wBlock, bReadOnly)
	if bReadOnly then
		if wBlock.imovedown then
			wBlock.imovedown.destroy();
		end
		if wBlock.imoveup then
			wBlock.imoveup.destroy();
		end
		if wBlock.idelete then
			wBlock.idelete.destroy();
		end
	else
		if not wBlock.idelete then
			wBlock.createControl("button_story_block_idelete", "idelete");
		end
		if not wBlock.imoveup then
			wBlock.createControl("button_story_block_imoveup", "imoveup");
		end
		if not wBlock.imovedown then
			wBlock.createControl("button_story_block_imovedown", "imovedown");
		end
	end
end

function onRecordNodeRebuild(nodeRecord)
	-- Check any open manuals to rebuild
	local tManualWindows = Interface.getWindows("reference_manual");
	for _,wManual in ipairs(tManualWindows) do
		local wPage = wManual.content.subwindow;
		if wPage and (wPage.getDatabaseNode() == nodeRecord) and (wPage.getClass() == "story_book_page_advanced") then
			StoryManager.onRecordRebuild(wPage.content.subwindow);
		end
	end

	-- Check open reference manual pages to rebuild
	local w = Interface.findWindow("referencemanualpage", nodeRecord);
	if w then
		StoryManager.onRecordRebuild(w.content.subwindow);
	end
end
function onRecordRebuild(wRecord)
	for _,wBlock in ipairs(wRecord.blocks.getWindows()) do
		StoryManager.onBlockRebuild(wBlock);
	end
end

function onBlockNodeRebuild(nodeBlock)
	local nodePage = DB.getChild(nodeBlock, "...");

	-- Check any open manuals to rebuild
	local tManualWindows = Interface.getWindows("reference_manual");
	for _,wManual in ipairs(tManualWindows) do
		local wPage = wManual.content.subwindow;
		if wPage and (wPage.getDatabaseNode() == nodePage) and (wPage.getClass() == "story_book_page_advanced") then
			for _,wBlock in ipairs(wPage.content.subwindow.blocks.getWindows()) do
				if wBlock.getDatabaseNode() == nodeBlock then
					StoryManager.onBlockRebuild(wBlock);
					break;
				end
			end
		end
	end

	-- Check open reference manual pages to rebuild
	local w = Interface.findWindow("referencemanualpage", nodePage);
	if w then
		for _,wBlock in ipairs(w.content.subwindow.blocks.getWindows()) do
			if wBlock.getDatabaseNode() == nodeBlock then
				StoryManager.onBlockRebuild(wBlock);
				break;
			end
		end
	end
end
function onBlockRebuild(wBlock)
	StoryManager.clearBlockControls(wBlock);

	local nodeBlock = wBlock.getDatabaseNode();
	local sBlockType = DB.getValue(nodeBlock, "blocktype", "");
	if sBlockType == "header" then
		StoryManager.addBlockHeader(wBlock);
	else
		local sAlign = DB.getValue(nodeBlock, "align", "");
		local tAlign = StringManager.split(sAlign, ",");

		-- Single column
		if #tAlign <= 1 then
			if sBlockType:match("image") or sBlockType:match("picture") then
				StoryManager.addBlockImage(wBlock);
			elseif sBlockType:match("icon") then
				StoryManager.addBlockIcon(wBlock);
			else
				StoryManager.addBlockText(wBlock);
			end
		-- Dual columns
		elseif #tAlign >= 2 then
			StoryManager.addBlockText(wBlock, tAlign[1]);
			
			if sBlockType:match("image") or sBlockType:match("picture") then
				StoryManager.addBlockImage(wBlock, tAlign[2]);
			elseif sBlockType:match("icon") then
				StoryManager.addBlockIcon(wBlock, tAlign[2]);
			else
				StoryManager.addBlockText(wBlock, tAlign[2], true);
			end
		end
	end

	StoryManager.adjustBlockToImageSize(wBlock);

	local bReadOnly = WindowManager.getReadOnlyState(wBlock.windowlist.window.getDatabaseNode());
	StoryManager.updateBlockControls(wBlock, bReadOnly);
end

function clearBlockControls(wBlock)
	StoryManager.clearBlockTextControls(wBlock);
	StoryManager.clearBlockImageControls(wBlock);
	StoryManager.clearBlockEditControls(wBlock);
end
function clearBlockTextControls(wBlock)
	if wBlock.button_frameselect_right then
		wBlock.button_frameselect_right.destroy();
	end
	if wBlock.button_frameselect then
		wBlock.button_frameselect.destroy();
	end
	if wBlock.spacer_left then
		wBlock.spacer_left.destroy();
	end
	if wBlock.spacer then
		wBlock.spacer.destroy();
	end
	if wBlock.text_right then
		wBlock.text_right.destroy();
	end
	if wBlock.text_left then
		wBlock.text_left.destroy();
	end
	if wBlock.text then
		wBlock.text.destroy();
	end
	if wBlock.header then
		wBlock.header.destroy();
	end
end
function clearBlockImageControls(wBlock)
	if wBlock.button_image_scaledown then
		wBlock.button_image_scaledown.destroy();
	end
	if wBlock.button_image_scaleup then
		wBlock.button_image_scaleup.destroy();
	end
	if wBlock.button_image_sizeclear then
		wBlock.button_image_sizeclear.destroy();
	end
	if wBlock.caption then
		wBlock.caption.destroy();
	end
	if wBlock.image then
		wBlock.image.destroy();
	end
end
function clearBlockEditControls(wBlock)
	if wBlock.imovedown then
		wBlock.imovedown.destroy();
	end
	if wBlock.imoveup then
		wBlock.imoveup.destroy();
	end
	if wBlock.idelete then
		wBlock.idelete.destroy();
	end
end

function getBlockFrame(wBlock, sAlign)
	local sFrame;
	if sAlign == "left" then
	 	sFrame = DB.getValue(wBlock.getDatabaseNode(), "frameleft", "");
	else
	 	sFrame = DB.getValue(wBlock.getDatabaseNode(), "frame", "");
	end
	if sFrame == "noframe" then
		sFrame = "";
	end
	return sFrame;
end
function getBlockImageData(wBlock, sAlign)
	local node = wBlock.getDatabaseNode();
	local sAsset = DB.getText(node, "picture", "");
	if sAsset == "" then
		sAsset = DB.getText(node, "image", "");
	end

	local tImageSize = {};
	tImageSize.w, tImageSize.h = Interface.getAssetSize(sAsset);

 	local tLegacySize = StoryManager.getBlockImageLegacySize(wBlock);
 	if tLegacySize then
 		StoryManager.applyBlockGraphicSizeMaxHelper(tImageSize, tLegacySize.w, tLegacySize.h);
 	end

	if (sAlign == "left") or (sAlign == "right") then
		StoryManager.applyBlockGraphicSizeMaxHelper(tImageSize, _nMaxColumnImageWidth);
	else
		StoryManager.applyBlockGraphicSizeMaxHelper(tImageSize, _nMaxSingleImageWidth);
	end

	local nScale = tonumber(DB.getValue(node, "scale")) or 100;
	if (nScale < 10) or (nScale > 100) then
		nScale = 100;
	end
	if nScale < 100 then
		tImageSize.w = math.ceil((tImageSize.w * nScale) / 100);
		tImageSize.h = math.ceil((tImageSize.h * nScale) / 100);
	end
	
	if tImageSize.w == 0 then
		tImageSize.w = _nMinImageWidth;
		tImageSize.h = tImageSize.w;
	elseif tImageSize.w < _nMinImageWidth then
		local nScale = tImageSize.w / _nMinImageWidth;
		tImageSize.w = _nMinImageWidth;
		tImageSize.h = math.ceil(tImageSize.h / nScale);
	end

	return sAsset, tImageSize.w, tImageSize.h;
end
function getBlockImageScale(wBlock)
	local nScale = tonumber(DB.getValue(wBlock.getDatabaseNode(), "scale")) or 100;
	if (nScale < 10) or (nScale > 100) then
		nScale = 100;
	end
	return nScale;
end
function getBlockImageLegacySize(wBlock)
	local tLegacySize = nil;
	local sLegacySize = DB.getValue(wBlock.getDatabaseNode(), "size", "");
	if (sLegacySize ~= "") then
		local sSizeDataW, sSizeDataH = sLegacySize:match("(%d+),(%d+)");
		if sSizeDataW and sSizeDataH then
			tLegacySize = {};
			tLegacySize.w = tonumber(sSizeDataW) or 100;
			tLegacySize.h = tonumber(sSizeDataH) or 100;
		end
	end
	return tLegacySize;
end
function getBlockIconData(wBlock, sAlign)
	local node = wBlock.getDatabaseNode();
	local sAsset = DB.getText(node, "icon", "");

	local tImageSize = { w = 100, h = 100 };

 	local tLegacySize = StoryManager.getBlockImageLegacySize(wBlock);
 	if tLegacySize then
 		tImageSize.w = tLegacySize.w;
 		tImageSize.h = tLegacySize.h;
 	end

	if (sAlign == "left") or (sAlign == "right") then
		applyBlockGraphicSizeMaxHelper(tImageSize, _nMaxColumnImageWidth);
	else
		applyBlockGraphicSizeMaxHelper(tImageSize, _nMaxSingleImageWidth);
	end
	
	return sAsset, tImageSize.w, tImageSize.h;
end
function applyBlockGraphicSizeMaxHelper(tImageSize, nMaxW, nMaxH)
	if nMaxW and (tImageSize.w > nMaxW) then
		local nScale = tImageSize.w / nMaxW;
		tImageSize.w = nMaxW;
		tImageSize.h = math.ceil(tImageSize.h / nScale);
	end
	if nMaxH and (tImageSize.h > nMaxH) then
		local nScale = tImageSize.h / nMaxH;
		tImageSize.h = nMaxH;
		tImageSize.w = math.ceil(tImageSize.w / nScale);
	end
end

function addBlockHeader(wBlock)
	local sFrame = StoryManager.getBlockFrame(wBlock);

	local cHeader = wBlock.header;
	if not cHeader then
		cHeader = wBlock.createControl("header_story_block", "header", "text");
	end
	if sFrame ~= "" and Interface.isFrame("referenceblock-" .. sFrame) then
		cHeader.setAnchor("left", "contentanchor", "left", "absolute", _nHeaderWithFrameOffsetX);
		cHeader.setAnchor("right", "contentanchor", "right", "absolute", -_nHeaderWithFrameOffsetX);
		cHeader.setAnchor("top", "contentanchor", "bottom", "relative", _nHeaderWithFrameOffsetY);
		cHeader.setFrame("referenceblock-" .. sFrame, _nHeaderFrameOffsetX, _nHeaderFrameOffsetY, _nHeaderFrameOffsetX, _nHeaderFrameOffsetY);
		if not wBlock.spacer then
			local cSpacer = wBlock.createControl("spacer_story_block", "spacer");
			cSpacer.setAnchor("top", "header", "bottom", "absolute", 0);
			cSpacer.setAnchoredHeight(_nHeaderWithFrameOffsetY);
		end
	else
		cHeader.setAnchor("left", "contentanchor", "left", "absolute", _nHeaderSansFrameOffsetX);
		cHeader.setAnchor("right", "contentanchor", "right", "absolute", -_nHeaderSansFrameOffsetX);
		cHeader.setAnchor("top", "contentanchor", "bottom", "relative", _nHeaderSansFrameOffsetY);
		cHeader.setFrame("");
		if wBlock.spacer then
			wBlock.spacer.destroy();
		end
	end
end
function addBlockText(wBlock, sAlign, bUseSecondField)
	local sFrame = StoryManager.getBlockFrame(wBlock, sAlign);

	local sSource;
	if bUseSecondField then
		sSource = "text2";
	else
		sSource = "text";
	end

	local sControlName;
	if sAlign == "left" then
		sControlName = "text_left";
	elseif sAlign == "right" then
		sControlName = "text_right";
	else
		sControlName = "text";
	end

	local cText = wBlock[sControlName];
	if not cText then
		cText = wBlock.createControl("ft_story_block", sControlName, sSource);
	end

	if sFrame ~= "" and Interface.isFrame("referenceblock-" .. sFrame) then
		cText.setAnchor("top", "contentanchor", "top", "relative", _nTextFrameOffsetY);
		if sAlign == "left" then
			cText.setAnchor("left", "contentanchor", "left", "absolute", _nTextWithFrameOffsetX);
			cText.setAnchor("right", "contentanchor", "center", "absolute", -_nTextWithFrameOffsetX);
		elseif sAlign == "right" then
			cText.setAnchor("left", "contentanchor", "center", "absolute", _nTextWithFrameOffsetX);
			cText.setAnchor("right", "contentanchor", "right", "absolute", -_nTextWithFrameOffsetX);
		else
			cText.setAnchor("left", "contentanchor", "left", "absolute", _nTextWithFrameOffsetX);
			cText.setAnchor("right", "contentanchor", "right", "absolute", -_nTextWithFrameOffsetX);
		end
		cText.setFrame("referenceblock-" .. sFrame, _nTextFrameOffsetX, _nTextFrameOffsetY, _nTextFrameOffsetX, _nTextFrameOffsetY);

		if sAlign == "left" then
			if not wBlock.spacer_left then
				local cSpacer = wBlock.createControl("spacer_story_block", "spacer_left");
				cSpacer.setAnchor("top", sControlName, "bottom", "absolute", 0);
				cSpacer.setAnchoredHeight(_nTextFrameOffsetY);
			end
		else
			if not wBlock.spacer then
				local cSpacer = wBlock.createControl("spacer_story_block", "spacer");
				cSpacer.setAnchor("top", sControlName, "bottom", "absolute", 0);
				cSpacer.setAnchoredHeight(_nTextFrameOffsetY);
			end
		end
	else
		cText.setAnchor("top", "contentanchor", "top", "relative", 0);
		if sAlign == "left" then
			cText.setAnchor("left", "contentanchor", "left", "absolute", _nTextSansFrameOffsetX);
			cText.setAnchor("right", "contentanchor", "center", "absolute", -_nTextSansFrameOffsetX);
		elseif sAlign == "right" then
			cText.setAnchor("left", "contentanchor", "center", "absolute", _nTextSansFrameOffsetX);
			cText.setAnchor("right", "contentanchor", "right", "absolute", -_nTextSansFrameOffsetX);
		else
			cText.setAnchor("left", "contentanchor", "left", "absolute", _nTextSansFrameOffsetX);
			cText.setAnchor("right", "contentanchor", "right", "absolute", -_nTextSansFrameOffsetX);
		end
		cText.setFrame("");
		if sAlign == "left" then
			if wBlock.spacer_left then
				wBlock.spacer_left.destroy();
			end
		else
			if wBlock.spacer then
				wBlock.spacer.destroy();
			end
		end
	end
end
function addBlockImage(wBlock, sAlign)
	local node = wBlock.getDatabaseNode();
	local sAsset, wImage, hImage = StoryManager.getBlockImageData(wBlock, sAlign);

	local cImage = wBlock.image;
	if not cImage then
		cImage = wBlock.createControl("image_story_block", "image");
	end

	if sAsset == "" then
		cImage.setIcon("button_ref_block_image");
		cImage.setColor(StoryManager.getBlockButtonIconColor());
		cImage.setFrame("border");
	else
		cImage.setData(sAsset);
		cImage.setColor("");
		cImage.setFrame("");
	end

	if not wBlock.caption then
		wBlock.createControl("string_story_block_image_caption", "caption");
	end
end
function addBlockIcon(wBlock, sAlign)
	local node = wBlock.getDatabaseNode();
	local sIcon, wImage, hImage = StoryManager.getBlockIconData(wBlock, sAlign);

	local cIcon = wBlock.icon;
	if not cIcon then
		cIcon = wBlock.createControl("icon_story_block", "icon");
	end
	cIcon.setIcon(sIcon);
end

function adjustBlockToImageSize(wBlock)
	if wBlock.image or wBlock.icon then
		local sAlign = DB.getValue(wBlock.getDatabaseNode(), "align", "");
		local tAlign = StringManager.split(sAlign, ",");
		local sGraphicAlign;
		if #tAlign >= 2 then
			sGraphicAlign = tAlign[2];
		end

		local c;
		local tSize = {};
		if wBlock.image then
			c = wBlock.image;
			_, tSize.w, tSize.h = StoryManager.getBlockImageData(wBlock, sGraphicAlign);
		elseif wBlock.icon then
			c = wBlock.icon;
			_, tSize.w, tSize.h = StoryManager.getBlockIconData(wBlock, sGraphicAlign);
		end

		c.setAnchoredWidth(tSize.w);
		c.setAnchoredHeight(tSize.h);
		if sGraphicAlign == "left" then
			c.setAnchor("left", "", "left", "absolute", _nGraphicOffsetX);
		elseif sGraphicAlign == "right" then
			c.setAnchor("right", "", "right", "absolute", -_nGraphicOffsetX);
			c.resetAnchor("left");
		else
			c.setAnchor("left", "", "center", "absolute", tonumber("-" .. (tSize.w / 2)));
		end

		if #tAlign >= 2 then
			local nOffset = tSize.w + (2 * _nGraphicOffsetX);
			local sFrame = StoryManager.getBlockFrame(wBlock, tAlign[1]);
			if sFrame ~= "" then
				nOffset = nOffset + (_nTextWithFrameOffsetX - _nTextSansFrameOffsetX);
			end
			local cText = wBlock.text_left or wBlock.text_right or wBlock.text;
			if tAlign[1] == "left" then
				cText.setAnchor("right", "", "right", "absolute", -nOffset);
			elseif tAlign[1] == "right" then
				cText.setAnchor("left", "", "left", "absolute", nOffset);
			end
		end
	end
end

--
--	STORY (ADVANCED) - UI - IMAGE
--

function onImageDrag(wBlock, draginfo)
	if not draginfo or not wBlock or not wBlock.image then
		return;
	end

	local sClass, sRecord = DB.getValue(wBlock.getDatabaseNode(), "imagelink", "", "");
	if (sClass ~= "") and (sRecord ~= "") then
		draginfo.setType("shortcut");
		draginfo.setIcon("button_link");
		draginfo.setShortcutData(sClass, sRecord);
		draginfo.setDescription(DB.getValue(DB.findNode(sRecord), "name", ""));
		return true;
	end

	local sAsset = wBlock.image.getAsset();
	if (sAsset or "") ~= "" then
		draginfo.setType("image");
		draginfo.setTokenData(sAsset);
		return true;
	end
end
function onImagePressed(wBlock)
	if not wBlock or not wBlock.image then
		return;
	end

	local sClass, sRecord = DB.getValue(wBlock.getDatabaseNode(), "imagelink", "", "");
	if (sClass ~= "") and (sRecord ~= "") then
		Interface.openWindow(sClass, sRecord);
	else
		local sAsset = wBlock.image.getAsset();
		if (sAsset or "") ~= "" then
			local wPreview = Interface.openWindow("asset_preview", "");
			if wPreview then
				wPreview.setData(sAsset, "image");
			end
		end
	end
end

--
--	STORY (ADVANCED) - UI - COPY/PASTE
--

function registerCopyPasteToolbarButtons()
	ToolbarManager.registerButton("story_copy",
		{
			sType = "action",
			sIcon = "button_toolbar_copy",
			sTooltipRes = "record_toolbar_copy",
			fnActivate = StoryManager.onCopyButtonPressed,
			bHostOnly = true,
		});
	ToolbarManager.registerButton("story_paste",
		{
			sType = "action",
			sIcon = "button_toolbar_paste",
			sTooltipRes = "record_toolbar_paste",
			fnOnInit = StoryManager.onPasteButtonInit,
			fnActivate = StoryManager.onPasteButtonPressed,
			bHostOnly = true,
		});
end
function onCopyButtonPressed(c)
	StoryManager.performRecordCopy(c.window);
end
function onPasteButtonInit(c)
	c.update();
end
function onPasteButtonPressed(c)
	StoryManager.performRecordPaste(c.window);
end

local _sPasteRecord = "";
function hasPasteRecord()
	return (_sPasteRecord ~= "");
end
function getPasteRecord()
	return _sPasteRecord;
end
function setPasteRecord(sRecord)
	if _sPasteRecord == sRecord then
		return;
	end
	_sPasteRecord = sRecord or "";
	StoryManager.onPasteRecordChangeEvent();
end
function onPasteRecordChangeEvent()
	local tManualWindows = Interface.getWindows("reference_manual");
	for _,w in ipairs(tManualWindows) do
		WindowManager.callInnerFunction(w, "onStoryPasteChanged");
	end

	local tStoryWindows = Interface.getWindows("referencemanualpage");
	for _,w in ipairs(tStoryWindows) do
		WindowManager.callInnerFunction(w, "onStoryPasteChanged");
	end
end

function performRecordCopy(wRecord)
	if not wRecord then
		return;
	end
	StoryManager.setPasteRecord(wRecord.getDatabasePath())
end
function performRecordPaste(wRecord)
	if not wRecord then
		return;
	end
	local sPasteRecord = StoryManager.getPasteRecord();
	if sPasteRecord == "" then
		return;
	end 

	local nodeRecord = wRecord.getDatabaseNode();
	local tSrcBlockList = DB.getChildList(DB.getPath(sPasteRecord, "blocks"));
	if #tSrcBlockList > 0 then
		local nodeTargetBlocks = DB.createChild(nodeRecord, "blocks");
		if nodeTargetBlocks then
			for _,nodeSrcBlock in ipairs(tSrcBlockList) do
				DB.createChildAndCopy(nodeTargetBlocks, nodeSrcBlock);
			end
		end
	end
	StoryManager.onRecordNodeRebuild(nodeRecord);

	StoryManager.setPasteRecord("");
end

--
--	Backward compatibility
--

function initRecordLegacyText(wRecord)
	local node = wRecord.getDatabaseNode(); 
	local sOldText = DB.getValue(node, "text");
	if (sOldText or "") == "" then
		return;
	end

	local cText = wRecord.text_legacy;
	if not cText then
		cText = wRecord.createControl("ft_story_advanced_text_legacy", "text_legacy");
	end
end
function migrateRecordLegacyTextToBlock(wRecord)
	local node = wRecord.getDatabaseNode(); 
	local sOldText = DB.getValue(node, "text");
	if (sOldText or "") == "" then
		return;
	end

	local bStatic = DB.isStatic(node);
	if bStatic then
		DB.setStatic(node, false);
		DB.setStatic(wRecord.blocks.getDatabaseNode(), false);
		for _,wChild in ipairs(wRecord.blocks.getWindows()) do
			local nodeChild = wChild.getDatabaseNode();
			DB.setStatic(nodeChild, false);
		end
	end

	local tOrderedChildren = StoryManager.updateOrderValues(wRecord.blocks);
	for kChild,wChild in ipairs(tOrderedChildren) do
		StoryManager.setWindowOrderValue(wChild, kChild + 1);
	end

	local wNew = StoryManager.onBlockAddHelper(wRecord.blocks, 1);
	local nodeBlock = wNew.getDatabaseNode();
	DB.setValue(nodeBlock, "text", "formattedtext", sOldText);
	DB.deleteChild(node, "text");

	if bStatic then
		DB.setStatic(node, true);
		DB.setStatic(wRecord.blocks.getDatabaseNode(), true);
		for _,wChild in ipairs(wRecord.blocks.getWindows()) do
			local nodeChild = wChild.getDatabaseNode();
			DB.setStatic(nodeChild, true);
		end
	end

	if wRecord.text_legacy then
		wRecord.text_legacy.destroy();
	end

	-- Setting block type should come last, since it forces block rebuild
	DB.setValue(nodeBlock, "blocktype", "string", "singletext");
	StoryManager.onBlockNodeRebuild(wNew.getDatabaseNode());

	wRecord.blocks.applySort();
end
