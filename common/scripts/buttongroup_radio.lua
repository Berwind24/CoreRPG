-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _nRadioIndex = 0;
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
	local bResource = false;
	local sLabels = "";
	local sValues = "";
	local nDefault = nil;
	local nWidth = nil;

	if font then
		self.setDisplayFont(font[1]);
	end
	if parameters then
		if parameters[1].font then
			self.setDisplayFont(parameters[1].font[1]);
		end
		if parameters[1].labelsres then
			bResource = true;
			sLabels = parameters[1].labelsres[1];
		elseif parameters[1].labels then
			sLabels = parameters[1].labels[1];
		end
		if parameters[1].values then
			sValues = parameters[1].values[1];
		end
		if parameters[1].optionwidth then
			nWidth = tonumber(parameters[1].optionwidth[1]);
		end
		if parameters[1].defaultindex then
			nDefault = tonumber(parameters[1].defaultindex[1]);
		end
	end
	
	self.initialize(bResource, sLabels, sValues, nWidth, nDefault);
end
function initialize(bResource, sLabels, sValues, nOptionWidth, vDefault)
	if sLabels then
		if bResource then
			_tLabels = StringManager.split(sLabels, "|", true);
			for k,v in ipairs(_tLabels) do
				_tLabels[k] = Interface.getString(v);
			end
		else
			_tLabels = StringManager.split(sLabels, "|", true);
		end
	end
	if sValues then
		_tValues = StringManager.split(sValues, "|", true);
	end
	if nOptionWidth then
		self.setOptionWidth(nOptionWidth);
	end
	if vDefault then
		if type(vDefault) == "string" then
			self.matchData(sDefault);
			self.setDefaultIndex(self.getIndex());
		elseif type(vDefault) == "number" then
			self.matchData(_tValues[vDefault]);
			self.setDefaultIndex(self.getIndex());
		end
	end
end

local _nDefaultIndex = 1;
function getDefaultIndex()
	return _nDefaultIndex;
end
function setDefaultIndex(n)
	_nDefaultIndex = n;
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
	end
end
function matchData(s)
	local nMatch = 0;
	for k,v in pairs(_tValues) do
		if v == s then
			_nRadioIndex = k;
			return;
		end
	end
	_nRadioIndex = self.getDefaultIndex();
end

function getDatabaseNode()
	local sSource = self.getSource();
	if sSource ~= "" then
		return DB.findNode(sSource);
	end
	return nil;
end
function getIndex()
	return _nRadioIndex;
end
function setIndex(n)
	if n <= 0 or n > #_tValues then
		n = self.getDefaultIndex();
	end
	if _nRadioIndex == n then
		return;
	end
	self.setStringValue(_tValues[n]);
end
function getStringValue()
	local sSource = self.getSource();
	if sSource ~= "" then
		return DB.getValue(sSource, "");
	end
	return _tValues[_nRadioIndex];
end
function setStringValue(srcval)
	local sSource = self.getSource();
	if sSource ~= "" then
		DB.setValue(sSource, "string", srcval);
	else
		self.matchData(srcval)
		self.update();
	end
end

--
--	UI DISPLAY
--

local _tLabelWidgets = {};
local _tBoxWidgets = {};
function initDisplay()
	-- Clean up previous values, if any
	for k, v in pairs(_tLabelWidgets) do
		v.destroy();
	end
	_tLabelWidgets = {};
	for k, v in pairs(_tBoxWidgets) do
		v.destroy();
	end
	_tBoxWidgets = {};
	
	-- Create a set of widgets for each option
	nOptionWidth = self.getOptionWidth();
	for k,v in ipairs(_tValues) do
		-- Create a label widget
		local w = 0;
		local h = 0;
		if _tLabels[k] then
			_tLabelWidgets[k] = addTextWidget({ font = self.getDisplayFont(), text = _tLabels[k] });
			w,h = _tLabelWidgets[k].getSize();
			_tLabelWidgets[k].setPosition("topleft", ((k - 1)*nOptionWidth) + (w / 2) + 20, h / 2);
		end
		
		-- Create the checkbox widget
		_tBoxWidgets[k] = addBitmapWidget(stateicons[1].off[1]);
		if h == 0 then
			w,h = _tBoxWidgets[k].getSize();
		end
		_tBoxWidgets[k].setPosition("topleft", ((k - 1) * nOptionWidth) + 10, h / 2);
	end

	-- Set the width of the control
	setAnchoredWidth(#_tValues * nOptionWidth);
	
	-- Set the right display
	self.updateDisplay();
end
function updateDisplay()
	for k,v in ipairs(_tBoxWidgets) do
		if _nRadioIndex == k then
			v.setBitmap(stateicons[1].on[1]);
		else
			v.setBitmap(stateicons[1].off[1]);
		end
	end
end

local _sLabelFont = "sheetlabel";
function getDisplayFont()
	return _sLabelFont;
end
function setDisplayFont(s)
	_sLabelFont = s or "sheetlabel";
end

local _nOptionWidth = 50;
function getOptionWidth()
	return _nOptionWidth;
end
function setOptionWidth(n)
	local nNew = n or 50;
	if _nOptionWidth == nNew then
		return;
	end
	_nOptionWidth = nNew;
	self.initDisplay();
end

--
--	UI BEHAVIORS
--

function onClickDown(button, x, y)
	return true;
end
function onClickRelease(button, x, y)
	if isReadOnly() then
		return true;
	end
	self.setIndex(math.floor(x / self.getOptionWidth()) + 1);
	return true;
end
