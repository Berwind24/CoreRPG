-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _nIndex = 0;
function getIndex()
	return _nIndex;
end
function setIndex(n)
	_nIndex = n;
end

local _tTabs = {};
function getTabCount()
	return #_tTabs;
end
function getTabData(n)
	return _tTabs[n];
end
function setTabData(n, tData)
	if not tData then
		self.clearTabData(n);
		return;
	end

	if n == self.getIndex() then
		self.deactivateTabEntry(n);
	end
	WindowTabManager.cleanupTabDisplay(window, _tTabs[n], tData);

	_tTabs[n] = UtilityManager.copyDeep(tData);
	self.updateTabButton(n, tData);

	WindowTabManager.updateTabDisplay(w, tData);
	if n == self.getIndex() then
		self.activateTabEntry(n);
	end
end
function clearTabData(n)
	_tTabs[n] = nil;
	self.cleanupTabButton(n);
end
function getTabsData()
	return _tTabs;
end
function setTabsData(tTabs)
	if not tTabs then
		return;
	end

	self.deactivateTabEntry(self.getIndex());
	self.setIndex(0);

	local nActivate = 1;
	local nCount = math.max(self.getTabCount(), #tTabs);
	for i = 1, nCount do
		local t = tTabs[i];
		if t then
			self.setTabData(i, t);
			if t.bActivate then
				nActivate = i;
			end
			self.deactivateTabEntry(i)
		else
			self.clearTabData(i);
		end
	end
	
	self.activateTab(nActivate, true);
end
function getTabIndexByName(s)
	local nIndex = 0;
	for i = 1, self.getTabCount() do
		local tData = self.getTabData(i);
		if tData.sName == s then
			nIndex = i;
			break;
		end
	end
	return nIndex;	
end

function activateTabByName(s)
	local nIndex = 0;
	for i = 1, self.getTabCount() do
		local tData = self.getTabData(i);
		if tData.sName == s then
			nIndex = i;
			break;
		end
	end
	self.activateTab(nIndex);
end
function activateTab(n, bForceUpdate)
	local nCurrIndex = self.getIndex();
	local nNewIndex = tonumber(n) or 1;
	if not bForceUpdate and (nCurrIndex == nNewIndex) then
		return;
	end
	
	self.deactivateTabEntry(nCurrIndex);
	self.setIndex(nNewIndex);
	self.activateTabEntry(nNewIndex);
end
function activateTabEntry(n)
	if n >= 1 and n <= self.getTabCount() then
		WindowTabManager.updateTabDisplay(window, self.getTabData(n), true);
		WindowTabManager.setTabDisplayVisible(window, self.getTabData(n), true);
	end
	self.updateTabButtonsDisplay();
end
function deactivateTabEntry(n)
	if n >= 1 and n <= self.getTabCount() then
		WindowTabManager.setTabDisplayVisible(window, self.getTabData(n), false);
	end
end

function getTabButton(n)
	return subwindow["button" .. n];
end
function createTabButton(n)
	return subwindow.createControl("button_content_tab", "button" .. n);
end
function updateTabButton(n, tData)
	local c = self.getTabButton(n);
	if c then
		c.bringToFront();
	else
		c = self.createTabButton(n);
		c.setIndex(n);
	end
	c.setStateText(0, tData.sText or Interface.getString(tData.sTextRes or tData.sTabRes));
end
function cleanupTabButton(n)
	local c = self.getTabButton(n);
	if c then
		c.destroy();
	end
end
function updateTabButtonsDisplay()
	local n = self.getIndex();
	for i = 1, self.getTabCount() do
		local c = self.getTabButton(i);
		if c then
			if i == n then
				c.setValue(1);
			else
				c.setValue(0);
			end
		end
	end
end

function replaceTabClass(n, sClass)
	local tData = self.getTabData(n);
	if not tData then
		return;
	end

	self.deactivateTabEntry(n);
	if (sClass or "") ~= "" then
		tData.sClass = sClass;
		if self.getIndex() == n then
			self.activateTabEntry(n);
		end
	else
		self.clearTabData(n);
	end
	self.updateDisplay();
end
function replaceTabClassByName(sName, sClass)
	for k,tTab in ipairs(self.getTabsData()) do
		if tTab.sName == sName then
			self.replaceTabClass(k, sClass);
			return;
		end
	end
end
