local Knit = require(game.ReplicatedStorage.Packages.Knit);

Knit.AddServicesDeep(script.Parent.Services);

Knit.Start():andThen(function()
    print('Knit started');
end):catch(warn);