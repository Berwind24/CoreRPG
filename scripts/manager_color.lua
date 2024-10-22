-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

--
--	DEFAULTS AND VARIABLES
--

-- UI Sidebar colors
local DEFAULT_COLOR_SIDEBAR_CATEGORY_ICON = "A3A29D";
local DEFAULT_COLOR_SIDEBAR_CATEGORY_TEXT = "DEC790";
local DEFAULT_COLOR_SIDEBAR_RECORD_ICON = "DEC790";
local DEFAULT_COLOR_SIDEBAR_RECORD_TEXT = "FFFFFF";

-- UI General button colors
local DEFAULT_COLOR_BUTTON_CONTENT = "FFFFFF";
local DEFAULT_WINDOWMENU_ICON = "000000";

-- UI General usage colors
local DEFAULT_COLOR_FULL = "000000";
local DEFAULT_COLOR_THREE_QUARTER = "300000";
local DEFAULT_COLOR_HALF = "600000";
local DEFAULT_COLOR_QUARTER = "B00000";
local DEFAULT_COLOR_EMPTY = "C0C0C0";

local DEFAULT_COLOR_GRADIENT_TOP = { r = 0, g = 0, b = 0 };
local DEFAULT_COLOR_GRADIENT_MID = { r = 96, g = 0, b = 0 };
local DEFAULT_COLOR_GRADIENT_BOTTOM = { r = 255, g = 0, b = 0 };

-- UI Health specific colors
local DEFAULT_COLOR_HEALTH_UNWOUNDED = "008000";
local DEFAULT_COLOR_HEALTH_DYING_OR_DEAD = "404040";
local DEFAULT_COLOR_HEALTH_UNCONSCIOUS = "6C2DC7";

local DEFAULT_COLOR_HEALTH_SIMPLE_WOUNDED = "408000";
local DEFAULT_COLOR_HEALTH_SIMPLE_BLOODIED = "C11B17";

local DEFAULT_COLOR_HEALTH_LT_WOUNDS = "408000";
local DEFAULT_COLOR_HEALTH_MOD_WOUNDS = "AF7817";
local DEFAULT_COLOR_HEALTH_HVY_WOUNDS = "E56717";
local DEFAULT_COLOR_HEALTH_CRIT_WOUNDS = "C11B17";

local DEFAULT_COLOR_HEALTH_SHIELD = "0000AA";

local DEFAULT_COLOR_HEALTH_GRADIENT_TOP = { r = 0, g = 128, b = 0 };
local DEFAULT_COLOR_HEALTH_GRADIENT_MID = { r = 210, g = 112, b = 23 };
local DEFAULT_COLOR_HEALTH_GRADIENT_BOTTOM = { r = 192, g = 0, b = 0 };

-- Token Faction specific colors
local DEFAULT_COLOR_TOKEN_FACTION_FRIEND = "00FF00";
local DEFAULT_COLOR_TOKEN_FACTION_NEUTRAL = "FFFF00";
local DEFAULT_COLOR_TOKEN_FACTION_FOE = "FF0000";

-- Token Health specific colors
local DEFAULT_COLOR_TOKEN_HEALTH_UNWOUNDED = "00C000";
local DEFAULT_COLOR_TOKEN_HEALTH_DYING_OR_DEAD = "C0C0C0";
local DEFAULT_COLOR_TOKEN_HEALTH_UNCONSCIOUS = "8C3BFF";

local DEFAULT_COLOR_TOKEN_HEALTH_SIMPLE_WOUNDED = "80C000";
local DEFAULT_COLOR_TOKEN_HEALTH_SIMPLE_BLOODIED = "FF0000";

local DEFAULT_COLOR_TOKEN_HEALTH_LT_WOUNDS = "80C000";
local DEFAULT_COLOR_TOKEN_HEALTH_MOD_WOUNDS = "FFC000";
local DEFAULT_COLOR_TOKEN_HEALTH_HVY_WOUNDS = "FF6000";
local DEFAULT_COLOR_TOKEN_HEALTH_CRIT_WOUNDS = "FF0000";

