--
--  Please see the license.html file included with this distribution for
--  attribution and copyright information.
--

function update()
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());

	subtype.setReadOnly(bReadOnly);
	disabled.setReadOnly(bReadOnly);
	patterns.update(bReadOnly);
end
