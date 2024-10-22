-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

DEFAULT_DICESKIN_GROUP = "DEFAULT";

WIDGET_PADDING = 2;
WIDGET_SIZE = 16;
WIDGET_HALF_SIZE = 10;

CONTROL_WIDGET_PADDING = 2;
CONTROL_WIDGET_SIZE = 10;
CONTROL_WIDGET_HALF_SIZE = 5;

local _tDiceSkinGroups = {
	"DEFAULT",
	"SWKELEMENTALBASICSDICE",
	"SWKMETALDICE",
	"SWKAURADICE",
	"SWKMAGICALDICE",
	"SWKRINGOFELEMENTSDICE",
	"SWKMAGICALTRAILDICE",
	"SWKFORCEFIELDDICE",
	"SWKWIZARDWROUGHTDICE",
	"SWKARTIFICERDICE",
	"SWKANNULUSOFFOCUSDICE",
	"SWKANNULUSOFFOCUSDICEFX",
	"SWKKNOTSOFFATEDICE",
	"SWKKNOTSOFFATEDICEFX",
	"SWKBLOODDICE",
	"SWKSTARSANDCLOVERS",
	"SWKHEARTSANDSKULLS",
	"SWKMONSTERSDICE1",
	"SWKDRAGONSDICE1",
};

local _tDiceSkinGroupStoreID = {
	["SWKMETALDICE"] = "SWKMETALDICE",
	["SWKAURADICE"] = "SWKAURADICE",
	["SWKMAGICALDICE"] = "SWKMAGICALDICE",
	["SWKRINGOFELEMENTSDICE"] = "SWKRINGOFELEMENTSDICE",
	["SWKMAGICALTRAILDICE"] = "SWKMAGICALTRAILDICE",
	["SWKFORCEFIELDDICE"] = "SWKFORCEFIELDDICE",
	["SWKWIZARDWROUGHTDICE"] = "SWKWIZARDWROUGHTDICE",
	["SWKARTIFICERDICE"] = "SWKARTIFICERDICE",
	["SWKANNULUSOFFOCUSDICE"] = "SWKANNULUSOFFOCUSDICE",
	["SWKANNULUSOFFOCUSDICEFX"] = "SWKANNULUSOFFOCUSDICE",
	["SWKKNOTSOFFATEDICE"] = "SWKKNOTSOFFATEDICE",
	["SWKKNOTSOFFATEDICEFX"] = "SWKKNOTSOFFATEDICE",
	["SWKBLOODDICE"] = "SWKBLOODDICE",
	["SWKSTARSANDCLOVERS"] = "SWKSTARSANDCLOVERS",
	["SWKHEARTSANDSKULLS"] = "SWKHEARTSANDSKULLS",
	["SWKMONSTERSDICE1"] = "SWKMONSTERSDICE1",
	["SWKDRAGONSDICE1"] = "SWKDRAGONSDICE1",
};