local DEFAULT_COLOR_TOKEN_HEALTH_SHIELD = "0000AA";

local DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_TOP = { r = 0, g = 192, b = 0 };
local DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_MID = { r = 255, g = 192, b = 0 };
local DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM = { r = 255, g = 0, b = 0 };

local _tLegacyMap = {
	["COLOR_FULL"] = "usage_full",
	["COLOR_THREE_QUARTER"] = "usage_3quarter",
	["COLOR_HALF"] = "usage_half",
	["COLOR_QUARTER"] = "usage_1quarter",
	["COLOR_EMPTY"] = "usage_empty",
	["COLOR_GRADIENT_TOP"] = "usage_gradient_top",
	["COLOR_GRADIENT_MID"] = "usage_gradient_mid",
	["COLOR_GRADIENT_BOTTOM"] = "usage_gradient_bottom",
	["COLOR_HEALTH_UNWOUNDED"] = "health_unwounded",
	["COLOR_HEALTH_DYING_OR_DEAD"] = "health_dyingordead",
	["COLOR_HEALTH_UNCONSCIOUS"] = "health_unconscious",
	["COLOR_HEALTH_SIMPLE_WOUNDED"] = "health_simple_wounded",
	["COLOR_HEALTH_SIMPLE_BLOODIED"] = "health_simple_bloodied",
	["COLOR_HEALTH_LT_WOUNDS"] = "health_wounds_light",
	["COLOR_HEALTH_MOD_WOUNDS"] = "health_wounds_moderate",
	["COLOR_HEALTH_HVY_WOUNDS"] = "health_wounds_heavy",
	["COLOR_HEALTH_CRIT_WOUNDS"] = "health_wounds_critical",
	["COLOR_HEALTH_GRADIENT_TOP"] = "health_gradient_top",
	["COLOR_HEALTH_GRADIENT_MID"] = "health_gradient_mid",
	["COLOR_HEALTH_GRADIENT_BOTTOM"] = "health_gradient_bottom",
	["COLOR_TOKEN_FACTION_FRIEND"] = "faction_friend",
	["COLOR_TOKEN_FACTION_NEUTRAL"] = "faction_neutral",
	["COLOR_TOKEN_FACTION_FOE"] = "faction_foe",
	["COLOR_TOKEN_HEALTH_UNWOUNDED"] = "token_health_unwounded",
	["COLOR_TOKEN_HEALTH_DYING_OR_DEAD"] = "token_health_dyingordead",
	["COLOR_TOKEN_HEALTH_UNCONSCIOUS"] = "token_health_unconscious",
	["COLOR_TOKEN_HEALTH_SIMPLE_WOUNDED"] = "token_health_simple_wounded",
	["COLOR_TOKEN_HEALTH_SIMPLE_BLOODIED"] = "token_health_simple_bloodied",
	["COLOR_TOKEN_HEALTH_LT_WOUNDS"] = "token_health_wounds_light",
	["COLOR_TOKEN_HEALTH_MOD_WOUNDS"] = "token_health_wounds_moderate",
	["COLOR_TOKEN_HEALTH_HVY_WOUNDS"] = "token_health_wounds_heavy",
	["COLOR_TOKEN_HEALTH_CRIT_WOUNDS"] = "token_health_wounds_critical",
	["COLOR_TOKEN_HEALTH_GRADIENT_TOP"] = "token_health_gradient_top",
	["COLOR_TOKEN_HEALTH_GRADIENT_MID"] = "token_health_gradient_mid",
	["COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM"] = "token_health_gradient_bottom",
};
function onTabletopInit()
	for k,sKey in pairs(_tLegacyMap) do
		if ColorManager[k] then
			ColorManager.setUIColor(sKey, ColorManager[k]);
		end
		ColorManager[k] = ColorManager.getUIColor(sKey);
	end
end

