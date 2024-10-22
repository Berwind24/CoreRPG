-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	self.initRecordTypeControls();
	self.update();
end
function initRecordTypeControls()
	if link then
		link.setValue(UtilityManager.getTopWindow(self).getClass());
	end

	local sRecordType = WindowManager.getRecordType(self);

	if not nonid_name and RecordDataManager.getIDMode(sRecordType) then
		if sRecordType == "image" then
			createControl("string_record_header_name_nonid_image", "nonid_name");
		else
			createControl("string_record_header_name_nonid", "nonid_name");
		end
		createControl("sub_record_header_nonid_edit", "sub_nonid_edit");
	end
	if RecordDataManager.getCustomDieMode(sRecordType) then
		if not customdie then
			createControl("icon_record_header_customdie", "customdie");
		end
	end
	if not picture and RecordDataManager.getPictureMode(sRecordType) then
		createControl("icon_record_header_picture", "picture");
	end
	if not token and RecordDataManager.getTokenMode(sRecordType) then
		createControl("icon_record_header_token", "token");
	end

	if name then
		if sRecordType ~= "" then
			name.setEmptyText(RecordDataManager.getRecordTypeDisplayTextEmpty(sRecordType));
		elseif name_emptyres then
			name.setEmptyText(Interface.getString(name_emptyres[1]));
		end
	end
	if nonid_name then
		if sRecordType ~= "" then
			nonid_name.setEmptyText(RecordDataManager.getRecordTypeDisplayTextEmptyUnidentified(sRecordType));
		elseif nonid_name_emptyres then
			nonid_name.setEmptyText(Interface.getString(nonid_name_emptyres[1]));
		end
	end
	if nonid_name_edit then
		if sRecordType ~= "" then
			nonid_name_edit.setEmptyText(RecordDataManager.getRecordTypeDisplayTextEmptyUnidentified(sRecordType));
		elseif nonid_name_emptyres then
			nonid_name_edit.setEmptyText(Interface.getString(nonid_name_emptyres[1]));
		end
	end
end

function onIDChanged()
	self.update();
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);

	name.setReadOnly(bReadOnly);
	if nonid_name then
		local sRecordType = WindowManager.getRecordType(self);
		local bID = RecordDataManager.getIDState(sRecordType, nodeRecord);
		nonid_name.setReadOnly(bReadOnly);
		name.setVisible(bID);
		nonid_name.setVisible(not bID);
	end
	if picture then
		picture.setReadOnly(bReadOnly);
		picture.setVisible(not bReadOnly or (DB.getValue(nodeRecord, "picture", "") ~= ""));
	end
	if token then
		token.setReadOnly(bReadOnly);
		token.setVisible(not bReadOnly or (DB.getValue(nodeRecord, "token", "") ~= ""));
	end
	if Session.IsHost and sub_nonid_edit then
		local bEmpty = (DB.getValue(nodeRecord, "nonid_name", "") == "");
		sub_nonid_edit.setVisible(not bReadOnly or not bEmpty);
		WindowManager.callSafeControlUpdate(self, "sub_nonid_edit", bReadOnly);		
	end

	if customdie then
		local bShowCustomDie = (DB.getValue(nodeRecord, "customdie", "") ~= "");
		customdie.setVisible(bShowCustomDie);
	end
end

function onDrop(x, y, draginfo)
	if not draginfo.isType("diceskin") then
		return false;
	end
	if WindowManager.getReadOnlyState(getDatabaseNode()) then
		return false;
	end
	local sRecordType = WindowManager.getRecordType(self);
	if not RecordDataManager.getCustomDieMode(sRecordType) then
		return false;
	end

	DB.setValue(getDatabaseNode(), "customdie", "string", draginfo.getStringData());
	return true;
end
