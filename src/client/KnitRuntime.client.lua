local Knit = require(game.ReplicatedStorage.Packages.Knit);

Knit.AddControllersDeep(script.Parent.Controllers);

Knit.Start():andThen(function()
    print('Knit(client) started');
end):catch(warn);