--
--	SET/GET FUNCTIONS
--

local _tUIColors = {
	["button_icon"] = DEFAULT_COLOR_BUTTON_CONTENT,
	["button_text"] = DEFAULT_COLOR_BUTTON_CONTENT,
	["sidebar_category_icon"] = DEFAULT_COLOR_SIDEBAR_CATEGORY_ICON,
	["sidebar_category_text"] = DEFAULT_COLOR_SIDEBAR_CATEGORY_TEXT,
	["sidebar_record_icon"] = DEFAULT_COLOR_SIDEBAR_RECORD_ICON,
	["sidebar_record_text"] = DEFAULT_COLOR_SIDEBAR_RECORD_TEXT,
	["windowmenu_icon"] = DEFAULT_WINDOWMENU_ICON,

	["usage_full"] = DEFAULT_COLOR_FULL,
	["usage_3quarter"] = DEFAULT_COLOR_THREE_QUARTER,
	["usage_half"] = DEFAULT_COLOR_HALF,
	["usage_1quarter"] = DEFAULT_COLOR_QUARTER,
	["usage_empty"] = DEFAULT_COLOR_EMPTY,
	["usage_gradient_top"] = DEFAULT_COLOR_GRADIENT_TOP,
	["usage_gradient_mid"] = DEFAULT_COLOR_GRADIENT_MID,
	["usage_gradient_bottom"] = DEFAULT_COLOR_GRADIENT_BOTTOM,

	["health_unwounded"] = DEFAULT_COLOR_HEALTH_UNWOUNDED,
	["health_dyingordead"] = DEFAULT_COLOR_HEALTH_DYING_OR_DEAD,
	["health_unconscious"] = DEFAULT_COLOR_HEALTH_UNCONSCIOUS,
	["health_simple_wounded"] = DEFAULT_COLOR_HEALTH_SIMPLE_WOUNDED,
	["health_simple_bloodied"] = DEFAULT_COLOR_HEALTH_SIMPLE_BLOODIED,
	["health_wounds_light"] = DEFAULT_COLOR_HEALTH_LT_WOUNDS,
	["health_wounds_moderate"] = DEFAULT_COLOR_HEALTH_MOD_WOUNDS,
	["health_wounds_heavy"] = DEFAULT_COLOR_HEALTH_HVY_WOUNDS,
	["health_wounds_critical"] = DEFAULT_COLOR_HEALTH_CRIT_WOUNDS,
	["health_gradient_top"] = DEFAULT_COLOR_HEALTH_GRADIENT_TOP,
	["health_gradient_mid"] = DEFAULT_COLOR_HEALTH_GRADIENT_MID,
	["health_gradient_bottom"] = DEFAULT_COLOR_HEALTH_GRADIENT_BOTTOM,
	["health_shield"] = DEFAULT_COLOR_HEALTH_SHIELD,

	["faction_friend"] = DEFAULT_COLOR_TOKEN_FACTION_FRIEND,
	["faction_neutral"] = DEFAULT_COLOR_TOKEN_FACTION_NEUTRAL,
	["faction_foe"] = DEFAULT_COLOR_TOKEN_FACTION_FOE,

	["token_health_unwounded"] = DEFAULT_COLOR_TOKEN_HEALTH_UNWOUNDED,
	["token_health_dyingordead"] = DEFAULT_COLOR_TOKEN_HEALTH_DYING_OR_DEAD,
	["token_health_unconscious"] = DEFAULT_COLOR_TOKEN_HEALTH_UNCONSCIOUS,
	["token_health_simple_wounded"] = DEFAULT_COLOR_TOKEN_HEALTH_SIMPLE_WOUNDED,
	["token_health_simple_bloodied"] = DEFAULT_COLOR_TOKEN_HEALTH_SIMPLE_BLOODIED,
	["token_health_wounds_light"] = DEFAULT_COLOR_TOKEN_HEALTH_LT_WOUNDS,
	["token_health_wounds_moderate"] = DEFAULT_COLOR_TOKEN_HEALTH_MOD_WOUNDS,
	["token_health_wounds_heavy"] = DEFAULT_COLOR_TOKEN_HEALTH_HVY_WOUNDS,
	["token_health_wounds_critical"] = DEFAULT_COLOR_TOKEN_HEALTH_CRIT_WOUNDS,
	["token_health_gradient_top"] = DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_TOP,
	["token_health_gradient_mid"] = DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_MID,
	["token_health_gradient_bottom"] = DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM,
	["token_health_shield"] = DEFAULT_COLOR_TOKEN_HEALTH_SHIELD,
};
function getUIColor(sKey)
	return _tUIColors[sKey or ""];
