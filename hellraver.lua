getgenv().size = Vector3.new(50,50,50)
local Players = game:GetService("Players")
function destroyremlol()
    for i,v in pairs(game:GetService("ReplicatedStorage").ServerEvents:GetChildren()) do
        if tonumber(v.Name) then
            v:Destroy()
        end
    end
end
destroyremlol()

function charadd(char)
    pcall(function()
        local head = char:WaitForChild("Head",10)
        while true do
            if not head then
                break
            end
            head.Massless = true
            head.CanCollide = false
            head.Anchored = false
            head.Size = getgenv().size
            head.Transparency = 0.65
            game:GetService("RunService").RenderStepped:Wait()
        end
    end)
end

workspace.ChildAdded:Connect(function(obj)
    wait(1.5)
    if obj:FindFirstChild("Humanoid") then
        if obj.Name ~= Players.LocalPlayer.Name then
            charadd(obj)
        end
    end
end)

for i,v in pairs(workspace:GetChildren()) do
    if v:FindFirstChild("Humanoid") then
        if v.Name ~= Players.LocalPlayer.Name then
            charadd(v)
        end
    end
end
