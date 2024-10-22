-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _bInit = false;

local _tSlots = {};
local _nMaxSlotsPerRow = 10;
local _nDefaultSpacing = 10;
local _nSpacing = _nDefaultSpacing;

local _sMaxNodeName = "";
local _sCurrNodeName = "";

local _nLocalMax = 0;
local _nLocalCurrent = 0;

function onInit()
	-- Get any custom fields
	if values then
		if values[1].maximum then
			_nLocalMax = tonumber(values[1].maximum[1]) or 0;
		end
		if values[1].current then
			_nLocalCurrent = tonumber(values[1].current[1]) or 0;
		end
	end
	if maxslotperrow then
		_nMaxSlotsPerRow = tonumber(maxslotperrow[1]) or 10;
	end

	-- Synch to the data nodes
	local nodeWin = window.getDatabaseNode();
	if nodeWin then
		local sLoadMaxNodeName = "";
		local sLoadCurrNodeName = "";
		
		if sourcefields then
			if sourcefields[1].maximum then
				sLoadMaxNodeName = sourcefields[1].maximum[1];
			end
			if sourcefields[1].current then
				sLoadCurrNodeName = sourcefields[1].current[1];
			end
		end
		
		if sLoadMaxNodeName ~= "" then
			if not DB.getValue(nodeWin, sLoadMaxNodeName) then
				DB.setValue(nodeWin, sLoadMaxNodeName, "number", 1);
			end
			self.setMaxNode(DB.getPath(nodeWin, sLoadMaxNodeName));
		end
		if sLoadCurrNodeName ~= "" then
			self.setCurrNode(DB.getPath(nodeWin, sLoadCurrNodeName));
		end
	end
	
	if spacing then
		_nSpacing = tonumber(spacing[1]) or _nDefaultSpacing;
	end
	if allowsinglespacing then
		setAnchoredHeight(_nSpacing);
	else
		setAnchoredHeight(_nSpacing * 2);
	end
	setAnchoredWidth(_nSpacing);

	_bInit = true;
	
	self.updateSlots();

	registerMenuItem(Interface.getString("counter_menu_clear"), "erase", 4);
end
function onClose()
	_bInit = false;
	
	self.setMaxNode("");
	self.setCurrNode("");
end

function onMenuSelection(selection)
	if selection == 4 then
		self.setCurrentValue(0);
	end
end
function onWheel(notches)
	if isReadOnly() then
		return;
	end
	if not Input.isControlPressed() then
		return false;
	end

	self.adjustCounter(notches);
	return true;
end
function onClickDown(button, x, y)
	if isReadOnly() then
		return;
	end
	return true;
end
function onClickRelease(button, x, y)
	if isReadOnly() then
		return;
	end
	
	local m = self.getMaxValue();
	local c = self.getCurrentValue();

	local nClickH = math.floor(x / _nSpacing) + 1;
	local nClickV;
	if m > _nMaxSlotsPerRow then
		nClickV	= math.floor(y / _nSpacing);
	else
		nClickV = 0;
	end
	local nClick = (nClickV * _nMaxSlotsPerRow) + nClickH;

	if nClick > c then
		self.adjustCounter(1);
	else
		self.adjustCounter(-1);
	end

	return true;
end

function update()
	self.updateSlots();
	
	if self.onValueChanged then
		self.onValueChanged();
	end
end
function updateSlots()
	if not _bInit then
		return;
	end
	
	self.checkBounds();

	local m = self.getMaxValue();
	local c = self.getCurrentValue();
	
	if #_tSlots ~= m then
		-- Clear
		for _,v in ipairs(_tSlots) do
			v.destroy();
		end
		_tSlots = {};

		-- Build slots
		for i = 1, m do
			local sIcon;
			if i > c then
				sIcon = stateicons[1].off[1];
			else
				sIcon = stateicons[1].on[1];
			end
			
			local nW = (i - 1) % _nMaxSlotsPerRow;
			local nH = math.floor((i - 1) / _nMaxSlotsPerRow);
			local nX = (_nSpacing * nW) + math.floor(_nSpacing / 2);
			local nY;
			if m > _nMaxSlotsPerRow or allowsinglespacing then
				nY = (_nSpacing * nH) + math.floor(_nSpacing / 2);
			else
				nY = (_nSpacing * nH) + _nSpacing;
			end

			_tSlots[i] = addBitmapWidget({ icon = sIcon, position = "topleft", x = nX, y = nY });
		end
		
		if m > _nMaxSlotsPerRow then
			setAnchoredWidth(_nMaxSlotsPerRow * _nSpacing);
			setAnchoredHeight((math.floor((m - 1) / _nMaxSlotsPerRow) + 1) * _nSpacing);
		else
			setAnchoredWidth(m * _nSpacing);
			if allowsinglespacing then
				setAnchoredHeight(_nSpacing);
			else
				setAnchoredHeight(_nSpacing * 2);
			end
		end
	else
		for i = 1, m do
			if i > c then
				_tSlots[i].setBitmap(stateicons[1].off[1]);
			else
				_tSlots[i].setBitmap(stateicons[1].on[1]);
			end
		end
	end
end

function adjustCounter(nAdj)
	local m = self.getMaxValue();
	local c = self.getCurrentValue() + nAdj;
	
	if c > m then
		self.setCurrentValue(m);
	elseif c < 0 then
		self.setCurrentValue(0);
	else
		self.setCurrentValue(c);
	end
end
function checkBounds()
	local m = self.getMaxValue();
	local c = self.getCurrentValue();
	
	if c > m then
		self.setCurrentValue(m);
	elseif c < 0 then
		self.setCurrentValue(0);
	end
end

function getMaxValue()
	if _sMaxNodeName ~= "" then
		return DB.getValue(_sMaxNodeName, 0);
	end
	return _nLocalMax;
end
function setMaxValue(n)
	if _sMaxNodeName ~= "" then
		DB.setValue(_sMaxNodeName, "number", n);
	else
		_nLocalMax = n;
	end
end
function setMaxNode(sNewMaxNodeName)
	if _sMaxNodeName ~= "" then
		DB.removeHandler(_sMaxNodeName, "onUpdate", self.update);
	end
	_sMaxNodeName = sNewMaxNodeName;
	if _sMaxNodeName ~= "" then
		DB.addHandler(_sMaxNodeName, "onUpdate", self.update);
	end
	self.updateSlots();
end

function getCurrentValue()
	if _sCurrNodeName ~= "" then
		return DB.getValue(_sCurrNodeName, 0);
	end
	return _nLocalCurrent;
end
function setCurrentValue(n)
	if _sCurrNodeName ~= "" then
		DB.setValue(_sCurrNodeName, "number", n);
	else
		_nLocalCurrent = n;
	end
end
function setCurrNode(sNewCurrNodeName)
	if _sCurrNodeName ~= "" then
		DB.removeHandler(_sCurrNodeName, "onUpdate", self.update);
	end
	_sCurrNodeName = sNewCurrNodeName;
	if _sCurrNodeName ~= "" then
		DB.addHandler(_sCurrNodeName, "onUpdate", self.update);
	end
	self.updateSlots();
end
