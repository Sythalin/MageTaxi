--  MageTaxi Classic--
-- Created by: Sythalin --
-- (c) 2008-2019 All rights reserved.

MageTaxi = MageTaxi or CreateFrame("Frame")
MageTaxi:SetScript("OnEvent", function(self, event, ...) if MageTaxi[event] then return MageTaxi[event](self, event, ...) end end)
MageTaxi:RegisterEvent("ADDON_LOADED")
MageTaxi:Show()

	----------------
	-- LOCAL VARS --
	----------------
local mainFrame, buttonFrame, cityFrame, b, cb, e, fs

function MageTaxi:CHAT_MSG_CHANNEL_NOTICE()
	MageTaxi_UpdateMsg()
end

function MageTaxi:ADDON_LOADED(_,addon)
	if addon ~= "MageTaxi_Classic" then return end
	
	MageTaxi_Info = MageTaxi_Info or {
		["basePrice"] = "50s",
		["travelPrice"] = "75s",
		["plusPrice"] = "10s",
		["selectCity"] = "",
		["baseMsg"] = "WTS portals in ".. GetZoneText().. ", 50s"
	}
	MageTaxi_Settings = MageTaxi_Settings or {
		["pos"] = {
			["point"] = "CENTER",
			["parent"] = "UIParent",
			["relPoint"] = "CENTER",
			["offX"] = 0,
			["offY"] = 0 
			}}
	MageTaxi_Options = MageTaxi_Options or {
		["postTravel"] = false,
		["postPlus"] = false,
		["local"] = false,
		}
	
	SLASH_MAGETAXI1 = "/magetaxi"
	SLASH_MAGETAXI2 = "/mtaxi"
	SlashCmdList["MAGETAXI"] = MageTaxi_GUI
	self:SetFaction()
	MageTaxi:UnregisterEvent("ADDON_LOADED")
	MageTaxi:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
end

	-----------------------
	-- PORTAL SPELL LIST --
	-----------------------
local portalSpells = {
	[1] = "Portal: Stormwind",
	[2] = "Portal: Ironforge",
	[3] = "Portal: Darnassus",
	[4] = "Portal: Undercity",
	[5] = "Portal: Orgrimmar",
	[6] = "Portal: Thunder Bluff",
	}
	
	---------------
	-- CITY LIST --
	---------------
function MageTaxi:SetFaction()
	if UnitFactionGroup("player") == "Alliance" then
		cityList = {
			[1] = "Stormwind",
			[2] = "Ironforge",
			[3] = "Darnassus",
		}
	else
		cityList = {
			[1] = "Orgrimmar",
			[2] = "Undercity",
			[3] = "ThunderBluff",
		}
	end
	MageTaxi.selectCity=cityList[1]
end
	---------------
	-- TEMPLATES --
	---------------
	
	-- BUTTONS--
function MageTaxi:CreateButton(name, parent, text)
	b = CreateFrame("BUTTON", name, parent, "OptionsButtonTemplate")
		b:SetText(text)
		b:SetWidth(MageTaxi_ButtonFrame:GetWidth())
		b:RegisterForClicks("LeftButtonUp")
		b:SetNormalFontObject("GameFontNormalSmall")
		b:SetHighlightFontObject("GameFontWhiteSmall")
	return b
end

-- EDITBOXES --
function MageTaxi:CreateInput(name, parent)
	e = CreateFrame("EditBox", name, parent)
		e:SetWidth(30)
		e:SetHeight(18)
		e:SetBackdrop({
			bgFile="",
			edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
			tile="true",
			tileSize= 32,
			edgeSize=10,
			insets = {left=5, right=5, top=5, bottom=5}
		})
		e:SetAutoFocus(false)
		e:SetTextInsets(5,0,0,0)
		e:SetFontObject("GameFontBlackSmall")
		e:SetTextColor(1,1,1)
		e:SetMaxLetters(6)
		e:SetScript("OnEscapePressed", e.ClearFocus)			
	return e
