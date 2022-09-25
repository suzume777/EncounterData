-- code from qqyt

function PrintAllEncounterSections(encounterID, difficultyID)
	EJ_SetDifficulty(difficultyID)
	print(difficultyID)
	local stack, encounter, _, _, curSectionID = {}, EJ_GetEncounterInfo(encounterID)
	EncounterData = EncounterData .. "NEW_LINE" .. encounter

	repeat
		local info = C_EncounterJournal.GetSectionInfo(curSectionID)
		if not info.filteredByDifficulty then
			local icon = ""
			if info.abilityIcon and info.abilityIcon ~= "" then
				icon = " (" .. info.abilityIcon .. ")"
			end
			EncounterData = EncounterData .. "NEW_LINE" .. (("	"):rep(info.headerType)..info.title..icon.. ": "..info.description)
		end
		
		table.insert(stack, info.siblingSectionID)
		
		if not info.filteredByDifficulty then
			table.insert(stack, info.firstChildSectionID)
		end
		
		curSectionID = table.remove(stack)
	until not curSectionID
end

local function exportDungeonData(difficultyId)
	for i = 1, 20 do
		title, desc, bossId, sectionId, _ = EJ_GetEncounterInfoByIndex(i)
		
		if (bossId == nil) then
			return
		end
		
		EncounterData = EncounterData .. "NEW_LINE"
		PrintAllEncounterSections(bossId, difficultyId)
	 end
end

SlashCmdList["EXEJ"] = function(msg)
	--[[EncounterData = ""
	EncounterData = EncounterData .. "英雄难度"
	exportDungeonData(2)]]--
	EncounterData = ""
	EncounterData = EncounterData .. "普通难度"
	exportDungeonData(14)
	EncounterData = EncounterData .. "NEW_LINENEW_LINE RAID英雄难度"
	exportDungeonData(15)
	EncounterData = EncounterData .. "NEW_LINENEW_LINE RAID史诗难度"
	exportDungeonData(16)
	UIParentLoadAddOn("Blizzard_DebugTools")
	FrameStackTooltip_Toggle()
end
SLASH_EXEJ1 = "/exej"
--[[
在插件的SlashCommand里加入:

		EncounterData = ""
		EncounterData = EncounterData .. "普通难度"
		exportDungeonData(14)
		EncounterData = EncounterData .. "NEW_LINENEW_LINE英雄难度"
		exportDungeonData(15)
		EncounterData = EncounterData .. "NEW_LINENEW_LINE史诗难度"
		exportDungeonData(16)


使用方法：打开手册对应副本后触发你的SlashCommand，reload后在SavdVariables里面找]]--