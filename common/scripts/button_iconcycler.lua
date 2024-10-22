-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _nCycleIndex = 0;
local _tIcons = {};
local _tValues = {};
local _tTooltips = {};

function onInit()
	self.initDisplayData();
	self.initSource();
	if self.onCustomInit then
		self.onCustomInit();
	end
end
function onClose()
	self.setSource("");
end

--
--	DISPLAY DATA
--

function initDisplayData()
	if parameters then
		if parameters[1].icons then
			_tIcons = StringManager.split(parameters[1].icons[1], "|", true);
		end
		if parameters[1].values then
			_tValues = StringManager.split(parameters[1].values[1], "|", true);
		end

		if parameters[1].tooltipsres then
			local tooltipsres = StringManager.split(parameters[1].tooltipsres[1], "|", true);
			for _,v in ipairs(tooltipsres) do
				table.insert(_tTooltips, Interface.getString(v));
			end
		elseif parameters[1].tooltips then
			_tTooltips = StringManager.split(parameters[1].tooltips[1], "|", true);
		end

		if parameters[1].nodefault then
			self.setBaseIndex(1);
		else
			if parameters[1].defaulticon then
				_tIcons[0] = parameters[1].defaulticon[1];
				_tValues[0] = "";
			end
			if parameters[1].defaulttooltipres then
				_tTooltips[0] = Interface.getString(parameters[1].defaulttooltipres[1]);
			elseif parameters[1].defaulttooltip then
				_tTooltips[0] = parameters[1].defaulttooltip[1];
			end
		end
	end
end
function addState(sIcon, sValue, sTooltip)
	local nState = #_tIcons + 1;
	
	_tIcons[nState] = sIcon;
	_tValues[nState] = sValue;
	_tTooltips[nState] = sTooltip;
end

local _nBaseIndex = 0;
function setBaseIndex(n)
	_nBaseIndex = n;
end
function getBaseIndex()
	return _nBaseIndex;
end

--
--	DATA SOURCE
--

function initSource()
	if sourceless then
		self.setSource("");
	elseif source and source[1] and source[1].name then
		if source[1].type and source[1].type[1] == "number" then
			self.setSourceField(source[1].name[1], "number");
		else
			self.setSourceField(source[1].name[1]);
		end
	else
		if source and source[1] and source[1].type and source[1].type[1] == "number" then
			self.setSourceField(getName(), "number");
		else
			self.setSourceField(getName());
		end
	end
end

local _sSource = "";
local _sSourceType = "string";
function setSourceField(sField, sFieldType)
	self.setSource(DB.getPath(window.getDatabaseNode(), sField), sFieldType);
end
function getSource()
	return _sSource, _sSourceType;
end
function setSource(sField, sFieldType)
	if _sSource == sField then
		self.updateDisplay();
		return;
	end

	local node = window.getDatabaseNode();

	if _sSource ~= "" then
		DB.removeHandler(_sSource, "onAdd", self.update);
		DB.removeHandler(_sSource, "onUpdate", self.update);
	end

	_sSource = sField or "";
	_sSourceType = sFieldType or "string";

	if _sSource ~= "" then
		local nodeChild = DB.findNode(_sSource);
		if nodeChild then
			if DB.getType(nodeChild) ~= _sSourceType then
				_sSource = "";
			end
		else
			if DB.createNode(_sSource, _sSourceType) then
				local nBaseIndex = self.getBaseIndex();
				if _sSourceType == "number" then
					DB.setValue(_sSource, "number", nBaseIndex);
				else
					DB.setValue(_sSource, "string", _tValues[nBaseIndex]);
				end
			end
		end
		DB.addHandler(_sSource, "onAdd", self.update);
		DB.addHandler(_sSource, "onUpdate", self.update);
		
		self.synchData();

		if DB.isReadOnly(node) then
			setReadOnly(true);
		end
	end

	self.updateDisplay();
end