end
function setUIColor(sKey, v)
	_tUIColors[sKey or ""] = v;
end

function setStandardDarkUIHealthColors()
	ColorManager.setUIColor("health_unwounded", "3BDD91");
	ColorManager.setUIColor("health_dyingordead", "D9534F");
	ColorManager.setUIColor("health_unconscious", "FF9C45");
	ColorManager.setUIColor("health_simple_wounded", "3BDD91");
	ColorManager.setUIColor("health_simple_bloodied", "D9534F");
	ColorManager.setUIColor("health_wounds_light", "3BDD91");
	ColorManager.setUIColor("health_wounds_moderate", "FFDA45");
	ColorManager.setUIColor("health_wounds_heavy", "FF9C45");
	ColorManager.setUIColor("health_wounds_critical", "D9534F");
	ColorManager.setUIColor("health_wounds_moderate", "FFDA45");
	ColorManager.setUIColor("health_wounds_heavy", "FF9C45");
	ColorManager.setUIColor("health_wounds_critical", "D9534F");
	ColorManager.setUIColor("health_shield", "5B95FF");

	-- TODO - Fix dark mode health gradient colors
	ColorManager.setUIColor("health_gradient_top", { r = 0, g = 128, b = 0 });
	ColorManager.setUIColor("health_gradient_mid", { r = 210, g = 112, b = 23 });
	ColorManager.setUIColor("health_gradient_bottom", { r = 192, g = 0, b = 0 });

	-- TODO - Fix dark mode usage and usage gradient colors
	ColorManager.setUIColor("usage_full", "000000");
	ColorManager.setUIColor("usage_3quarter", "300000");
	ColorManager.setUIColor("usage_half", "600000");
	ColorManager.setUIColor("usage_1quarter", "B00000");
	ColorManager.setUIColor("usage_empty", "C0C0C0");

	ColorManager.setUIColor("usage_gradient_top", { r = 0, g = 0, b = 0 });
	ColorManager.setUIColor("usage_gradient_mid", { r = 96, g = 0, b = 0 });
	ColorManager.setUIColor("usage_gradient_bottom", { r = 255, g = 0, b = 0 });
end

--
--	RESET FUNCTIONS
--

function resetUIColors()
	ColorManager.resetUISidebarColors();
	ColorManager.resetUIWindowMenuColors();
	ColorManager.resetUIGeneralButtonColors();
	ColorManager.resetUIGeneralBarColors();
	ColorManager.resetUIHealthColors();
end
function resetUISidebarColors()
	ColorManager.setSidebarCategoryIconColor(DEFAULT_COLOR_SIDEBAR_CATEGORY_ICON);
	ColorManager.setSidebarCategoryTextColor(DEFAULT_COLOR_SIDEBAR_CATEGORY_TEXT);
	ColorManager.setSidebarRecordIconColor(DEFAULT_COLOR_SIDEBAR_RECORD_ICON);
	ColorManager.setSidebarRecordTextColor(DEFAULT_COLOR_SIDEBAR_RECORD_TEXT);
end
function resetUIWindowMenuColors()
	ColorManager.setWindowMenuIconColor(DEFAULT_WINDOWMENU_ICON);