local _tDiceSkinToGroupMap = {
	[0] = "DEFAULT",
	[2] = "SWKMETALDICE", [3] = "SWKMETALDICE", [4] = "SWKMETALDICE", [5] = "SWKMETALDICE",
	[6] = "SWKMETALDICE", [7] = "SWKMETALDICE", [8] = "SWKMETALDICE", [9] = "SWKMETALDICE", 
	[10] = "SWKAURADICE", [11] = "SWKAURADICE", [12] = "SWKAURADICE", [13] = "SWKAURADICE", [14] = "SWKAURADICE", 
	[15] = "SWKAURADICE", [16] = "SWKAURADICE", [17] = "SWKAURADICE", [18] = "SWKAURADICE", [19] = "SWKAURADICE", 
	[20] = "SWKAURADICE", [21] = "SWKAURADICE", [22] = "SWKAURADICE", [23] = "SWKAURADICE", [24] = "SWKAURADICE", 
	[25] = "SWKAURADICE", [26] = "SWKAURADICE", [27] = "SWKAURADICE", [28] = "SWKAURADICE", [29] = "SWKAURADICE", 
	[30] = "SWKMAGICALDICE", [31] = "SWKMAGICALDICE", [32] = "SWKMAGICALDICE", [33] = "SWKMAGICALDICE", [34] = "SWKMAGICALDICE", 
	[35] = "SWKMAGICALDICE", [36] = "SWKMAGICALDICE", [37] = "SWKMAGICALDICE", [38] = "SWKMAGICALDICE", [39] = "SWKMAGICALDICE", 
	[40] = "SWKRINGOFELEMENTSDICE", [41] = "SWKRINGOFELEMENTSDICE", [42] = "SWKRINGOFELEMENTSDICE", [43] = "SWKRINGOFELEMENTSDICE", [44] = "SWKRINGOFELEMENTSDICE", 
	[45] = "SWKRINGOFELEMENTSDICE", [46] = "SWKRINGOFELEMENTSDICE", [47] = "SWKRINGOFELEMENTSDICE", [48] = "SWKRINGOFELEMENTSDICE", [49] = "SWKRINGOFELEMENTSDICE", 
	[50] = "SWKRINGOFELEMENTSDICE", [51] = "SWKRINGOFELEMENTSDICE", [52] = "SWKRINGOFELEMENTSDICE", [53] = "SWKRINGOFELEMENTSDICE", [54] = "SWKRINGOFELEMENTSDICE", 
	[55] = "SWKRINGOFELEMENTSDICE", [56] = "SWKRINGOFELEMENTSDICE", [57] = "SWKRINGOFELEMENTSDICE", [58] = "SWKRINGOFELEMENTSDICE", [59] = "SWKRINGOFELEMENTSDICE", 
	[60] = "SWKMAGICALTRAILDICE", [61] = "SWKMAGICALTRAILDICE", [62] = "SWKMAGICALTRAILDICE", [63] = "SWKMAGICALTRAILDICE", [64] = "SWKMAGICALTRAILDICE", 
	[65] = "SWKMAGICALTRAILDICE", [66] = "SWKMAGICALTRAILDICE", [67] = "SWKMAGICALTRAILDICE", [68] = "SWKMAGICALTRAILDICE", [69] = "SWKMAGICALTRAILDICE", 
	[70] = "SWKMAGICALTRAILDICE", [71] = "SWKMAGICALTRAILDICE", [72] = "SWKMAGICALTRAILDICE", [73] = "SWKMAGICALTRAILDICE", [74] = "SWKMAGICALTRAILDICE", 
	[75] = "SWKMAGICALTRAILDICE", [76] = "SWKMAGICALTRAILDICE", [77] = "SWKMAGICALTRAILDICE", [78] = "SWKMAGICALTRAILDICE", [79] = "SWKMAGICALTRAILDICE", 
	[80] = "SWKFORCEFIELDDICE", [81] = "SWKFORCEFIELDDICE", [82] = "SWKFORCEFIELDDICE", [83] = "SWKFORCEFIELDDICE", [84] = "SWKFORCEFIELDDICE", 
	[85] = "SWKFORCEFIELDDICE", [86] = "SWKFORCEFIELDDICE", [87] = "SWKFORCEFIELDDICE", [88] = "SWKFORCEFIELDDICE", [89] = "SWKFORCEFIELDDICE", 
	[90] = "DEFAULT", [91] = "SWKFORCEFIELDDICE", [92] = "SWKMETALDICE", [93] = "SWKMETALDICE",
	[94] = "SWKELEMENTALBASICSDICE", [95] = "SWKELEMENTALBASICSDICE", [96] = "SWKELEMENTALBASICSDICE", [97] = "SWKELEMENTALBASICSDICE", [98] = "SWKELEMENTALBASICSDICE", 
	[99] = "SWKELEMENTALBASICSDICE", [100] = "SWKELEMENTALBASICSDICE", [101] = "SWKELEMENTALBASICSDICE", [102] = "SWKELEMENTALBASICSDICE", [103] = "SWKELEMENTALBASICSDICE", 
	[106] = "SWKELEMENTALBASICSDICE", [107] = "SWKELEMENTALBASICSDICE", [108] = "SWKELEMENTALBASICSDICE", [109] = "SWKELEMENTALBASICSDICE", 
	[110] = "SWKWIZARDWROUGHTDICE", [111] = "SWKWIZARDWROUGHTDICE", [112] = "SWKWIZARDWROUGHTDICE", [113] = "SWKWIZARDWROUGHTDICE", [114] = "SWKWIZARDWROUGHTDICE", 
	[115] = "SWKWIZARDWROUGHTDICE", [116] = "SWKWIZARDWROUGHTDICE", [117] = "SWKWIZARDWROUGHTDICE", [118] = "SWKWIZARDWROUGHTDICE", [119] = "SWKWIZARDWROUGHTDICE", 
	[120] = "SWKWIZARDWROUGHTDICE", [121] = "SWKWIZARDWROUGHTDICE", [122] = "SWKWIZARDWROUGHTDICE", [123] = "SWKWIZARDWROUGHTDICE", [124] = "SWKWIZARDWROUGHTDICE", 
	[125] = "SWKWIZARDWROUGHTDICE", 
	[130] = "SWKARTIFICERDICE", [131] = "SWKARTIFICERDICE", [132] = "SWKARTIFICERDICE", [133] = "SWKARTIFICERDICE", [134] = "SWKARTIFICERDICE", 
	[135] = "SWKARTIFICERDICE", [136] = "SWKARTIFICERDICE", [137] = "SWKARTIFICERDICE", [138] = "SWKARTIFICERDICE", [139] = "SWKARTIFICERDICE", 
	[140] = "SWKARTIFICERDICE", [141] = "SWKARTIFICERDICE",
	[150] = "SWKANNULUSOFFOCUSDICE", [151] = "SWKANNULUSOFFOCUSDICE", [152] = "SWKANNULUSOFFOCUSDICE", [153] = "SWKANNULUSOFFOCUSDICE", [154] = "SWKANNULUSOFFOCUSDICE", 
	[155] = "SWKANNULUSOFFOCUSDICE", [156] = "SWKANNULUSOFFOCUSDICE", [157] = "SWKANNULUSOFFOCUSDICE", [158] = "SWKANNULUSOFFOCUSDICE", [159] = "SWKANNULUSOFFOCUSDICE", 
	[160] = "SWKANNULUSOFFOCUSDICEFX", [161] = "SWKANNULUSOFFOCUSDICEFX", [162] = "SWKANNULUSOFFOCUSDICEFX", [163] = "SWKANNULUSOFFOCUSDICEFX", [164] = "SWKANNULUSOFFOCUSDICEFX", 
	[165] = "SWKANNULUSOFFOCUSDICEFX", [166] = "SWKANNULUSOFFOCUSDICEFX", [167] = "SWKANNULUSOFFOCUSDICEFX", [168] = "SWKANNULUSOFFOCUSDICEFX", [169] = "SWKANNULUSOFFOCUSDICEFX", 
	[170] = "SWKANNULUSOFFOCUSDICE", [171] = "SWKANNULUSOFFOCUSDICE", [172] = "SWKANNULUSOFFOCUSDICE", [173] = "SWKANNULUSOFFOCUSDICE", [174] = "SWKANNULUSOFFOCUSDICE", 
	[175] = "SWKANNULUSOFFOCUSDICE", [177] = "SWKANNULUSOFFOCUSDICE", [178] = "SWKANNULUSOFFOCUSDICE", [179] = "SWKANNULUSOFFOCUSDICE", 
	[180] = "SWKANNULUSOFFOCUSDICEFX", [181] = "SWKANNULUSOFFOCUSDICEFX", [182] = "SWKANNULUSOFFOCUSDICEFX", [183] = "SWKANNULUSOFFOCUSDICEFX", [184] = "SWKANNULUSOFFOCUSDICEFX", 
	[185] = "SWKANNULUSOFFOCUSDICEFX", [187] = "SWKANNULUSOFFOCUSDICEFX", [188] = "SWKANNULUSOFFOCUSDICEFX", [189] = "SWKANNULUSOFFOCUSDICEFX", 
	[190] = "SWKKNOTSOFFATEDICE", [191] = "SWKKNOTSOFFATEDICE", [192] = "SWKKNOTSOFFATEDICE", [193] = "SWKKNOTSOFFATEDICE", [194] = "SWKKNOTSOFFATEDICE", 
	[195] = "SWKKNOTSOFFATEDICE", [196] = "SWKKNOTSOFFATEDICE", [197] = "SWKKNOTSOFFATEDICE", [198] = "SWKKNOTSOFFATEDICE", [199] = "SWKKNOTSOFFATEDICE", 
	[200] = "SWKKNOTSOFFATEDICEFX", [201] = "SWKKNOTSOFFATEDICEFX", [202] = "SWKKNOTSOFFATEDICEFX", [203] = "SWKKNOTSOFFATEDICEFX", [204] = "SWKKNOTSOFFATEDICEFX", 
	[205] = "SWKKNOTSOFFATEDICEFX", [206] = "SWKKNOTSOFFATEDICEFX", [207] = "SWKKNOTSOFFATEDICEFX", [208] = "SWKKNOTSOFFATEDICEFX", [209] = "SWKKNOTSOFFATEDICEFX", 
	[210] = "SWKKNOTSOFFATEDICE", [211] = "SWKKNOTSOFFATEDICE", [212] = "SWKKNOTSOFFATEDICE", [213] = "SWKKNOTSOFFATEDICE", [214] = "SWKKNOTSOFFATEDICE", 
	[215] = "SWKKNOTSOFFATEDICE", [216] = "SWKKNOTSOFFATEDICE", [217] = "SWKKNOTSOFFATEDICE", [218] = "SWKKNOTSOFFATEDICE", [219] = "SWKKNOTSOFFATEDICE", 
	[220] = "SWKKNOTSOFFATEDICEFX", [221] = "SWKKNOTSOFFATEDICEFX", [222] = "SWKKNOTSOFFATEDICEFX", [223] = "SWKKNOTSOFFATEDICEFX", [224] = "SWKKNOTSOFFATEDICEFX", 
	[225] = "SWKKNOTSOFFATEDICEFX", [226] = "SWKKNOTSOFFATEDICEFX", [227] = "SWKKNOTSOFFATEDICEFX", [228] = "SWKKNOTSOFFATEDICEFX", [229] = "SWKKNOTSOFFATEDICEFX", 
	[230] = "SWKBLOODDICE", [231] = "SWKBLOODDICE", [232] = "SWKBLOODDICE", [233] = "SWKBLOODDICE", [234] = "SWKBLOODDICE", 
	[235] = "SWKBLOODDICE", [236] = "SWKBLOODDICE", [237] = "SWKBLOODDICE", [238] = "SWKBLOODDICE", [239] = "SWKBLOODDICE", 
	[240] = "SWKSTARSANDCLOVERS", [241] = "SWKSTARSANDCLOVERS", [242] = "SWKSTARSANDCLOVERS", [243] = "SWKSTARSANDCLOVERS", [244] = "SWKSTARSANDCLOVERS", 
	[245] = "SWKSTARSANDCLOVERS", [246] = "SWKSTARSANDCLOVERS", [247] = "SWKSTARSANDCLOVERS", [248] = "SWKSTARSANDCLOVERS", [249] = "SWKSTARSANDCLOVERS", 
	[250] = "SWKHEARTSANDSKULLS", [251] = "SWKHEARTSANDSKULLS", [252] = "SWKHEARTSANDSKULLS", [253] = "SWKHEARTSANDSKULLS", [254] = "SWKHEARTSANDSKULLS", 
	[255] = "SWKHEARTSANDSKULLS", [256] = "SWKHEARTSANDSKULLS", [257] = "SWKHEARTSANDSKULLS", [258] = "SWKHEARTSANDSKULLS", [259] = "SWKHEARTSANDSKULLS", 
	[260] = "SWKMONSTERSDICE1", [261] = "SWKMONSTERSDICE1", [262] = "SWKMONSTERSDICE1", [263] = "SWKMONSTERSDICE1", [264] = "SWKMONSTERSDICE1", 
	[265] = "SWKMONSTERSDICE1", [266] = "SWKMONSTERSDICE1", [267] = "SWKMONSTERSDICE1", [268] = "SWKMONSTERSDICE1", [269] = "SWKMONSTERSDICE1", 
	[270] = "SWKMONSTERSDICE1", [271] = "SWKMONSTERSDICE1", [272] = "SWKMONSTERSDICE1", [273] = "SWKMONSTERSDICE1", [274] = "SWKMONSTERSDICE1", 
	[275] = "SWKMONSTERSDICE1", [276] = "SWKMONSTERSDICE1", [277] = "SWKMONSTERSDICE1", [278] = "SWKMONSTERSDICE1", [279] = "SWKMONSTERSDICE1", 
	[280] = "SWKMONSTERSDICE1", [281] = "SWKMONSTERSDICE1",
	[282] = "SWKDRAGONSDICE1", [283] = "SWKDRAGONSDICE1", [284] = "SWKDRAGONSDICE1", 
	[285] = "SWKDRAGONSDICE1", [286] = "SWKDRAGONSDICE1", [287] = "SWKDRAGONSDICE1", [288] = "SWKDRAGONSDICE1", [289] = "SWKDRAGONSDICE1", 
	[290] = "SWKDRAGONSDICE1", [291] = "SWKDRAGONSDICE1", [292] = "SWKDRAGONSDICE1", [293] = "SWKDRAGONSDICE1", [294] = "SWKDRAGONSDICE1", 
	[295] = "SWKDRAGONSDICE1", [296] = "SWKDRAGONSDICE1", [297] = "SWKDRAGONSDICE1", [298] = "SWKDRAGONSDICE1", [299] = "SWKDRAGONSDICE1", 
	[300] = "SWKDRAGONSDICE1", [301] = "SWKDRAGONSDICE1",
};

