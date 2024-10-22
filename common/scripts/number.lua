-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if rollable or (gmrollable and Session.IsHost) then
		addBitmapWidget({ icon = "field_rollable", position="bottomleft", x = -1, y = -4 });
		setHoverCursor("hand");
	elseif rollable2 or (gmrollable2 and Session.IsHost) then
		local w = addBitmapWidget({ icon = "field_rollable_transparent", position="topright", x = 0, y = 2 });
		w.sendToBack();
		setHoverCursor("hand");
	end
end

function onDrop(x, y, draginfo)
	if draginfo.getType() ~= "number" then
		return false;
	end
end

function increment(n)
	setValue(getValue() + (n or 1));
	return getValue()
end

function onWheel(n)
	if isReadOnly() then
		return false;
	end
	
	if not Input.isControlPressed() then
		return false;
	end
	
	local mult = 1;
	if wheel then
		mult = tonumber(wheel[1]) or 1;
	end
	self.increment(n * mult);
	return true;
end