end
function resetUIGeneralButtonColors()
	ColorManager.setButtonIconColor(DEFAULT_COLOR_BUTTON_CONTENT);
	ColorManager.setButtonTextColor(DEFAULT_COLOR_BUTTON_CONTENT);
end
function resetUIGeneralBarColors()
	ColorManager.setUIColor("usage_full", DEFAULT_COLOR_FULL);
	ColorManager.setUIColor("usage_3quarter", DEFAULT_COLOR_THREE_QUARTER);
	ColorManager.setUIColor("usage_half", DEFAULT_COLOR_HALF);
	ColorManager.setUIColor("usage_1quarter", DEFAULT_COLOR_QUARTER);
	ColorManager.setUIColor("usage_empty", DEFAULT_COLOR_EMPTY);

	ColorManager.setUIColor("usage_gradient_top", DEFAULT_COLOR_GRADIENT_TOP);
	ColorManager.setUIColor("usage_gradient_mid", DEFAULT_COLOR_GRADIENT_MID);
	ColorManager.setUIColor("usage_gradient_bottom", DEFAULT_COLOR_GRADIENT_BOTTOM);
end
function resetUIHealthColors()
	ColorManager.setUIColor("health_unwounded", DEFAULT_COLOR_HEALTH_UNWOUNDED);
	ColorManager.setUIColor("health_dyingordead", DEFAULT_COLOR_HEALTH_DYING_OR_DEAD);
	ColorManager.setUIColor("health_unconscious", DEFAULT_COLOR_HEALTH_UNCONSCIOUS);
	ColorManager.setUIColor("health_simple_wounded", DEFAULT_COLOR_HEALTH_SIMPLE_WOUNDED);
	ColorManager.setUIColor("health_simple_bloodied", DEFAULT_COLOR_HEALTH_SIMPLE_BLOODIED);
	ColorManager.setUIColor("health_wounds_light", DEFAULT_COLOR_HEALTH_LT_WOUNDS);
	ColorManager.setUIColor("health_wounds_moderate", DEFAULT_COLOR_HEALTH_MOD_WOUNDS);
	ColorManager.setUIColor("health_wounds_heavy", DEFAULT_COLOR_HEALTH_HVY_WOUNDS);
	ColorManager.setUIColor("health_wounds_critical", DEFAULT_COLOR_HEALTH_CRIT_WOUNDS);

	ColorManager.setUIColor("health_gradient_top", DEFAULT_COLOR_HEALTH_GRADIENT_TOP);
	ColorManager.setUIColor("health_gradient_mid", DEFAULT_COLOR_HEALTH_GRADIENT_MID);
	ColorManager.setUIColor("health_gradient_bottom", DEFAULT_COLOR_HEALTH_GRADIENT_BOTTOM);

	ColorManager.setUIColor("health_shield", DEFAULT_COLOR_HEALTH_SHIELD);
end

function resetTokenColors()
	ColorManager.resetTokenFactionColors();
	ColorManager.resetTokenHealthColors();
end
function resetTokenFactionColors()
	ColorManager.setUIColor("faction_friend", DEFAULT_COLOR_TOKEN_FACTION_FRIEND);
	ColorManager.setUIColor("faction_neutral", DEFAULT_COLOR_TOKEN_FACTION_NEUTRAL);
	ColorManager.setUIColor("faction_foe", DEFAULT_COLOR_TOKEN_FACTION_FOE);