local _tDiceSkinAttributeInfo = {
	[0] = {bTintable = true},
	[1] = {bDisabled = true},
	[5] = {bTintable = true},
	[6] = {bTintable = true},
	[9] = {bTintable = true},
	[10] = {bFX = true},
	[11] = {bFX = true},
	[12] = {bFX = true},
	[13] = {bFX = true},
	[14] = {bFX = true},
	[15] = {bFX = true},
	[16] = {bFX = true},
	[17] = {bFX = true},
	[18] = {bFX = true},
	[19] = {bFX = true},
	[20] = {bFX = true},
	[21] = {bFX = true},
	[22] = {bFX = true},
	[23] = {bFX = true},
	[24] = {bFX = true},
	[25] = {bFX = true},
	[26] = {bFX = true},
	[27] = {bFX = true},
	[28] = {bFX = true},
	[29] = {bFX = true},
	[30] = {bFX = true, bTrail = true},
	[31] = {bFX = true, bTrail = true},
	[32] = {bFX = true, bTrail = true},
	[33] = {bFX = true, bTrail = true},
	[34] = {bFX = true, bTrail = true},
	[35] = {bFX = true, bTrail = true},
	[36] = {bFX = true, bTrail = true},
	[37] = {bFX = true, bTrail = true},
	[38] = {bFX = true, bTrail = true},
	[39] = {bFX = true, bTrail = true},
	[40] = {bFX = true},
	[41] = {bFX = true},
	[42] = {bFX = true},
	[43] = {bFX = true},
	[44] = {bFX = true},
	[45] = {bFX = true},
	[46] = {bFX = true},
	[47] = {bFX = true},
	[48] = {bFX = true},
	[49] = {bFX = true},
	[50] = {bFX = true},
	[51] = {bFX = true},
	[52] = {bFX = true},
	[53] = {bFX = true},
	[54] = {bFX = true},
	[55] = {bFX = true},
	[56] = {bFX = true},
	[57] = {bFX = true},
	[58] = {bFX = true},
	[59] = {bFX = true},
	[60] = {bTrail = true},
	[61] = {bTrail = true},
	[62] = {bTrail = true},
	[63] = {bTrail = true},
	[64] = {bTrail = true},
	[65] = {bTrail = true},
	[66] = {bTrail = true},
	[67] = {bTrail = true},
	[68] = {bTrail = true},
	[69] = {bTrail = true},
	[70] = {bTrail = true},
	[71] = {bTrail = true},
	[72] = {bTrail = true},
	[73] = {bTrail = true},
	[74] = {bTrail = true},
	[75] = {bTrail = true},
	[76] = {bTrail = true},
	[77] = {bTrail = true},
	[78] = {bTrail = true},
	[79] = {bTrail = true},
	[80] = {bFX = true},
	[81] = {bFX = true},
	[82] = {bFX = true},
	[83] = {bFX = true},
	[84] = {bFX = true},
	[85] = {bFX = true},
	[86] = {bFX = true},
	[87] = {bFX = true},
	[88] = {bFX = true},
	[89] = {bFX = true},
	[90] = {bDisabled = true},
	[91] = {bFX = true, bTintable = true},
	[92] = {bTintable = true},
	[93] = {bTintable = true},
	[110] = {bTintable = true},
	[111] = {bTintable = true},
	[130] = {bTintable = true},
	[150] = {bTintable = true},
	[160] = {bTrail = true, bTintable = true},
	[161] = {bTrail = true},
	[162] = {bTrail = true},
	[163] = {bTrail = true},
	[164] = {bTrail = true},
	[165] = {bTrail = true},
	[166] = {bTrail = true},
	[167] = {bTrail = true},
	[168] = {bTrail = true},
	[169] = {bTrail = true},
	[175] = {bTintable = true},
	[177] = {bTintable = true},
	[178] = {bTintable = true},
	[179] = {bTintable = true},
	[180] = {bTrail = true},
	[181] = {bTrail = true},
	[182] = {bTrail = true},
	[183] = {bTrail = true},
	[184] = {bTrail = true},
	[185] = {bTrail = true, bTintable = true},
	[187] = {bTrail = true, bTintable = true},
	[188] = {bTrail = true, bTintable = true},
	[189] = {bTrail = true, bTintable = true},
	[190] = {bTintable = true},
	[194] = {bTintable = true},
	[200] = {bTrail = true, bTintable = true},
	[201] = {bTrail = true},
	[202] = {bTrail = true},
	[203] = {bTrail = true},
	[204] = {bTrail = true, bTintable = true},
	[205] = {bTrail = true},
	[206] = {bTrail = true},
	[207] = {bTrail = true},
	[208] = {bTrail = true},
	[209] = {bTrail = true},
	[219] = {bTintable = true},
	[220] = {bTrail = true},
	[221] = {bTrail = true},
	[222] = {bTrail = true},
	[223] = {bTrail = true},
	[224] = {bTrail = true},
	[225] = {bTrail = true},
	[226] = {bTrail = true},
	[227] = {bTrail = true},
	[228] = {bTrail = true},
	[229] = {bTrail = true, bTintable = true},
	[230] = {bTrail = true},
	[231] = {bTrail = true},
	[232] = {bTrail = true},
	[233] = {bTrail = true},
	[234] = {bTrail = true},
	[235] = {bTrail = true, bTintable = true},
	[236] = {bTrail = true, bTintable = true},
	[237] = {bTrail = true, bTintable = true},
	[238] = {bTrail = true, bTintable = true},
	[239] = {bTrail = true, bTintable = true},
	[241] = {bTrail = true},
	[242] = {bTrail = true},
	[243] = {bTrail = true},
	[246] = {bTrail = true},
	[247] = {bTrail = true},
	[248] = {bTrail = true},
	[251] = {bTrail = true},
	[252] = {bTrail = true},
	[253] = {bTrail = true},
	[254] = {bTrail = true},
	[255] = {bTrail = true},
	[256] = {bTrail = true},
	[257] = {bTrail = true},
	[258] = {bTrail = true},
	[259] = {bTrail = true},
	[271] = {bFX = true},
	[272] = {bFX = true},
	[273] = {bFX = true},
	[274] = {bFX = true},
	[275] = {bFX = true},
	[276] = {bFX = true},
	[277] = {bFX = true},
	[278] = {bFX = true},
	[279] = {bFX = true},
	[280] = {bFX = true, bTrail = true},
	[281] = {bFX = true},
	[292] = {bFX = true},
	[293] = {bFX = true},
	[294] = {bFX = true},
	[295] = {bTrail = true},
	[296] = {bFX = true},
	[297] = {bFX = true},
	[298] = {bFX = true},
	[299] = {bFX = true},
	[300] = {bTrail = true},
	[301] = {bFX = true},
};

