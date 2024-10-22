-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _nCycleIndex = 0;
local _tLabels = {};
local _tValues = {};

function onInit()
	self.initDisplayData();
	self.initDisplay();
	self.initSource();
end
function onClose()
	self.setSource("");
end

--
--	DISPLAY DATA
--

function initDisplayData()
	local sLabels = "";
	local sValues = "";
	local sDefaultLabel = "";
	if parameters then
		if parameters[1].labelsres then
			sLabels = parameters[1].labelsres[1];
			if sLabels then
				local tSplitLabelRes = StringManager.split(sLabels, "|", true);
				local tLabels = {};
				for k,v in ipairs(tSplitLabelRes) do
					tLabels[k] = Interface.getString(v);
				end
				sLabels = table.concat(tLabels, "|");
			end
		elseif parameters[1].labels then
			sLabels = parameters[1].labels[1];
		end
		if parameters[1].values then
			sValues = parameters[1].values[1];
		end
		if parameters[1].defaultlabelres then
			sDefaultLabel = Interface.getString(parameters[1].defaultlabelres[1]);
		elseif parameters[1].defaultlabel then
			sDefaultLabel = parameters[1].defaultlabel[1];
		end
	end

	self.initialize(sLabels, sValues, sDefaultLabel);
end
function initialize(sLabels, sValues, sEmptyLabel, sInitialValue)
	if sLabels then
		_tLabels = StringManager.split(sLabels, "|", true);
	end
	if sValues then
		_tValues = StringManager.split(sValues, "|", true);
	end
	if sEmptyLabel then
		self.setEmptyValue(sEmptyLabel);
	end
	if sInitialValue then
		self.matchData(sInitialValue);
	end
end
function initialize2(sLabels, sValues, sEmptyLabel, sInitialValue)
	if sLabels then
		_tLabels = StringManager.split(sLabels, "|", true);
		for k,v in ipairs(_tLabels) do
			_tLabels[k] = Interface.getString(v);
		end
	end
	if sValues then
		_tValues = StringManager.split(sValues, "|", true);
	end
	if sEmptyLabel then
		self.setEmptyValue(Interface.getString(sEmptyLabel));
	end
	if sInitialValue then
		self.matchData(sInitialValue);
	end
end

local _sEmptyValue = "-";
function getEmptyValue()
	return _sEmptyValue or "";
end
function setEmptyValue(s)
	_sEmptyValue = s;
end

--
--	DATA SOURCE
--

function initSource()
	if sourceless then
		self.setSource("");
	elseif source and source[1] and source[1].name then
		self.setSourceField(source[1].name[1]);
	else
		self.setSourceField(getName());
	end
end

local _sSource = "";
function setSourceField(sField)
	self.setSource(DB.getPath(window.getDatabaseNode(), sField));
end
function getSource()
	return _sSource;
end
function setSource(sPath)
	if _sSource == sPath then
		self.updateDisplay();
		return;
	end

	local node = window.getDatabaseNode();

	if _sSource ~= "" then
		DB.removeHandler(_sSource, "onAdd", self.update);
		DB.removeHandler(_sSource, "onUpdate", self.update);
	end

	_sSource = sPath or "";

	if _sSource ~= "" then
		DB.createNode(_sSource, "string");
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
	local sSource = self.getSource();
	if sSource ~= "" then
		self.matchData(DB.getValue(sSource, ""));
	else
		self.matchData("");
	end
end
function matchData(s)
	local nMatch = 0;
	for k,v in pairs(_tValues) do
		if v == s then
			nMatch = k;
		end
	end

	if nMatch > 0 then
		_nCycleIndex = nMatch;
	else
		_nCycleIndex = 0;
	end
end

function getDatabaseNode()
	local sSource = self.getSource();
	if sSource ~= "" then
		return DB.findNode(sSource);
	end
	return nil;
end
function getValue()
	if _nCycleIndex > 0 and _nCycleIndex <= #_tLabels then
		return _tLabels[_nCycleIndex];
	end
	return self.getEmptyValue();
end
function getStringValue()
	if _nCycleIndex > 0 and _nCycleIndex <= #_tValues then
		return _tValues[_nCycleIndex];
	end
	return "";
end
function setStringValue(srcval)
	local sSource = self.getSource();
	if sSource ~= "" then
		DB.setValue(sSource, "string", srcval);
	else
		self.matchData(srcval);
		self.updateDisplay();

		if self.onValueChanged then
			self.onValueChanged();
		end
	end
end

--
--	UI DISPLAY
--

local _widgetText = nil;
function initDisplay()
	local sFont = "sheettext";
	if font then
		sFont = font[1];
	end
	local sFontColor = "";
	if color then
		sFontColor = color[1];
	end

	_widgetText = addTextWidget({ font = sFont, text = "" });
	if (sFontColor or "") ~= "" then
		_widgetText.setColor(sFontColor);
	end

	self.updateDisplay();
end
function updateDisplay()
	if not _widgetText then
		return;
	end
	
	if _nCycleIndex > 0 and _nCycleIndex <= #_tLabels then
		_widgetText.setText(_tLabels[_nCycleIndex]);
	else
		_widgetText.setText(self.getEmptyValue());
	end
	if alignleft then
		local w,_ = _widgetText.getSize();
		_widgetText.setPosition("left", math.floor(w/2), 0);
	elseif alignright then
		local w,_ = _widgetText.getSize();
		_widgetText.setPosition("right", -math.floor(w/2), 0);
	end
end

function setDisplayColor(sColor)
	_widgetText.setColor(sColor);
end
function setDisplayFont(sFont)
	_widgetText.setFont(sFont);
end

--
--	UI BEHAVIORS
--

function onClickDown(button, x, y)
	return true;
end
function onClickRelease(button, x, y)
	if not isReadOnly() then
		self.cycleLabel(Input.isControlPressed());
	end
	return true;
end
function cycleLabel(bBackward)
	if bBackward then
		if _nCycleIndex > 0 then
			_nCycleIndex = _nCycleIndex - 1;
		else
			_nCycleIndex = #_tLabels;
		end
	else
		if _nCycleIndex < #_tLabels then
			_nCycleIndex = _nCycleIndex + 1;
		else
			_nCycleIndex = 0;
		end
	end

	local sSource = self.getSource();
	if sSource ~= "" then
		DB.setValue(sSource, "string", getStringValue());
	else
		self.updateDisplay();
		if self.onValueChanged then
			self.onValueChanged();
		end
	end
end
