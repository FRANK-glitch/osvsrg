game.Players.CharacterAutoLoads = false

game.Players.PlayerAdded:Connect(function(player)
        player:LoadCharacter()
        local playerBody = player.Character
        local d = playerBody:GetChildren()
        for i=1, #d do 
                if (d[i]:IsA("Hat") or d[i]:IsA("Accessory")) then 
                        d[i]:Destroy()
                end
        end
end)