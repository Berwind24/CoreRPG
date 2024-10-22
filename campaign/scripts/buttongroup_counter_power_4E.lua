-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local bInit = false;
local _bIncrementEnabled = true;

local slots = {};
local nMaxSlotRow = 10;
local nDefaultSpacing = 10;
local nSpacing = nDefaultSpacing;

function onInit()
	-- Get any custom fields
	if maxslotperrow then
		nMaxSlotRow = tonumber(maxslotperrow[1]) or 10;
	end
	if spacing then
		nSpacing = tonumber(spacing[1]) or nDefaultSpacing;
	end
	if allowsinglespacing then
		setAnchoredHeight(nSpacing);
	else
		setAnchoredHeight(nSpacing*2);
	end
	setAnchoredWidth(nSpacing);

	local node = window.getDatabaseNode();
	DB.addHandler(DB.getPath(node, "prepared"), "onUpdate", update);
	DB.addHandler(DB.getPath(node, "used"), "onUpdate", update);

	bInit = true;
	
	self.updateSlots();
end
function onClose()
	bInit = false;
	
	local node = window.getDatabaseNode();
	DB.removeHandler(DB.getPath(node, "prepared"), "onUpdate", update);
	DB.removeHandler(DB.getPath(node, "used"), "onUpdate", update);
end

function onWheel(notches)
	if isReadOnly() then
		return;
	end
	if not Input.isControlPressed() then
		return false;
	end
	
	if _bIncrementEnabled or notches < 0 then
		self.adjustCounter(notches);
	end
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

	local nClickH = math.floor(x / nSpacing) + 1;
	local nClickV;
	if m > nMaxSlotRow then
		nClickV	= math.floor(y / nSpacing);
	else
		nClickV = 0;
	end
	local nClick = (nClickV * nMaxSlotRow) + nClickH;

	if nClick > c then
		if not _bIncrementEnabled then
			return true;
		end
		self.adjustCounter(1);
	else
		self.adjustCounter(-1);
	end

	if self.getCurrentValue() > c then
		PowerManagerCore.usePower(window.getDatabaseNode());
	end
	
	return true;
end

function update()
	self.updateSlots();

	window.onUsedChanged();
end
function updateSlots()
	local m = self.getMaxValue();
	local c = self.getCurrentValue();
	
	if #slots ~= m then
		-- Clear
		for k, v in ipairs(slots) do
			v.destroy();
		end
		
		slots = {};
		
		-- Build slots
		for i = 1, m do
			local sIcon;
			local sColor = "FFFFFFFF";
			if i > c then
				if _bIncrementEnabled then
					sIcon = stateicons[1].off[1];
				else
					sIcon = stateicons[1].on[1];
					sColor = "4FFFFFFF";
				end
			else
				sIcon = stateicons[1].on[1];
			end

			local nW = (i - 1) % nMaxSlotRow;
			local nH = math.floor((i - 1) / nMaxSlotRow);
			local nX = (nSpacing * nW) + math.floor(nSpacing / 2);
			local nY;
			if m > nMaxSlotRow then
				nY = (nSpacing * nH) + math.floor(nSpacing / 2);
			else
				nY = (nSpacing * nH) + nSpacing;
			end
			
			slots[i] = addBitmapWidget({ icon = sIcon, color = sColor, position="topleft", x = nX, y = nY });
		end
		
		if m > nMaxSlotRow then
			setAnchoredWidth(nMaxSlotRow * nSpacing);
			setAnchoredHeight((math.floor((m - 1) / nMaxSlotRow) + 1) * nSpacing);
		else
			setAnchoredWidth(m * nSpacing);
			setAnchoredHeight(nSpacing * 2);
		end
	else
		for i = 1, m do
			if i > c then
				if _bIncrementEnabled then
					slots[i].setBitmap(stateicons[1].off[1]);
					slots[i].setColor("FFFFFFFF");
				else
					slots[i].setBitmap(stateicons[1].on[1]);
					slots[i].setColor("4FFFFFFF");
				end
			else
				slots[i].setBitmap(stateicons[1].on[1]);
				slots[i].setColor("FFFFFFFF");
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
	return DB.getValue(window.getDatabaseNode(), "prepared", 0);
end
function setMaxValue(nNewValue)
	return DB.setValue(window.getDatabaseNode(), "prepared", "number", nNewValue);
end

function getCurrentValue()
	return DB.getValue(window.getDatabaseNode(), "used", 0);
end
function setCurrentValue(nNewValue)
	return DB.setValue(window.getDatabaseNode(), "used", "number", nNewValue);
end

-- Enables/Disables incrementing, can still decrement
function disable()
	_bIncrementEnabled = false;
	updateSlots();
end
function enable()
	_bIncrementEnabled = true;
	updateSlots();
end
