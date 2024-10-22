-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

localdatabasenode = nil;
id = "";
function setData(n, node)
	id = n;
	localdatabasenode = node;
end

function openCharacter()
	if not bRequested then
		User.requestIdentity(id, "charsheet", "name", self.localdatabasenode, self.requestResponse);
		bRequested = true;
	end
end

function requestResponse(result, identity)
	if result and identity and windowlist then
		windowlist.window.close();
	else
		error.setVisible(true);
	end
end
