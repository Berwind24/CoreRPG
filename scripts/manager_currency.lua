--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

-- TODO - Deprecate "coinother" ("currency" in SavageWorlds)
-- TODO - Migrate "cashonhand" to currency list or items (CHAFGCOCCOC7ERS, DGA070, MGP3800TRVMG1E, MGP40000TRVMG2E)

CAMPAIGN_CURRENCY_LIST = "currencies";
CAMPAIGN_CURRENCY_LIST_NAME = "name";
CAMPAIGN_CURRENCY_LIST_WEIGHT = "weight";
CAMPAIGN_CURRENCY_LIST_VALUE = "value";

local _bCampaignCurrenciesInit = false;
local _tCampaignCurrencies = {};

function onTabletopInit()
	if Session.IsHost then
		DB.setPublic(DB.createNode(CurrencyManager.CAMPAIGN_CURRENCY_LIST), true);
		if DB.getChildCount(CurrencyManager.CAMPAIGN_CURRENCY_LIST) == 0 then
			CurrencyManager.populateCampaignCurrencies();
		end

		CurrencyManager.addCampaignCurrencyHandlers();
		CurrencyManager.refreshCampaignCurrencies();

		CurrencyManager.setDefaultCurrency(GameSystem.currencyDefault);
	end
end

function populateCampaignCurrencies()
	if not GameSystem.currencies then
		return;
	end

	for _,tCurrency in ipairs(GameSystem.currencies) do
		local nodeCurrency = DB.createChild(CurrencyManager.CAMPAIGN_CURRENCY_LIST);
		DB.setValue(nodeCurrency, CurrencyManager.CAMPAIGN_CURRENCY_LIST_NAME, "string", tCurrency["name"] or tCurrency);
		DB.setValue(nodeCurrency, CurrencyManager.CAMPAIGN_CURRENCY_LIST_WEIGHT, "number", tCurrency["weight"] or 0);
		DB.setValue(nodeCurrency, CurrencyManager.CAMPAIGN_CURRENCY_LIST_VALUE, "number", tCurrency["value"] or 0);
	end
end
function addCampaignCurrencyHandlers()
	DB.addHandler(CurrencyManager.CAMPAIGN_CURRENCY_LIST, "onChildDeleted", CurrencyManager.refreshCampaignCurrencies);
	DB.addHandler(CurrencyManager.CAMPAIGN_CURRENCY_LIST .. ".*." .. CurrencyManager.CAMPAIGN_CURRENCY_LIST_NAME, "onUpdate", CurrencyManager.refreshCampaignCurrencies);
	DB.addHandler(CurrencyManager.CAMPAIGN_CURRENCY_LIST .. ".*." .. CurrencyManager.CAMPAIGN_CURRENCY_LIST_WEIGHT, "onUpdate", CurrencyManager.refreshCampaignCurrencies);
	DB.addHandler(CurrencyManager.CAMPAIGN_CURRENCY_LIST .. ".*." .. CurrencyManager.CAMPAIGN_CURRENCY_LIST_VALUE, "onUpdate", CurrencyManager.refreshCampaignCurrencies);
end

-- Rebuild the campaign currency dictionary for fast lookup
function refreshCampaignCurrencies()
	_tCampaignCurrencies = {};
	for _,vNode in ipairs(DB.getChildList(CurrencyManager.CAMPAIGN_CURRENCY_LIST)) do
		local sName = StringManager.trim(DB.getValue(vNode, CurrencyManager.CAMPAIGN_CURRENCY_LIST_NAME, ""));
		if (sName or "") ~= "" then
			local tCurrency = {};
			tCurrency.sName = sName;
			tCurrency.nWeight = DB.getValue(vNode, CurrencyManager.CAMPAIGN_CURRENCY_LIST_WEIGHT, 0);
			tCurrency.nValue = DB.getValue(vNode, CurrencyManager.CAMPAIGN_CURRENCY_LIST_VALUE, 0);
			table.insert(_tCampaignCurrencies, tCurrency);
		end
	end
	table.sort(_tCampaignCurrencies, CurrencyManager.sortCampaignCurrencies);
	_bCampaignCurrenciesInit = true;
	CurrencyManager.makeCallback();
end
function sortCampaignCurrencies(a,b)
	if a.nValue ~= b.nValue then
		return a.nValue > b.nValue; -- Descending
	end
	return a.sName < b.sName;
end
-- NOTE: FG windowlist.onSortCompare return values are reversed
--			compared to Lua table.sort return values
function sortCampaignCurrenciesUsingNames(s1, s2)
	local nValue1 = CurrencyManager.getCurrencyValue(s1);
	local nValue2 = CurrencyManager.getCurrencyValue(s2);
	if nValue1 ~= nValue2 then
		return nValue1 < nValue2;
	end
	return s1 > s2;
end

--
-- SETTINGS
--

local _sDefaultCurrency = "";
function setDefaultCurrency(s)
	_sDefaultCurrency = s or "";
end
function getDefaultCurrency()
	return _sDefaultCurrency;
end

-- DEPRECATED - LONG (2024-05-28)
function setCurrencyPaths(sRecordType, tPaths)
	ItemManager.setCurrencyPaths(sRecordType, tPaths);
end
function getCurrencyPaths(sRecordType)
	return ItemManager.getCurrencyPaths(sRecordType);
end
function setEncumbranceFields(sRecordType, tFields)
	ItemManager.setCurrencyEncumbranceFields(sRecordType, tPaths);