function update()
	self.synchData();
	self.updateDisplay();
	if self.onValueChanged then
		self.onValueChanged();
	end
end
function synchData()
	local sSource, sSourceType = self.getSource();
	if sSourceType == "number" then
		if sSource ~= "" then
			_nCycleIndex = DB.getValue(sSource, 0);
		else
			_nCycleIndex = self.getBaseIndex();
		end
	else
		local srcval = "";
		if sSource ~= "" then
			srcval = DB.getValue(sSource, "");
		end
		local nMatch = self.getBaseIndex();
		for k, v in pairs(_tValues) do
			if v == srcval then
				nMatch = k;
			end
		end
		_nCycleIndex = nMatch;
	end
end

function getDatabaseNode()
	local sSource = self.getSource();
	if sSource ~= "" then
		return DB.findNode(sSource);
	end
	return nil;
end
function getSourceNode()
	return self.getDatabaseNode();
end
function getIndex()
	return _nCycleIndex;
end
function setIndex(n)
	if type(n) ~= "number" then
		return;
	end

	local sSource, sSourceType = self.getSource();
	if sSource ~= "" then
		if sSourceType == "number" then
			DB.setValue(sSource, "number", n);
		else
			if n >= self.getBaseIndex() and n <= #_tValues then
				DB.setValue(sSource, "string", _tValues[n]);
			else
				DB.setValue(sSource, "string", "");
			end
		end
	else
		local nBaseIndex = self.getBaseIndex();
		if n >= nBaseIndex and n <= #_tIcons then
			_nCycleIndex = n;
		else
			_nCycleIndex = nBaseIndex;
		end
		self.updateDisplay();
		if self.onValueChanged then
			self.onValueChanged();
		end
	end
end
function getStringValue()
	if _nCycleIndex >= self.getBaseIndex() and _nCycleIndex <= #_tValues then
		return _tValues[_nCycleIndex];
	end
	return "";
end
function setStringValue(s)
	if type(s) ~= "string" then
		return;
	end
	
	local sSource, sSourceType = self.getSource();
	if sSource ~= "" then
		if sSourceType == "number" then
			local nMatch = self.getBaseIndex();
			for k, v in pairs(_tValues) do
				if v == s then
					nMatch = k;
				end
			end
			DB.setValue(sSource, "number", nMatch);
		else
			DB.setValue(sSource, "string", s);
		end
	else
		local nMatch = self.getBaseIndex();
		for k, v in pairs(_tValues) do
			if v == s then
				nMatch = k;
			end
		end
		_nCycleIndex = nMatch;
		self.updateDisplay();
		if self.onValueChanged then
			self.onValueChanged();
		end
	end
end

--
--	UI DISPLAY
--

function updateDisplay()
	if not _tIcons[_nCycleIndex] then
		_nCycleIndex = self.getBaseIndex();
	end
	setIcon(_tIcons[_nCycleIndex] or "");
	setTooltipText(_tTooltips[_nCycleIndex] or "");
end

--
--	UI BEHAVIORS
--

function onClickDown(button, x, y)
	return true;
end
function onClickRelease(button, x, y)
	if not isReadOnly() then
		self.cycleIcon(Input.isControlPressed());
	end
	return true;
end
function cycleIcon(bBackward)
	if bBackward then
		if _nCycleIndex > self.getBaseIndex() then
			_nCycleIndex = _nCycleIndex - 1;
		else
			_nCycleIndex = #_tIcons;
		end
	else
		if _nCycleIndex < #_tIcons then
			_nCycleIndex = _nCycleIndex + 1;
		else
			_nCycleIndex = self.getBaseIndex();
		end
	end

	local sSource, sSourceType = self.getSource();
	if sSource ~= "" then
		if sSourceType == "number" then
			DB.setValue(sSource, "number", _nCycleIndex);
		else
			DB.setValue(sSource, "string", self.getStringValue());
		end
	else
		self.updateDisplay();
		if self.onValueChanged then
			self.onValueChanged();
		end
	end
end
