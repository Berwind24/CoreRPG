-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

DICE_SCALE_MIN = 80;
DICE_SCALE_MAX = 120;

function onInit()
	DiceManager.populateDiceSelectWindow(self);
	DiceSkinManager.populateDiceSelectWindow(self);
	self.updateDiceDesktopDisplay();
	self.updateDiceSkinDisplay();

	UserManager.registerColorCallback(self.updateDiceSkinDisplay);
end
function onClose()
	UserManager.unregisterColorCallback(self.updateDiceSkinDisplay);
end

--
--	UI - SIZE CHANGE
--

function updateDiceDesktopDisplay()
	local nScale = Interface.getDiceRelativeScale();
	sub_desktop.subwindow.button_desktop_scaledown.setVisible(nScale > DICE_SCALE_MIN);
	sub_desktop.subwindow.button_desktop_scaleup.setVisible(nScale < DICE_SCALE_MAX);
	sub_desktop.subwindow.label_desktop_scale.setValue(nScale .. "%");
end

function onDiceScaleDown()
	local nScale = Interface.getDiceRelativeScale();
	if nScale > DICE_SCALE_MIN then
		Interface.setDiceRelativeScale(nScale - 10);
	end
	self.updateDiceDesktopDisplay();
end
function onDiceScaleUp()
	local nScale = Interface.getDiceRelativeScale();
	if nScale < DICE_SCALE_MAX then
		Interface.setDiceRelativeScale(nScale + 10);
	end
	self.updateDiceDesktopDisplay();
end

--
--	UI - COLOR SELECTORS
--

function updateDiceSkinDisplay()
	local tUserColor = UserManager.getColor();

	sub_color.subwindow.color_body.setValue(tUserColor.dicebodycolor);
	sub_color.subwindow.color_text.setValue(tUserColor.dicetextcolor);

	local bTintable = DiceSkinManager.isDiceSkinTintable(tUserColor);
	sub_color.subwindow.label_color_body.setVisible(bTintable);
	sub_color.subwindow.label_color_text.setVisible(bTintable);
	sub_color.subwindow.color_body.setVisible(bTintable);
	sub_color.subwindow.color_text.setVisible(bTintable);

	for _,wDiceSkinGroup in ipairs(sub_groups.subwindow.list.getWindows()) do
		for _,wDiceSkin in ipairs(wDiceSkinGroup.list.getWindows()) do
			local bActive = (wDiceSkin.getID() == tUserColor.diceskin);
			wDiceSkin.setActive(bActive);
		end
	end
end

function onDiceBodyColorChanged(sColor)
	UserManager.setDiceBodyColor(sColor);
end
function onDiceTextColorChanged(sColor)
	UserManager.setDiceTextColor(sColor);
end
