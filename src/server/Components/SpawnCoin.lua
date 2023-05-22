local SpawnCoin = {}

SpawnCoin.CreateCoinAt = function(Position : CFrame, ExistingCoins)
    local Coin = game.ReplicatedStorage.Items:WaitForChild("Coin"):Clone()
    Coin.Parent = ExistingCoins
    Coin.CFrame = Position * CFrame.new(0,5,0)

    Coin.Touched:Connect(function(Hit)
        if Hit.Parent:IsA("Model") then
            local Character = Hit.Parent
            if game.Players:FindFirstChild(Character.Name) then
                local Player = game.Players:FindFirstChild(Character.Name)
                local leaderstats = Player:WaitForChild("leaderstats")
                local Money = leaderstats:WaitForChild("Money")
                Coin:Destroy()
                Money.Value += 1
            end
        end
    end)

end

return SpawnCoin