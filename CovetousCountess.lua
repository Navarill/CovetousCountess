local VALID_ZONES = {
	[753] = true, -- Thieves Den
	[821] = true, -- Hew's Bane
}

local TIP_BOARD_NAMES = {
	["Tip Board"]          = true,
	["Brett für Aufträge"] = true,
	["Tablón de informes"] = true,
	["Tableau des tuyaux"] = true,
	["ジョブボード"]         = true,
	["Доска объявлений"]   = true,
	["提示板"]              = true,
}

-- String ID 3952276-6749
local QUEST_SUBSTRINGS = {
	de = "Hochgeschätzte Diebe",
	en = "Esteemed thieves",
	es = "Estimados ladrones",
	fr = "Voleurs bien-aimés",
	jp = "立派な盗賊達",
	ru = "Досточтимые воры",
	zh = "诸位好汉",
}

local function IsCountessQuest(offerText, expectedSub)
	if offerText == "" then return false end
	return string.find(string.sub(offerText, 1, 40), expectedSub, 1, true) ~= nil
end

local function HookChatter(interaction)
	ZO_PreHook(interaction, "PopulateChatterOption", function(self, index, fun, txt, chatterType, ...)
		local expectedSub = QUEST_SUBSTRINGS[GetCVar("language.2")]
		if not expectedSub then return false end

		if not VALID_ZONES[GetZoneId(GetUnitZoneIndex("player"))] then return false end

		local _, rawName = GetGameCameraInteractableActionInfo()
		if not TIP_BOARD_NAMES[zo_strformat("<<1>>", rawName)] then return false end

		if IsCountessQuest(GetOfferedQuestInfo(), expectedSub) then return false end

		if chatterType ~= CHATTER_GOODBYE then
			return true
		end

		if index ~= 1 then
			self:PopulateChatterOption(1, fun, txt, chatterType, ...)
			return true
		end

		return false
	end)
end

HookChatter(GAMEPAD_INTERACTION)
HookChatter(INTERACTION)