end
function getEncumbranceFields(sRecordType)
	return ItemManager.getCurrencyEncumbranceFields(sRecordType);
end

local _tCallbacks = {};
function registerCallback(fn)
	UtilityManager.registerCallback(_tCallbacks, fn);
end
function unregisterCallback(fn)
	UtilityManager.unregisterCallback(_tCallbacks, fn);
end
function makeCallback()
	UtilityManager.performAllCallbacks(_tCallbacks);
end

--
-- LOOKUP
--

function getCurrencyData()
	if not _bCampaignCurrenciesInit then
		CurrencyManager.refreshCampaignCurrencies();
	end
	return _tCampaignCurrencies;
end
function getCurrencies()
	local tSimple = {};
	for _,v in ipairs(CurrencyManager.getCurrencyData()) do
		table.insert(tSimple, v.sName);
	end
	return tSimple;
end

function getCurrencyRecord(s)
	local sLower = StringManager.trim(s):lower();
	for _,tCurrency in ipairs(CurrencyManager.getCurrencyData()) do
		if sLower == tCurrency.sName:lower() then
			return tCurrency;
		end
	end
	return nil;
end
function getCurrencyMatch(s)
	local tCurrency = CurrencyManager.getCurrencyRecord(s);
	if tCurrency then
		return tCurrency.sName;
	end
	return nil;
end
function getCurrencyWeight(s)
	local tCurrency = CurrencyManager.getCurrencyRecord(s);
	if tCurrency then
		return tCurrency.nWeight;
	end
	return 0;
end
function getCurrencyValue(s)
	local tCurrency = CurrencyManager.getCurrencyRecord(s);
	if tCurrency then
		return tCurrency.nValue;
	end
	return 0;
end

function populateCharCurrencies(nodeChar)
	for _,tCurrency in ipairs(CurrencyManager.getCurrencyData()) do
		CurrencyManager.addRecordCurrency(nodeChar, tCurrency.sName, 0);
	end
end
function addRecordCurrency(nodeRecord, sNewCurrency, nNewCurrency)
	local sRecordType = RecordDataManager.getRecordTypeFromRecordPath(DB.getPath(nodeRecord));
	if not ItemManager.doesRecordTypeHaveCurrency(sRecordType) then
		local sMessage = string.format("Currency support not registered for record type (%s) (%d %s)", DB.getValue(nodeActor, "name", ""), nNewCurrency, sNewCurrency);
		ChatManager.SystemMessage(sMessage);
		return
	end
	local tCurrencyPaths = ItemManager.getCurrencyPaths(sRecordType);
	local sCurrencyNameField = ItemManager.getCurrencyNameField(sRecordType);

	-- Check for existing coin match
	-- If no match to existing coins, then find first empty slot
	local nodeTarget = nil;
	local sNewCurrencyLower = sNewCurrency:lower();
	for _,sPath in ipairs(tCurrencyPaths) do
		for _,nodeCurrency in ipairs(DB.getChildList(nodeRecord, sPath)) do
			local sExistingCurrency = DB.getValue(nodeCurrency, sCurrencyNameField, ""); 
			if sNewCurrencyLower == sExistingCurrency:lower() then
				nodeTarget = nodeCurrency;
				break;
			end
		end
	end
	if not nodeTarget then
		nodeTarget = DB.createChild(DB.getPath(nodeRecord, tCurrencyPaths[1]));
	end

	-- If no target, then error report
	if not nodeTarget then
		local sMessage = string.format("Unable to create currency slot for record (%s) (%d %s)", DB.getValue(nodeRecord, "name", ""), nNewCurrency, sNewCurrency);
		ChatManager.SystemMessage(sMessage);
	end
	
	DB.setValue(nodeTarget, "amount", "number", DB.getValue(nodeTarget, "amount", 0) + nNewCurrency);
	DB.setValue(nodeTarget, sCurrencyNameField, "string", sNewCurrency);
end
-- DEPRECATED - LONG (2024-08-13)
function addActorCurrency(nodeActor, sNewCurrency, nNewCurrency)
	CurrencyManager.addRecordCurrency(nodeActor, sNewCurrency, nNewCurrency);
end
-- DEPRECATED - LONG (2024-05-28)
function addCharCurrency(nodeActor, sNewCurrency, nNewCurrency)
	CurrencyManager.addRecordCurrency(nodeActor, sNewCurrency, nNewCurrency);
end

function parseCurrencyString(s, bExistsOnly)
	local nCurrency = 0;
	local sCurrency = nil;

	-- Look for currency suffix (50gp), then currency prefix ($50)
	local sCurrencyAmount;
	sCurrencyAmount, sCurrency = s:match("^%s*([%d,]+)%s*([^%d]*)$");
	if not sCurrencyAmount then 
		sCurrency, sCurrencyAmount = s:match("^%s*([^%d]+)%s*([%d,]+)%s*$");
	end
	if sCurrencyAmount then
		sCurrency = StringManager.trim(sCurrency);
		if bExistsOnly and not CurrencyManager.getCurrencyMatch(sCurrency) then
			return 0, nil;
		end
		sCurrencyAmount = sCurrencyAmount:gsub(",", "");
		nCurrency = tonumber(sCurrencyAmount) or 0;
		if sCurrency == "" then
			sCurrency = CurrencyManager.getDefaultCurrency();
		end
	end

	return nCurrency, sCurrency;
end
