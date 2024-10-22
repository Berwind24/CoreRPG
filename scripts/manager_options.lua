-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _tGroups = {};
local _tOptions = {};
local _tCallbacks = {};

local _tButtons = {};

function isMouseWheelEditEnabled()
	return Input.isControlPressed();
end

function onTabletopInit()
	Comm.registerSlashHandler("option", OptionsManager.processOption, "[option_name] <option_value>");
	DB.addHandler("options.*", "onUpdate", OptionsManager.onOptionChanged);
end

function processOption(sCommand, sParams)
	local aWords = StringManager.parseWords(sParams, "%._");
	if #aWords >= 1 then
		local sOptionKey = aWords[1];

		if _tOptions[sOptionKey] then
			local sOptionLabel = OptionsManager.getOptionLabel(sOptionKey);
			if #aWords >= 2 then
				local sOptionValue = aWords[2];
				OptionsManager.setOption(sOptionKey, sOptionValue);
				local sOptionValueLabel = OptionsManager.getOptionValueLabel(sOptionKey, sOptionValue);
				ChatManager.SystemMessage(string.format(Interface.getString("option_command_result_set"), sOptionLabel, sOptionValueLabel));
			else
				local sOptionValue = OptionsManager.getOption(sOptionKey);
				local sOptionValueLabel = OptionsManager.getOptionValueLabel(sOptionKey, sOptionValue);
				ChatManager.SystemMessage(string.format(Interface.getString("option_command_result_get"), sOptionLabel, sOptionValueLabel));
			end
		else
			ChatManager.SystemMessage(string.format(Interface.getString("option_command_error_not_registered"), sOptionKey));
		end
	end
end

function populate(w)
	OptionsManager.populateList(w);
	OptionsManager.populateButtons(w);
end
function populateList(w)
	w.list.closeAll();

	local sFilterLower = (w.filter and w.filter.getValue() or ""):lower();
	for _, tGroup in pairs(_tGroups) do
		if (sFilterLower == "") or tGroup.sLabel:lower():match(sFilterLower) then
			OptionsManager.populateListGroup(w, tGroup);
		else
			for _, rOption in pairs(tGroup.tOptions) do
				if rOption.sLabel:lower():match(sFilterLower) then
					OptionsManager.populateListGroup(w, tGroup, sFilterLower);
					break;
				end
			end
		end
	end

	w.list.applySort();
end
function populateListGroup(w, tGroup, sFilterLower)
	local winSet = w.list.createWindow();
	if not winSet then
		return;
	end

	winSet.label.setValue(tGroup.sLabel);
	winSet.sort.setValue(tGroup.nOrder);

	for _, rOption in pairs(tGroup.tOptions) do
		if ((sFilterLower or "") == "") or rOption.sLabel:lower():match(sFilterLower) then
			local winOption = winSet.options_list.createWindowWithClass(rOption.sType);
			if winOption then
				winOption.setLabel(rOption.sLabel);
				winOption.initialize(rOption.sKey, rOption.aCustom);
				winOption.setReadOnly(not (rOption.bLocal or Session.IsHost));
			end
		end
	end
	
	winSet.options_list.applySort();
end
function populateButtons(w)
	w.list_buttons.closeAll();

	local sFilterLower = (w.filter and w.filter.getValue() or ""):lower();
	for _,tButton in pairs(_tButtons) do
		local sLabel = Interface.getString(tButton.sLabelRes);
		if (sFilterLower == "") or sLabel:lower():match(sFilterLower) then
			local winButton = w.list_buttons.createWindow();
			if winButton then
				winButton.setData(tButton);
			end
		end
	end
end

function isOptionRegistered(sKey)
	if _tOptions[sKey] then
		return true;
	end
	return false;
end
function registerOption(sKey, bLocal, sGroup, sLabel, sOptionType, aCustom)
	OptionsManager.deleteOption(sKey);
	
	local rOption = {};
	rOption.sKey = sKey;
	rOption.bLocal = bLocal;
	rOption.sLabel = sLabel;
	rOption.aCustom = aCustom;
	rOption.sType = sOptionType;
	
	_tOptions[sKey] = rOption;
	_tOptions[sKey].value = "";

	OptionsManager.addOptionToGroup(rOption, sGroup);
end
function registerOption2(sKey, bLocal, sGroupRes, sLabelRes, sOptionType, aCustom)
	local sGroup = Interface.getString(sGroupRes);
	local sLabel = Interface.getString(sLabelRes);

	if aCustom.labels then
		local aLabels = StringManager.split(aCustom.labels, "|", true);
		for k,v in ipairs(aLabels) do
			local sLabel = Interface.getString(v);
			if sLabel ~= "" then
				aLabels[k] = Interface.getString(v);
			end
		end
		aCustom.labels = table.concat(aLabels, "|");
	end
	if aCustom.labelsraw then
		aCustom.labels = aCustom.labelsraw;
	end
	aCustom.baselabel = Interface.getString(aCustom.baselabel);
	
	OptionsManager.registerOption(sKey, bLocal, sGroup, sLabel, sOptionType, aCustom);
