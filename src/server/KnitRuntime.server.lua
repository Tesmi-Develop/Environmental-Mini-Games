local Knit = require(game.ReplicatedStorage.Packages.Knit);
local ComponentsHandler = require(script.Parent.ComponentsHandler);
local Components = script.Parent.Components;

ComponentsHandler.Init()
Knit.AddServicesDeep(script.Parent.Services);

Knit.Start():andThen(function()

    for i, component in Components:GetDescendants() do
        if not component:IsA('ModuleScript') then return; end
        require(component);
    end

    print('Knit started');
end):catch(warn);