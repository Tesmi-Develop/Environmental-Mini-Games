local DataHandler = {}
local DataStoreService = game:GetService("DataStoreService")
local PlayerDataStore = DataStoreService:GetDataStore("PlayerData")

DataHandler.SaveData = function(Player,Data)
    local PlayerData = Data
    local success, error = pcall(function()
        PlayerDataStore:SetAsync(Player.UserId,PlayerData)
    end)

    if success then
    else
        warn("Data failed to save.")
        print(error)
    end
end

DataHandler.LoadData = function(Player,StatsTable)
    local DataFinal = nil
    local success, error = pcall(function()
        DataFinal = PlayerDataStore:GetAsync(Player.UserId)
    end)

    if success and DataFinal ~= nil then
        for Index, Stats in pairs(StatsTable) do
            Stats.Value = DataFinal[Stats.Name]
        end
    else
        warn("Data failed to load")
    end
end

return DataHandler