local _tDiceSkinInfo = {};

function onInit()
	local tDiceSkins = Interface.getDiceSkins();
	for _,v in pairs(tDiceSkins) do
		local tData = _tDiceSkinAttributeInfo[v];
		if not tData or not tData.bDisabled then
			local tInfo = Interface.getDiceSkinInfo(v);
			if tData then
				for k,v in pairs(tData) do
					tInfo[k] = v;
				end
			end
			_tDiceSkinInfo[v] = tInfo;
		end
	end
end

function getAllDiceSkins()
	return _tDiceSkinInfo;
end
function getDiceSkinInfo(tColor)
	if not tColor or not tColor.diceskin then
		return nil;
	end
	return _tDiceSkinInfo[tColor.diceskin];
end
function getDiceSkinInfoByID(nID)
	return _tDiceSkinInfo[nID];
end

function isDiceSkinOwned(tColor)
	if tColor and tColor.diceskin then
		return DiceSkinManager.isDiceSkinOwnedByID(tColor.diceskin);
	end
	return false;
end
function isDiceSkinOwnedByID(nID)
	if not nID then
		return false;
	end
	if nID == 0 then
		return true;
	end
	local tInfo = DiceSkinManager.getDiceSkinInfoByID(nID);
	if tInfo then
		return tInfo.owned or false;
	end
	return false;