end
function resetTokenHealthColors()
	ColorManager.setUIColor("token_health_unwounded", DEFAULT_COLOR_TOKEN_HEALTH_UNWOUNDED);
	ColorManager.setUIColor("token_health_dyingordead", DEFAULT_COLOR_TOKEN_HEALTH_DYING_OR_DEAD);
	ColorManager.setUIColor("token_health_unconscious", DEFAULT_COLOR_TOKEN_HEALTH_UNCONSCIOUS);
	ColorManager.setUIColor("token_health_simple_wounded", DEFAULT_COLOR_TOKEN_HEALTH_SIMPLE_WOUNDED);
	ColorManager.setUIColor("token_health_simple_bloodied", DEFAULT_COLOR_TOKEN_HEALTH_SIMPLE_BLOODIED);
	ColorManager.setUIColor("token_health_wounds_light", DEFAULT_COLOR_TOKEN_HEALTH_LT_WOUNDS);
	ColorManager.setUIColor("token_health_wounds_moderate", DEFAULT_COLOR_TOKEN_HEALTH_MOD_WOUNDS);
	ColorManager.setUIColor("token_health_wounds_heavy", DEFAULT_COLOR_TOKEN_HEALTH_HVY_WOUNDS);
	ColorManager.setUIColor("token_health_wounds_critical", DEFAULT_COLOR_TOKEN_HEALTH_CRIT_WOUNDS);

	ColorManager.setUIColor("token_health_gradient_top", DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_TOP);
	ColorManager.setUIColor("token_health_gradient_mid", DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_MID);
	ColorManager.setUIColor("token_health_gradient_bottom", DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM);
end

--
--	SIDEBAR COLOR ACCESS FUNCTIONS
--

function getSidebarCategoryIconColor()
	return ColorManager.getUIColor("sidebar_category_icon");
end
function getSidebarCategoryTextColor()
	return ColorManager.getUIColor("sidebar_category_text");
end
function getSidebarRecordIconColor()
	return ColorManager.getUIColor("sidebar_record_icon");
end
function getSidebarRecordTextColor()
	return ColorManager.getUIColor("sidebar_record_text");
end
function setSidebarCategoryIconColor(s)
	ColorManager.setUIColor("sidebar_category_icon", s);
end
function setSidebarCategoryTextColor(s)
	ColorManager.setUIColor("sidebar_category_text", s);
end
function setSidebarRecordIconColor(s)
	ColorManager.setUIColor("sidebar_record_icon", s);
end
function setSidebarRecordTextColor(s)
	ColorManager.setUIColor("sidebar_record_text", s);
end

--
--	HEALTH/TOKEN/USAGE COLOR ACCESS FUNCTIONS
--

function getUsageColor(nPercentUsed, bBar)
	local sColor;
	if not bBar or OptionsManager.isOption("BARC", "tiered") then
		sColor = ColorManager.getTieredUsageColor(nPercentUsed);
	else
		sColor = ColorManager.getGradientUsageColor(nPercentUsed);
	end
	return sColor;
end
function getTieredUsageColor(nPercentUsed)
	local sColor;
	if nPercentUsed <= 0 then
		sColor = ColorManager.getUIColor("usage_full");
	elseif nPercentUsed <= .25 then
		sColor = ColorManager.getUIColor("usage_3quarter");
	elseif nPercentUsed <= .5 then
		sColor = ColorManager.getUIColor("usage_half");
	elseif nPercentUsed <= .75 then
		sColor = ColorManager.getUIColor("usage_1quarter");
	else
		sColor = ColorManager.getUIColor("usage_empty");
	end
	return sColor;
end
function getGradientUsageColor(nPercentUsed)
	local sColor;
	if nPercentUsed >= 1 then
		sColor = ColorManager.getUIColor("usage_empty");
	elseif nPercentUsed <= 0 then
		sColor = ColorManager.getUIColor("usage_full");
	else
		local nBarR, nBarG, nBarB;
		if nPercentUsed >= 0.5 then
			local tBottom = ColorManager.getUIColor("usage_gradient_bottom");
			local tMid = ColorManager.getUIColor("usage_gradient_mid");
			local nPercentGrade = (nPercentUsed - 0.5) * 2;
			nBarR = math.floor((tBottom.r * nPercentGrade) + (tMid.r * (1.0 - nPercentGrade)) + 0.5);
			nBarG = math.floor((tBottom.g * nPercentGrade) + (tMid.g * (1.0 - nPercentGrade)) + 0.5);
			nBarB = math.floor((tBottom.b * nPercentGrade) + (tMid.b * (1.0 - nPercentGrade)) + 0.5);
		else
			local tTop = ColorManager.getUIColor("usage_gradient_top");
			local tMid = ColorManager.getUIColor("usage_gradient_mid");
			local nPercentGrade = nPercentUsed * 2;
			nBarR = math.floor((tMid.r * nPercentGrade) + (tTop.r * (1.0 - nPercentGrade)) + 0.5);
			nBarG = math.floor((tMid.g * nPercentGrade) + (tTop.g * (1.0 - nPercentGrade)) + 0.5);
			nBarB = math.floor((tMid.b * nPercentGrade) + (tTop.b * (1.0 - nPercentGrade)) + 0.5);
		end
		sColor = string.format("%02X%02X%02X", nBarR, nBarG, nBarB);
	end
	return sColor;