end

-- FONTSTRING --
function MageTaxi:CreateText(name, parent, text)
	fs = self:CreateFontString(name)
	fs:SetFontObject("GameFontNormalSmall")
	fs:SetJustifyH("RIGHT")
	fs:SetWidth(60)
	fs:SetText(text)
	fs:SetPoint("RIGHT", parent, "LEFT", -2,0)
end

	----------------
	-- CREATE GUI --
	----------------
function MageTaxi_GUI()
	if MageTaxi_Config then MageTaxi_Config:Show() return end
	
	mainFrame = CreateFrame("FRAME", "MageTaxi_Config")
		mainFrame:SetSize(300, 160)
		mainFrame:SetPoint(MageTaxi_Settings.pos.point, MageTaxi_Settings.pos.parent, MageTaxi_Settings.pos.relPoint, MageTaxi_Settings.pos.offX,MageTaxi_Settings.pos.offY)
		mainFrame:SetBackdrop({
			bgFile = "Interface/TutorialFrame/TutorialFrameBackground",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = "true",
			tileSize = 32,
			edgeSize = 10,
			insets = {left = 3, right = 3, top = 3, bottom = 3}
			})
		mainFrame:EnableMouse(true)
		mainFrame:SetMovable(true)
		mainFrame:SetClampedToScreen(true)
		mainFrame:RegisterForDrag("LeftButton")
		mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
		mainFrame:SetScript("OnDragStop", function()
			mainFrame:StopMovingOrSizing()
			local point, parent, relPoint, offX, offY = mainFrame:GetPoint()
			MageTaxi_Settings.pos.point = point
			MageTaxi_Settings.pos.parent = parent
			MageTaxi_Settings.pos.relPoint = relPoint
			MageTaxi_Settings.pos.offX = offX
			MageTaxi_Settings.pos.offY = offY
			end)
		tinsert(UISpecialFrames,"MageTaxi_Config")
		
	titleFrame = CreateFrame("FRAME", "MageTaxi_Header", mainFrame)
		titleFrame:SetSize(mainFrame:GetWidth()/2, 20)
		titleFrame:SetPoint("CENTER", mainFrame, "TOP", 0, 0)
		titleFrame:SetBackdrop({
			bgFile = "Interface/Buttons/BlueGrad64",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = "false",
			tileSize = 18,
			edgeSize = 10,
			insets = {left = 3, right = 3, top = 3, bottom = 3}
			})
		
	fs = titleFrame:CreateFontString("MageTaxi_Title")		
		fs:SetPoint("CENTER", titleFrame, "CENTER", 0,0)
		fs:SetFontObject("GameFontWhite")
		fs:SetJustifyH("CENTER")
		fs:SetText("MageTaxi Classic 1.1")
	
	e = CreateFrame("EDITBOX", "MageTaxi_MessageBox", mainFrame)
		e:SetSize(mainFrame:GetWidth()-8,200)
		e:SetPoint("TOP", mainFrame, "TOP", 0, -22)
		e:SetBackdrop({
			edgeFile="Interface/Tooltips/UI-Tooltip-Border",
			edgeSize=10
			})
		e:SetAutoFocus(false)
		e:SetMultiLine(true)
		e:SetTextInsets(5,5,5,5)
		e:SetFontObject("GameFontNormal")
		e:SetTextColor(1,1,1)
		e:SetScript("OnEscapePressed", e.Clearfocus)
		e:SetScript("OnEnterPressed", function(self)
			MageTaxi_Info.baseMsg = self:GetText()
			end)
		MageTaxi_UpdateMsg()
		
	cb = CreateFrame("CHECKBUTTON", "MageTaxi_TravelCheck", mainFrame, "OptionsCheckButtonTemplate")
		cb:SetSize(20,20)
		cb:SetPoint("TOPLEFT", e, "BOTTOMLEFT", 4, 0)
		cb:SetScript("OnClick", function(self)
				if self:GetChecked() then
					MageTaxi_Options.postTravel = true
				else
					MageTaxi_Options.postTravel = false
				end
				MageTaxi_UpdateMsg()
			end)
		if MageTaxi_Options["postTravel"] == true then
			cb:SetChecked(true)
		end
		
	fs = mainFrame:CreateFontString("MageTaxi_TravelCheckText")
				fs:SetFontObject("GameFontNormal")
				fs:SetJustifyH("RIGHT")
				fs:SetText("Add Travel Price")
				fs:SetPoint("LEFT", cb, "RIGHT", 0, 0)
					
	--------------			
	--- BUTTONS --
	--------------
	buttonFrame = CreateFrame("FRAME", "MageTaxi_ButtonFrame", mainFrame)
		buttonFrame:SetSize(110, 63)
		buttonFrame:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -10, 6)
		--buttonFrame:SetBackdrop({
		--		edgeFile="Interface/Tooltips/UI-Tooltip-Border",
		--		edgeSize=10
		--		})
	
	b = MageTaxi:CreateButton("MageTaxi_AdvertiseButton", buttonFrame, "Advertise")
		b:SetPoint("TOP", buttonFrame, "TOP", 0, 0)
		b:SetScript("OnClick", function() MageTaxi_Broadcast(MageTaxi_MessageBox:GetText())end)
		
	b = MageTaxi:CreateButton("MageTaxi_LFMButton", buttonFrame, "LFM", lfm)
		b:SetPoint("TOP", MageTaxi_AdvertiseButton, "BOTTOM", 0, 0)
		b:SetScript("OnClick", function()
			local msg = "Portal requested to ".. MageTaxi_Info.selectCity.. " from ".. GetZoneText().. ", PST to join for ".. MageTaxi_Info.plusPrice
			MageTaxi_Broadcast(msg)
			end)
			
	b = MageTaxi:CreateButton("MageTaxi_LastCallButton", buttonFrame, "Last Call")
		b:SetPoint("TOP", MageTaxi_LFMButton, "BOTTOM", 0, 0)
		b:SetScript("OnClick", function()
			local msg ="LAST CALL: Porting to ".. MageTaxi_Info.selectCity.. " from ".. GetZoneText().. ", PST to be included for ".. MageTaxi_Info.plusPrice
			MageTaxi_Broadcast(msg)
			end)
		
	------------------------
	-- CITY RADIO BUTTONS --
	------------------------
	cityFrame = CreateFrame("FRAME", "MageTaxi_CityFrame", mainFrame)
		cityFrame:SetSize(110, 63)
		cityFrame:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMLEFT", 10, 6)
		--cityFrame:SetBackdrop({
		--	edgeFile="Interface/Tooltips/UI-Tooltip-Border",
		--	edgeSize=10
		--	})
		
	cb = CreateFrame("CHECKBUTTON", "MageTaxi_City1", cityFrame, "UIRadioButtonTemplate")
		cb:SetPoint("TOPLEFT", cityFrame, "TOPLEFT", 0, -7)
		cb:SetScript("OnClick", function(self) MageTaxi_CityClick(self, 1) end)
	
	fs = cityFrame:CreateFontString("MageTaxi_CityText1")
		fs:SetPoint("LEFT", cb, "RIGHT", 2,0)
		fs:SetFontObject("GameFontNormal")
		fs:SetJustifyH("LEFT")
		fs:SetText(gsub(cityList[1], "([a-z]+)([A-Z][a-z]+)", "%1 %2"))	
		
	cb = CreateFrame("CHECKBUTTON", "MageTaxi_City2", cityFrame, "UIRadioButtonTemplate")
		cb:SetPoint("TOP", "MageTaxi_City1", "BOTTOM", 0, 0)
		cb:SetScript("OnClick", function(self) MageTaxi_CityClick(self, 2) end)
	
	fs = cityFrame:CreateFontString("MageTaxi_CityText2")
		fs:SetPoint("LEFT", cb, "RIGHT", 2,0)
		fs:SetFontObject("GameFontNormal")
		fs:SetJustifyH("LEFT")
		fs:SetText(gsub(cityList[2], "([a-z]+)([A-Z][a-z]+)", "%1 %2"))	
		
	cb = CreateFrame("CHECKBUTTON", "MageTaxi_City3", cityFrame, "UIRadioButtonTemplate")
		cb:SetPoint("TOP", "MageTaxi_City2", "BOTTOM", 0, 0)
		cb:SetScript("OnClick", function(self) MageTaxi_CityClick(self, 3) end)
	
	fs = cityFrame:CreateFontString("MageTaxi_CityText3")
		fs:SetPoint("LEFT", cb, "RIGHT", 2,0)
		fs:SetFontObject("GameFontNormal")
		fs:SetJustifyH("LEFT")
		fs:SetText(gsub(cityList[3], "([a-z]+)([A-Z][a-z]+)", "%1 %2"))
			
	-----------------
	-- CAST BUTTON --
	-----------------
	b = CreateFrame("BUTTON", "MageTaxi_CastButton", mainFrame, "SecureActionButtonTemplate")
		b:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, 12)
		b:SetHeight(50)
		b:SetWidth(50)
		b.texture = b:CreateTexture("MT_CastTexture")
			b.texture:SetAllPoints(b)
			b.texture:SetTexture("Interface/Icons/Spell_Arcane_Portal".. MageTaxi.selectCity)
		b:SetAttribute("type", "spell")
		-- b:SetAttribute("spell", "Portal: ".. MageTaxi.selectCity)
		 b:SetAttribute("spell", "Portal: ".. MageTaxi.selectCity)
	
	----------------
	--   PRICING  --
	----------------	
	priceFrame = CreateFrame("FRAME", "MageTaxi_PriceFrame", mainFrame)
		priceFrame:SetSize(mainFrame:GetWidth()-8, 22)
		priceFrame:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, 70)
		--priceFrame:SetBackdrop({
		--	edgeFile="Interface/Tooltips/UI-Tooltip-Border",
		--	edgeSize=10
		--})
	
	-- BASE PRICE --
	fs = priceFrame:CreateFontString("MageTaxi_BaseLabel")
		fs:SetFontObject("GameFontNormalSmall")
		fs:SetJustifyH("RIGHT")
		fs:SetWidth(60)
		fs:SetText("Base Price")
		fs:SetPoint("LEFT", priceFrame, "LEFT", 0,0)
		
	e = MageTaxi:CreateInput("MageTaxi_PriceBox", priceFrame)
		e:SetPoint("LEFT", fs, "RIGHT", 4,0)
		e:SetText(MageTaxi_Info.basePrice)
		e:SetScript("OnEnterPressed", function(self) MageTaxi_LockInPrice(self, "basePrice") end)
		e:SetScript("OnTabPressed", function(self)
			MageTaxi_LockInPrice(self, "basePrice")
			MageTaxi_TravelBox:SetFocus() 
			end)
	-- TRAVEL PRICE --
	fs = priceFrame:CreateFontString("MageTaxi_TravelLabel")
		fs:SetFontObject("GameFontNormalSmall")
		fs:SetJustifyH("RIGHT")
		fs:SetWidth(60)
		fs:SetText("Travel Price")
		fs:SetPoint("LEFT", e, "RIGHT", 4,0)
	
	e = MageTaxi:CreateInput("MageTaxi_TravelBox", priceFrame)
		e:SetPoint("LEFT", fs, "RIGHT", 4,0)
		e:SetText(MageTaxi_Info.travelPrice)
		e:SetScript("OnEnterPressed", function(self) MageTaxi_LockInPrice(self, "travelPrice") end)
		e:SetScript("OnTabPressed", function(self)
			MageTaxi_LockInPrice(self, "travelPrice")
			MageTaxi_PlusBox:SetFocus() 
			end)
	-- PLUS PRICE --
	fs = priceFrame:CreateFontString("MageTaxi_PlusLabel")
		fs:SetFontObject("GameFontNormalSmall")
			fs:SetJustifyH("RIGHT")
			fs:SetWidth(60)
			fs:SetText("Plus Price")
			fs:SetPoint("LEFT", e, "RIGHT", 0,0)
		
	e = MageTaxi:CreateInput("MageTaxi_PlusBox", priceFrame)
		e:SetPoint("LEFT", fs, "RIGHT", 4,0)
		e:SetText(MageTaxi_Info.plusPrice)
		e:SetScript("OnEnterPressed", function(self) MageTaxi_LockInPrice(self, "plusPrice") end)
		e:SetScript("OnTabPressed", function(self) 
			MageTaxi_PriceBox:SetFocus() 
			MageTaxi_LockInPrice(self, "plusPrice") 
			end)
	

	------------------
	-- CLOSE BUTTON --
	------------------		
	b = CreateFrame("BUTTON", mainFrame:GetName().."_CLOSE", mainFrame, "OptionsButtonTemplate")
		b:SetText("X")
		b:SetWidth(25)
		b:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", 0, 0)
		b:SetBackdrop({
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			edgeSize = 10,
			})
		b:RegisterForClicks("LeftButtonUp")
		b:SetNormalFontObject("GameFontNormalSmall")
		b:SetHighlightFontObject("GameFontWhiteSmall")
		b:SetScript("OnClick", function()
			mainFrame:Hide()
			end)
				
	----------------------------	
	-- DISABLE UNKNOWN SPELLS --
	----------------------------

	for i = 1, #cityList do
		local noUsable = 0
		-- make sure to compensate for "Thunder Bluff"
		local usable = IsUsableSpell("Portal: ".. gsub(cityList[i], "([a-z]+)([A-Z][a-z]+)", "%1 %2")) 
		if (not usable) then
			_G["MageTaxi_City"..i]:Disable()
			_G["MageTaxi_CityText"..i]:SetAlpha(.2)
			noUsable = noUsable + 1
		end
		
		if (noUsable == #cityList) then
			MageTaxi.selectCity = nil
		end
	end

end


function MageTaxi_LockInPrice(self, price)
	self:ClearFocus()
	MageTaxi_Info[price] = self:GetText()
	MageTaxi_UpdateMsg()
end
	
function MageTaxi_UpdateMsg()
	local msg = "WTS portals in ".. GetZoneText().. ", ".. MageTaxi_Info.basePrice
	if MageTaxi_Options.postTravel == true then
		msg = msg.. " (".. MageTaxi_Info.travelPrice.. " for me to come to another city)"
	else
		MageTaxi_MessageBox:SetText(msg)
	end
	MageTaxi_MessageBox:SetText(msg)
end

function MageTaxi_CityClick(self, num)
	for i = 1,3 do
		_G["MageTaxi_City"..i]:SetChecked(false)
	end
	self:SetChecked(true)
	-- MageTaxi_Info.selectCity = gsub(cityList[num], "([a-z]+)([A-Z][a-z]+)", "%1 %2")
	MageTaxi_Info.selectCity = cityList[num]
	MageTaxi_CastButton.texture:SetTexture("Interface/Icons/Spell_Arcane_Portal"..MageTaxi_Info.selectCity)
	-- TB icon is one word, spell name is 2.  Such a pain in the ass....
	if MageTaxi_Info.selectCity == "ThunderBluff" then
		MageTaxi_Info.selectCity = "Thunder Bluff"
	end
	MageTaxi_CastButton:SetAttribute("spell", "Portal: ".. MageTaxi_Info.selectCity)
	MageTaxi_UpdateMsg()
end

function MageTaxi_Broadcast(msg)
	local id,_ = GetChannelName("Trade - City")
	SendChatMessage(msg, "CHANNEL", nil, id)
	--SendChatMessage(msg, "WHISPER", nil, "AddonTest")
end