end
function isDiceSkinTintable(tColor)
	if tColor and tColor.diceskin then
		return DiceSkinManager.isDiceSkinTintableByID(tColor.diceskin);
	end
	return false;
end
function isDiceSkinTintableByID(nID)
	if not nID then
		return false;
	end
	if nID == 0 then
		return true;
	end
	local tInfo = DiceSkinManager.getDiceSkinInfoByID(nID);
	if tInfo then
		return tInfo.bTintable or false;
	end
	return true;
end

function getDiceSkinGroups()
	return _tDiceSkinGroups;
end
function getDiceSkinGroup(nID)
	return _tDiceSkinToGroupMap[nID] or DiceSkinManager.DEFAULT_DICESKIN_GROUP;
end

function getDiceSkinGroupName(nID)
	return Interface.getString("diceskin_group_" .. DiceSkinManager.getDiceSkinGroup(nID));
end
function getDiceSkinName(tColor)
	if tColor and tColor.diceskin then
		return DiceSkinManager.getDiceSkinNameByID(tColor.diceskin);
	end
	return "";
end
function getDiceSkinNameByID(nID)
	return Interface.getString("diceskin_" .. nID);
end

function getDiceSkinIcon(tColor)
	if tColor and tColor.diceskin then
		return DiceSkinManager.getDiceSkinIconByID(tColor.diceskin);
	end
	return "diceskin_icon_default";