end

function getHealthColor(nPercentWounded, bBar)
	local sColor;
	if not bBar or OptionsManager.isOption("BARC", "tiered") then
		sColor = ColorManager.getTieredHealthColor(nPercentWounded);
	else
		sColor = ColorManager.getGradientHealthColor(nPercentWounded);
	end
	return sColor;
end
function getTieredHealthColor(nPercentWounded)
	local sColor;
	if nPercentWounded >= 1 then
		sColor = ColorManager.getUIColor("health_dyingordead");
	elseif nPercentWounded <= 0 then
		sColor = ColorManager.getUIColor("health_unwounded");
	elseif OptionsManager.isOption("WNDC", "detailed") then
		if nPercentWounded >= 0.75 then
			sColor = ColorManager.getUIColor("health_wounds_critical");
		elseif nPercentWounded >= 0.5 then
			sColor = ColorManager.getUIColor("health_wounds_heavy");
		elseif nPercentWounded >= 0.25 then
			sColor = ColorManager.getUIColor("health_wounds_moderate");
		else
			sColor = ColorManager.getUIColor("health_wounds_light");
		end
	else
		if nPercentWounded >= 0.5 then
			sColor = ColorManager.getUIColor("health_simple_bloodied");
		else
			sColor = ColorManager.getUIColor("health_simple_wounded");
		end
	end
	return sColor;
end
function getGradientHealthColor(nPercentWounded)
	local sColor;
	if nPercentWounded >= 1 then
		sColor = ColorManager.getUIColor("health_dyingordead");
	elseif nPercentWounded <= 0 then
		sColor = ColorManager.getUIColor("health_unwounded");
	else
		local nBarR, nBarG, nBarB;
		if nPercentWounded >= 0.5 then
			local tBottom = ColorManager.getUIColor("health_gradient_bottom");
			local tMid = ColorManager.getUIColor("health_gradient_mid");
			local nPercentGrade = (nPercentWounded - 0.5) * 2;
			nBarR = math.floor((tBottom.r * nPercentGrade) + (tMid.r * (1.0 - nPercentGrade)) + 0.5);
			nBarG = math.floor((tBottom.g * nPercentGrade) + (tMid.g * (1.0 - nPercentGrade)) + 0.5);
			nBarB = math.floor((tBottom.b * nPercentGrade) + (tMid.b * (1.0 - nPercentGrade)) + 0.5);
		else
			local tTop = ColorManager.getUIColor("health_gradient_top");
			local tMid = ColorManager.getUIColor("health_gradient_mid");
			local nPercentGrade = nPercentWounded * 2;
			nBarR = math.floor((tMid.r * nPercentGrade) + (tTop.r * (1.0 - nPercentGrade)) + 0.5);
			nBarG = math.floor((tMid.g * nPercentGrade) + (tTop.g * (1.0 - nPercentGrade)) + 0.5);
			nBarB = math.floor((tMid.b * nPercentGrade) + (tTop.b * (1.0 - nPercentGrade)) + 0.5);
		end
		sColor = string.format("%02X%02X%02X", nBarR, nBarG, nBarB);
	end
	return sColor;
end

