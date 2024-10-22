-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _sAssetName;
local _sAssetType;
function getData()
	return _sAssetName, _sAssetType;
end
function setData(sAssetName, sAssetType)
	_sAssetName = sAssetName;
	_sAssetType = sAssetType;

	preview.setAsset(_sAssetName);

	sub_buttons.setVisible(Session.IsHost and ((_sAssetType or "") == "image"));
end

function handleDrag(draginfo)
	if (_sAssetType or "") ~= "" then
		draginfo.setType(_sAssetType);
		draginfo.setTokenData(_sAssetName);
		return true;
	end
end

function onQuickMapClicked()
	if (_sAssetType or "") ~= "" then
		QuickMapManager.openWindowWithAsset(_sAssetName);
		close();
	end
end
function onShareClicked()
	if (_sAssetType or "") ~= "" then
		PictureManager.createPictureItem(_sAssetName);
		close();
	end
end
function onImportClicked()
	if (_sAssetType or "") ~= "" then
		CampaignDataManager.createImageRecordFromAsset(_sAssetName, true);
		close();
	end
end
function onDecalClicked()
	if (_sAssetType or "") ~= "" then
		DecalManager.setDecal(_sAssetName);
		close();
	end
end
