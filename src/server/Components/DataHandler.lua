local DataHandler = {}
DataHandler.Profiles = {}
DataHandler.DataTempo = {}

local ProfileService = require(game.ReplicatedStorage.Packages.ProfileService)
local ProfileStore
ProfileStore = ProfileService.GetProfileStore("PlayerDataStore")

DataHandler.SetDataTempo = function(Data)
end

return DataHandler