function getTokenHealthColor(nPercentWounded, bBar)
	local sColor;
	if not bBar or OptionsManager.isOption("BARC", "tiered") then
		sColor = ColorManager.getTieredTokenHealthColor(nPercentWounded);
	else
		sColor = ColorManager.getGradientTokenHealthColor(nPercentWounded);
	end
	return sColor;
end
function getTieredTokenHealthColor(nPercentWounded)
	local sColor;
	if nPercentWounded >= 1 then
		sColor = ColorManager.getUIColor("token_health_dyingordead");
	elseif nPercentWounded <= 0 then
		sColor = ColorManager.getUIColor("token_health_unwounded");
	elseif OptionsManager.isOption("WNDC", "detailed") then
		if nPercentWounded >= 0.75 then
			sColor = ColorManager.getUIColor("token_health_wounds_critical");
		elseif nPercentWounded >= 0.5 then
			sColor = ColorManager.getUIColor("token_health_wounds_heavy");
		elseif nPercentWounded >= 0.25 then
			sColor = ColorManager.getUIColor("token_health_wounds_moderate");
		else
			sColor = ColorManager.getUIColor("token_health_wounds_light");
		end
	else
		if nPercentWounded >= 0.5 then
			sColor = ColorManager.getUIColor("token_health_simple_bloodied");
		else
			sColor = ColorManager.getUIColor("token_health_simple_wounded");
		end
	end
	return sColor;
end
function getGradientTokenHealthColor(nPercentWounded)
	local sColor;
	if nPercentWounded >= 1 then
		sColor = ColorManager.getUIColor("token_health_dyingordead");
	elseif nPercentWounded <= 0 then
		sColor = ColorManager.getUIColor("token_health_unwounded");
	else
		local nBarR, nBarG, nBarB;
		if nPercentWounded >= 0.5 then
			local tBottom = ColorManager.getUIColor("token_health_gradient_bottom");
			local tMid = ColorManager.getUIColor("token_health_gradient_mid");
			local nPercentGrade = (nPercentWounded - 0.5) * 2;
			nBarR = math.floor((tBottom.r * nPercentGrade) + (tMid.r * (1.0 - nPercentGrade)) + 0.5);
			nBarG = math.floor((tBottom.g * nPercentGrade) + (tMid.g * (1.0 - nPercentGrade)) + 0.5);
			nBarB = math.floor((tBottom.b * nPercentGrade) + (tMid.b * (1.0 - nPercentGrade)) + 0.5);
		else
			local tTop = ColorManager.getUIColor("token_health_gradient_top");
			local tMid = ColorManager.getUIColor("token_health_gradient_mid");
			local nPercentGrade = nPercentWounded * 2;
			nBarR = math.floor((tMid.r * nPercentGrade) + (tTop.r * (1.0 - nPercentGrade)) + 0.5);
			nBarG = math.floor((tMid.g * nPercentGrade) + (tTop.g * (1.0 - nPercentGrade)) + 0.5);
			nBarB = math.floor((tMid.b * nPercentGrade) + (tTop.b * (1.0 - nPercentGrade)) + 0.5);
		end
		sColor = string.format("%02X%02X%02X", nBarR, nBarG, nBarB);
	end
	return sColor;
end

--
--	OTHER UI COLORS
--

function setButtonContentColor(s)
	ColorManager.setButtonIconColor(s);
	ColorManager.setButtonTextColor(s);
end

function setButtonIconColor(s)
	ColorManager.setUIColor("button_icon", s);
end
function getButtonIconColor()
	return ColorManager.getUIColor("button_icon");
end
function setButtonTextColor(s)
	ColorManager.setUIColor("button_text", s);
end
function getButtonTextColor()
	return ColorManager.getUIColor("button_text");
end

function setWindowMenuIconColor(s)
	ColorManager.setUIColor("windowmenu_icon", s);
end
function getWindowMenuIconColor()
	return ColorManager.getUIColor("windowmenu_icon");
end