end
function deleteOption(sKey)
	if _tOptions[sKey] then
		local bFound = false;
		for _, tGroup in pairs(_tGroups) do
			for kOption, rOption in pairs(tGroup.tOptions) do
				if rOption.sKey == sKey then
					bFound = true;
					table.remove(tGroup.tOptions, kOption);
					break;
				end
			end
			if bFound then
				if #tGroup.tOptions <= 0 then
					_tGroups[tGroup.sLabel] = nil;
				end
				break;
			end
		end
		
		_tOptions[sKey] = nil;
	end
end

function addOptionToGroup(rOption, sGroup)
	local tGroup = _tGroups[sGroup];
	if not tGroup then
		tGroup = { };
		tGroup.sLabel = sGroup;
		tGroup.nOrder = OptionsManager.getNewGroupOrder(sGroup)
		tGroup.tOptions = { };

		_tGroups[sGroup] = tGroup;
	end

	table.insert(tGroup.tOptions, rOption);
end
function getNewGroupOrder(sGroup)
	if sGroup == Interface.getString("option_header_client") then
		return 1;
	elseif sGroup == Interface.getString("option_header_game") then
		return 2;
	elseif sGroup == Interface.getString("option_header_combat") then
		return 3;
	elseif sGroup == Interface.getString("option_header_token") then
		return 4;
	elseif sGroup == Interface.getString("option_header_houserule") then
		return 5;
	else
		local nMax = 5;
		for _, tGroup in pairs(_tGroups) do
			nMax = math.max(nMax, tGroup.nOrder);
		end
		return nMax + 1;
	end		
end

function registerButton(sLabelRes, sClass, sRecord)
	_tButtons[sLabelRes] = { sLabelRes = sLabelRes, sClass = sClass, sRecord = sRecord };
end
function unregisterButton(sLabelRes)
	_tButtons[sLabelRes] = nil;
end

function onOptionChanged(nodeOption)
	local sKey = DB.getName(nodeOption);
	CampaignRegistry["Opt" .. sKey] = getOption(sKey);
	OptionsManager.makeCallback(sKey);
end

function registerCallback(sKey, fn)
	UtilityManager.registerKeyCallback(_tCallbacks, sKey, fn);
end
function unregisterCallback(sKey, fn)
	UtilityManager.unregisterKeyCallback(_tCallbacks, sKey, fn);
end
function makeCallback(sKey)
	UtilityManager.performAllKeyCallbacks(_tCallbacks, sKey, sKey);
end

function isOption(sKey, sTargetValue)
	return (OptionsManager.getOption(sKey) == sTargetValue);
end
function setOption(sKey, sValue)
	if _tOptions[sKey] then
		CampaignRegistry["Opt" .. sKey] = sValue;
		if _tOptions[sKey].bLocal then
			OptionsManager.makeCallback(sKey);
		else
			if Session.IsHost then
				DB.setValue("options." .. sKey, "string", sValue);
			end
		end
	end
end
function getOption(sKey)
	if _tOptions[sKey] then
		local sValue = "";
		if _tOptions[sKey].bLocal then
			if CampaignRegistry["Opt" .. sKey] then
				sValue = CampaignRegistry["Opt" .. sKey];
			end
		else
			sValue = DB.getValue("options." .. sKey, "");
		end
		if sValue ~= "" then
			return sValue;
		end

		return (_tOptions[sKey].aCustom.default) or "";
	end

	return "";
end

function addOptionValue(sKey, sLabel, sValue, bUseResource)
	local rOption = _tOptions[sKey];
	if rOption and rOption.aCustom then
		if bUseResource then
			sLabel = Interface.getString(sLabel);
		end
		
		if rOption.aCustom.labels and (rOption.aCustom.labels ~= "") then
			rOption.aCustom.labels = rOption.aCustom.labels .. "|" .. sLabel;
		else
			rOption.aCustom.labels = sLabel;
		end
		
		if rOption.aCustom.values and (rOption.aCustom.values ~= "") then
			rOption.aCustom.values = rOption.aCustom.values .. "|" .. sValue;
		else
			rOption.aCustom.values = sValue;
		end
	end
end
function setOptionDefault(sKey, sDefaultValue)
	local rOption = _tOptions[sKey];
	if rOption and rOption.aCustom then
		_tOptions[sKey].aCustom.default = sDefaultValue;
	end
end
function getOptionLabel(sKey)
	local rOption = _tOptions[sKey];
	if rOption then
		return rOption.sLabel or "";
	end
	return "";
end
function getOptionValueLabel(sKey, sValue)
	local rOption = _tOptions[sKey];
	if rOption and rOption.aCustom then
		local nValue = 0;
		local tValues = StringManager.split(rOption.aCustom.values, "|", true);
		for k,v in ipairs(tValues) do
			if v == sValue then
				nValue = k;
				break;
			end
		end

		if nValue > 0 then
			local tLabels = StringManager.split(rOption.aCustom.labels, "|", true);
			if tLabels[nValue] then
				return tLabels[nValue];
			end
		end
		return rOption.aCustom.baselabel or "";
	end
	return "";
end