end
function getDiceSkinIconByID(nID)
	if nID and (nID > 0) then
		local sIDIcon = string.format("diceskin_icon_%d", nID);
		if Interface.isIcon(sIDIcon) then
			return sIDIcon;
		end
	end
	return "diceskin_icon_default";
end

--
-- CONVERSIONS
--		diceskin | diceboydcolor | dicetextcolor
--

function convertStringToTable(sDiceSkin)
	local tSplit = StringManager.split(sDiceSkin, "|", true);
	if #tSplit <= 1 and (tSplit[1] or "") == "" then
		return nil;
	end

	local tDiceSkin = {
		diceskin = tonumber(tSplit[1]) or 0,
		dicebodycolor = tSplit[2],
		dicetextcolor = tSplit[3],
	};
	return tDiceSkin;
end
function convertTableToString(tDiceSkin)
	if not tDiceSkin then
		return "";
	end

	local tOutput = {};
	if tDiceSkin.dicebodycolor or tDiceSkin.dicetextcolor then
		table.insert(tOutput, tDiceSkin.dicebodycolor or "");
		table.insert(tOutput, tDiceSkin.dicetextcolor or "");
	end
	if (#tOutput > 0) or ((tDiceSkin.diceskin or 0) ~= 0) then
		table.insert(tOutput, 1, tostring(tDiceSkin.diceskin or 0));
	end

	return table.concat(tOutput, "|");
end

--
--	COLOR WINDOW HANDLING
--

function populateDiceSelectWindow(w)
	local tDiceSkinGroupWindows = {};

	-- Create dice skin group windows
	local tDiceSkinGroups = DiceSkinManager.getDiceSkinGroups();
	for k,v in ipairs(tDiceSkinGroups) do
		local wDiceSkinGroup = w.sub_groups.subwindow.list.createWindow();
		wDiceSkinGroup.setData(k, v);
		tDiceSkinGroupWindows[v] = wDiceSkinGroup;
	end

	for nID, tInfo in pairs(DiceSkinManager.getAllDiceSkins()) do
		-- Get correct dice skin group window
		local sDiceSkinGroup = DiceSkinManager.getDiceSkinGroup(nID);
		local wDiceSkinGroup = tDiceSkinGroupWindows[sDiceSkinGroup];
		if not wDiceSkinGroup then
			wDiceSkinGroup = tDiceSkinGroupWindows[DiceSkinManager.DEFAULT_DICESKIN_GROUP];
		end

		-- Add dice skin list entry
		local wDiceSkin = wDiceSkinGroup.list.createWindow();
		wDiceSkin.setData(nID, tInfo);
		if wDiceSkin.isOwned() then
			wDiceSkinGroup.setOwned();
		end
	end

	local tDeleteSkinGroups = {};
	for _,wDiceSkinGroup in ipairs(w.sub_groups.subwindow.list.getWindows()) do
		if wDiceSkinGroup.list.isEmpty() then
			table.insert(tDeleteSkinGroups, wDiceSkinGroup);
		end
	end
	for _,wDiceSkinGroup in ipairs(tDeleteSkinGroups) do
		wDiceSkinGroup.close();
	end
end

function setupDiceSelectButton(cButton, nID)
	cButton.setIcons(DiceSkinManager.getDiceSkinIconByID(nID));
	cButton.setTooltipText(DiceSkinManager.getDiceSkinNameByID(nID));

	DiceSkinManager.setupButtonTintableWidget(cButton, nID);
	DiceSkinManager.setupButtonGeneralWidgets(cButton, nID)
end
function setupButtonTintableWidget(cButton, nID)
	local tInfo = _tDiceSkinInfo[nID];

	-- Tintable
	if tInfo and tInfo.bTintable then
		cButton.addBitmapWidget({
			icon = "diceskin_attribute_tintable", 
			position = "topright",
			x = -(DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE),
			y = (DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE),
			w = DiceSkinManager.WIDGET_SIZE,
			h = DiceSkinManager.WIDGET_SIZE,
		});
	end
end
function setupButtonColorWidgets(cButton, tColor)
	local tInfo = _tDiceSkinInfo[tColor.diceskin];

	-- Tintable
	if tInfo and tInfo.bTintable then
		local tWidget = {
			icon = "colorgizmo_bigbtn_base", 
			position = "topright",
			x = -(DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE),
			y = (DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE),
			w = DiceSkinManager.WIDGET_SIZE,
			h = DiceSkinManager.WIDGET_SIZE,
		};

		tWidget.icon = "colorgizmo_bigbtn_base";
		cButton.addBitmapWidget(tWidget);

		tWidget.icon = "colorgizmo_bigbtn_color";
		tWidget.color = tColor.dicebodycolor;
		cButton.addBitmapWidget(tWidget);
		
		tWidget.icon = "colorgizmo_bigbtn_effects";
		tWidget.color = nil;
		cButton.addBitmapWidget(tWidget);

		tWidget.y = (DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_SIZE + DiceSkinManager.WIDGET_HALF_SIZE);

		tWidget.icon = "colorgizmo_bigbtn_base";
		cButton.addBitmapWidget(tWidget);

		tWidget.icon = "colorgizmo_bigbtn_color";
		tWidget.color = tColor.dicetextcolor;
		cButton.addBitmapWidget(tWidget);
		
		tWidget.icon = "colorgizmo_bigbtn_effects";
		tWidget.color = nil;
		cButton.addBitmapWidget(tWidget);
	end
end
function setupButtonGeneralWidgets(cButton, nID)
	local tInfo = _tDiceSkinInfo[nID];

	-- Attributes
	if tInfo then
		local tWidget = {
			position = "topleft", 
			x = DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE,
			y = DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE,
			w = DiceSkinManager.WIDGET_SIZE,
			h = DiceSkinManager.WIDGET_SIZE,
		};

		if tInfo.bFX then
			tWidget.icon = "diceskin_attribute_fx";
			cButton.addBitmapWidget(tWidget);
			tWidget.y = tWidget.y + DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_SIZE;
		end
		if tInfo.bImpact then
			tWidget.icon = "diceskin_attribute_impact";
			cButton.addBitmapWidget(tWidget);
			tWidget.y = tWidget.y + DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_SIZE;
		end
		if tInfo.bTrail then
			tWidget.icon = "diceskin_attribute_trail";
			cButton.addBitmapWidget(tWidget);
			tWidget.y = tWidget.y + DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_SIZE;
		end
	end
end

function setupCustomControl(c, tColor, bDisabled)
	DiceSkinManager.setupControlBaseWidget(c, tColor, bDisabled);
	DiceSkinManager.setupControlColorWidgets(c, tColor, bDisabled);
	DiceSkinManager.setupControlGeneralWidgets(c, tColor, bDisabled)

	c.setTooltipText(DiceSkinManager.getDiceSkinName(tColor));
end
function setupControlBaseWidget(c, tColor, bDisabled)
	local wgt = c.findWidget("icon");
	if tColor then
		if not wgt then
			local tWidget = { 
				name = "icon", 
				w = c.getAnchoredWidth(),
				h = c.getAnchoredHeight(),
			};
			wgt = c.addBitmapWidget(tWidget);
		end
		wgt.setBitmap(DiceSkinManager.getDiceSkinIcon(tColor));
		if bDisabled then
			wgt.setColor("E62B2B2B");
		else
			wgt.setColor(nil);
		end
	else
		if wgt then
			wgt.destroy();
		end
	end
end
function setupControlColorWidgets(c, tColor, bDisabled)
	local tInfo = DiceSkinManager.getDiceSkinInfo(tColor);

	-- Tintable
	local wgt;
	if not bDisabled and tInfo and tInfo.bTintable then
		local bLarge = (c.getAnchoredWidth() > 20);

		local tWidget;
		if bLarge then
			tWidget = {
				position = "topright",
				x = -(DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE),
				y = (DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE),
				w = DiceSkinManager.WIDGET_SIZE,
				h = DiceSkinManager.WIDGET_SIZE,
			};
		else
			tWidget = {
				position = "topright",
				x = -(DiceSkinManager.CONTROL_WIDGET_PADDING + DiceSkinManager.CONTROL_WIDGET_HALF_SIZE),
				y = (DiceSkinManager.CONTROL_WIDGET_PADDING + DiceSkinManager.CONTROL_WIDGET_HALF_SIZE),
				w = DiceSkinManager.CONTROL_WIDGET_SIZE,
				h = DiceSkinManager.CONTROL_WIDGET_SIZE,
			};
		end

		wgt = c.findWidget("bodycolorbase");
		if not wgt then
			tWidget.name = "bodycolorbase";
			tWidget.icon = "colorgizmo_bigbtn_base";
			wgt = c.addBitmapWidget(tWidget);
		end

		wgt = c.findWidget("bodycolor");
		if not wgt then
			tWidget.name = "bodycolor";
			tWidget.icon = "colorgizmo_bigbtn_color";
			wgt = c.addBitmapWidget(tWidget);
		end
		wgt.setColor(tColor and tColor.dicebodycolor or "000000");
		
		wgt = c.findWidget("bodycolorfx");
		if not wgt then
			tWidget.name = "bodycolorfx";
			tWidget.icon = "colorgizmo_bigbtn_effects";
			wgt = c.addBitmapWidget(tWidget);
		end

		if bLarge then
			tWidget.y = (DiceSkinManager.WIDGET_SIZE + DiceSkinManager.WIDGET_HALF_SIZE);
		else
			tWidget.y = (DiceSkinManager.CONTROL_WIDGET_SIZE + DiceSkinManager.CONTROL_WIDGET_HALF_SIZE);
		end

		wgt = c.findWidget("textcolorbase");
		if not wgt then
			tWidget.name = "textcolorbase";
			tWidget.icon = "colorgizmo_bigbtn_base";
			wgt = c.addBitmapWidget(tWidget);
		end

		wgt = c.findWidget("textcolor");
		if not wgt then
			tWidget.name = "textcolor";
			tWidget.icon = "colorgizmo_bigbtn_color";
			wgt = c.addBitmapWidget(tWidget);
		end
		wgt.setColor(tColor and tColor.dicetextcolor or "000000");

		wgt = c.findWidget("textcolorfx");
		if not wgt then
			tWidget.name = "textcolorfx";
			tWidget.icon = "colorgizmo_bigbtn_effects";
			wgt = c.addBitmapWidget(tWidget);
		end
	else
		wgt = c.findWidget("bodycolorbase");
		if wgt then
			wgt.destroy();
		end
		wgt = c.findWidget("bodycolor");
		if wgt then
			wgt.destroy();
		end
		wgt = c.findWidget("bodycolorfx");
		if wgt then
			wgt.destroy();
		end

		wgt = c.findWidget("textcolorbase");
		if wgt then
			wgt.destroy();
		end
		wgt = c.findWidget("textcolor");
		if wgt then
			wgt.destroy();
		end
		wgt = c.findWidget("textcolorfx");
		if wgt then
			wgt.destroy();
		end
	end
end
function setupControlGeneralWidgets(c, tColor, bDisabled)
	local tInfo = DiceSkinManager.getDiceSkinInfo(tColor);

	-- Attributes
	if not bDisabled and tInfo then
		local bLarge = (c.getAnchoredWidth() > 20);

		local tWidget;
		if bLarge then
			tWidget = {
				position = "topleft", 
				x = DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE,
				y = DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE,
				w = DiceSkinManager.WIDGET_SIZE,
				h = DiceSkinManager.WIDGET_SIZE,
			};
		else
			tWidget = {
				position = "topleft", 
				x = DiceSkinManager.CONTROL_WIDGET_PADDING + DiceSkinManager.CONTROL_WIDGET_HALF_SIZE,
				y = DiceSkinManager.CONTROL_WIDGET_PADDING + DiceSkinManager.CONTROL_WIDGET_HALF_SIZE,
				w = DiceSkinManager.CONTROL_WIDGET_SIZE,
				h = DiceSkinManager.CONTROL_WIDGET_SIZE,
			};
		end

		wgt = c.findWidget("attributefx");
		if tInfo.bFX then
			if not wgt then
				tWidget.name = "attributefx";
				tWidget.icon = "diceskin_attribute_fx";
				c.addBitmapWidget(tWidget);
			else
				wgt.setPosition(tWidget.position, tWidget.x, tWidget.y);
			end
			if bLarge then
				tWidget.y = tWidget.y + DiceSkinManager.WIDGET_SIZE;
			else
				tWidget.y = tWidget.y + DiceSkinManager.CONTROL_WIDGET_SIZE;
			end
		end
		wgt = c.findWidget("attributeimpact");
		if tInfo.bImpact then
			if not wgt then
				tWidget.name = "attributeimpact";
				tWidget.icon = "diceskin_attribute_impact";
				c.addBitmapWidget(tWidget);
			else
				wgt.setPosition(tWidget.position, tWidget.x, tWidget.y);
			end
			if bLarge then
				tWidget.y = tWidget.y + DiceSkinManager.WIDGET_SIZE;
			else
				tWidget.y = tWidget.y + DiceSkinManager.CONTROL_WIDGET_SIZE;
			end
		end
		wgt = c.findWidget("attributetrail");
		if tInfo.bTrail then
			if not wgt then
				tWidget.name = "attributetrail";
				tWidget.icon = "diceskin_attribute_trail";
				c.addBitmapWidget(tWidget);
			else
				wgt.setPosition(tWidget.position, tWidget.x, tWidget.y);
			end
			if bLarge then
				tWidget.y = tWidget.y + DiceSkinManager.WIDGET_SIZE;
			else
				tWidget.y = tWidget.y + DiceSkinManager.CONTROL_WIDGET_SIZE;
			end
		end
	else
		wgt = c.findWidget("attributefx");
		if wgt then
			wgt.destroy();
		end
		wgt = c.findWidget("attributeimpact");
		if wgt then
			wgt.destroy();
		end
		wgt = c.findWidget("attributetrail");
		if wgt then
			wgt.destroy();
		end
	end
end

function getDiceSkinGroupStoreID(sGroupID)
	return _tDiceSkinGroupStoreID[sGroupID] or sGroupID;
end
function onDiceSelectButtonActivate(nID)
	if DiceSkinManager.isDiceSkinOwnedByID(nID) then
		UserManager.setDiceSkin(nID);
	else
		UtilityManager.sendToStoreDLC(DiceSkinManager.getDiceSkinGroupStoreID(DiceSkinManager.getDiceSkinGroup(nID)));
	end
end
function onDiceSelectButtonDrag(draginfo, nID)
	draginfo.setType("diceskin");
	draginfo.setIcon(DiceSkinManager.getDiceSkinIconByID(nID));
	draginfo.setDescription(DiceSkinManager.getDiceSkinNameByID(nID));

	local tDiceSkinData = { nID, UserManager.getDiceBodyColor(), UserManager.getDiceTextColor() };
	draginfo.setStringData(table.concat(tDiceSkinData, "|"));

	return true;
end
