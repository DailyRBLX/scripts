local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Backpack = Player.Backpack
local Sword = nil;
local Handle = nil;
local settings = {
    aura = false,
    size = 20,
    showrange = false,
}

function death(char)
    local Humanoid = char:WaitForChild("Humanoid",10)
    if Humanoid then
        Humanoid.Died:Connect(function()
            Sword:Destroy();
            Sword = nil;
            Handle = nil
        end)
    end

    
end

function findnearest()
    local person = nil
    local nearestdistance = math.huge
    for i,v in pairs(Players:GetPlayers()) do
        if v == Player then continue end
        if (v and v.Character and Player.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0) then
            local hrp = v.Character:FindFirstChild("HumanoidRootPart")
            local mine = Player.Character:FindFirstChild("HumanoidRootPart")
            local mag = (hrp.Position - mine.Position).Magnitude
            if (mag < nearestdistance) then
                nearestdistance = mag
                person = v
            end
        end
    end
    return person
end

RunService.Heartbeat:Connect(function()
    if (Player and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid").Health > 0) then
        local PCharacter = Player.Character
        if (Sword == nil) then
            if (PCharacter:FindFirstChildOfClass("Tool") and (Sword == nil or Sword ~= PCharacter:FindFirstChildOfClass("Tool"))) then
                Sword = PCharacter:FindFirstChildOfClass("Tool")
            end
            if (Backpack:FindFirstChildOfClass("Tool") and (Sword == nil or Sword ~= Backpack:FindFirstChildOfClass("Tool"))) then
                Sword = Backpack:FindFirstChildOfClass("Tool")
            end
        end
        if (Handle == nil) then
            if (Sword) then
                Handle = Sword:FindFirstChild("Handle")
            end
        end
        
    
        if (settings.aura == true) then
            local Humanoid = PCharacter:FindFirstChildOfClass("Humanoid")
            local Root = PCharacter:FindFirstChild("HumanoidRootPart")


            if (Sword) then
                if (Sword.Parent ~= PCharacter) then
                    Humanoid:UnequipTools()
                    Humanoid:EquipTool(Sword)
                end

                local player = findnearest()
                if (player) then
                    local Character = player.Character
                    if (Character and Character:FindFirstChildOfClass("Humanoid") and Character:FindFirstChild("HumanoidRootPart") and (Handle.Position - Character:FindFirstChild("HumanoidRootPart").Position).Magnitude <= settings.size) then
                        local Enemy_Root = Character:FindFirstChild("HumanoidRootPart")
                        local root_unit = (Enemy_Root.Position - Root.Position).unit
                        local facing = Root.CFrame.LookVector
                        local angle = math.acos(facing:Dot(root_unit))
                        local Enemy_Humanoid = Character:FindFirstChildOfClass("Humanoid")

                        if Enemy_Humanoid.Health > 0 then
                            if settings.legit == true then
                                if angle > 1.25 then
                                    return
                                end
                            end
                            Sword:Activate()
                            for i,v in pairs(Character:GetChildren()) do
                                if v:IsA("BasePart") then
                                    firetouchinterest(Handle, v, 0)
                                    firetouchinterest(Handle, v, 1)
                                end
                            end
                        end
                    end
                end
            end
        end
        if Handle and Sword then
            if settings.showrange then
                if not Handle:FindFirstChild("RangeBox") then
                    local p = Instance.new("Part")
                    local weld = Instance.new("WeldConstraint")
                    p.Name = "RangeBox"
                    p.Shape = "Ball"
                    p.Size = Vector3.new(settings.size,settings.size,settings.size)
                    p.Transparency = 0.5
                    p.Color = Color3.fromRGB(52, 116, 255)
                    p.Anchored = false
                    p.CanCollide = false
                    p.Massless = true
                    p.TopSurface = "Smooth"
                    p.BottomSurface = "Smooth"
                    p.Parent = Handle
                    p.CFrame = Handle.CFrame
                    weld.Part0 = p
                    weld.Part1 = Handle
                    weld.Parent = p
                elseif Handle:FindFirstChild("RangeBox") then
                    local rangebox = Handle:FindFirstChild("RangeBox")
                    rangebox.Size = Vector3.new(settings.size,settings.size,settings.size)
                    if not rangebox:FindFirstChildOfClass("WeldConstraint") then
                        local weld = rangebox:FindFirstChildOfClass("WeldConstraint")
                        weld.Part0 = rangebox
                        weld.Part1 = Handle
                        weld.Parent = p
                    end
                end
            else
                if Handle and Handle:FindFirstChild("RangeBox") then
                    Handle:FindFirstChild("RangeBox"):Destroy()
                end
            end
        end
    end
end)


Player.CharacterAdded:Connect(function()
    local character = Player.Character or Player.CharacterAdded:Wait()
    death(character)
end)

if Player.Character then
    local character = Player.Character or Player.CharacterAdded:Wait()
    death(character)
end

------------------------------------- UI


local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("ui") then
    CoreGui:FindFirstChild("ui"):Destroy()
end


local ui = Instance.new("ScreenGui")
local UIMain = Instance.new("Frame")
local Frame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

ui.Name = "ui"
ui.Parent = CoreGui
ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

UIMain.Name = "UIMain"
UIMain.Parent = ui
UIMain.AnchorPoint = Vector2.new(0.5, 0.5)
UIMain.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
UIMain.BackgroundTransparency = 0.300
UIMain.BorderSizePixel = 0
UIMain.Position = UDim2.new(0.939453645, 0, 0.5, 0)
UIMain.Size = UDim2.new(0.12, 0, 0.349999994, 0)

Frame.Parent = UIMain
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = 1.000
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new(0, 2, 0, 10)

UIListLayout.Parent = UIMain
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

function createSettingBox(name,callback,default,texttype,min,max)
	local text = default
	local Setting = Instance.new("Frame")
	local Label = Instance.new("TextLabel")
	local Box = Instance.new("TextBox")


	Setting.Name = "Setting"
	Setting.Parent = UIMain
	Setting.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Setting.BackgroundTransparency = 0.800
	Setting.BorderSizePixel = 0
	Setting.Position = UDim2.new(0.0636983067, 0, 0.0351000354, 0)
	Setting.Size = UDim2.new(0.85, 0, 0.162249923, 0)

	Label.Name = "Label"
	Label.Parent = Setting
	Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label.BackgroundTransparency = 1.000
	Label.BorderSizePixel = 0
	Label.Position = UDim2.new(0, 0, 0.0500000007, 0)
	Label.Size = UDim2.new(1, 0, 0.400000006, 0)
	Label.Font = Enum.Font.SourceSans
	Label.Text = string.format("  %s (%s)",name,text)
	Label.TextColor3 = Color3.fromRGB(200,200,200)
	Label.TextScaled = true
	Label.TextSize = 14.000
	Label.TextStrokeTransparency = 0.700
	Label.TextWrapped = true
	Label.TextXAlignment = Enum.TextXAlignment.Left

	Box.Name = "Box"
	Box.Parent = Setting
	Box.AnchorPoint = Vector2.new(0.5, 0)
	Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Box.BorderSizePixel = 0
	Box.Position = UDim2.new(0.5, 0, 0.5, 0)
	Box.Size = UDim2.new(0.925000012, 0, 0.445199907, 0)
	Box.Font = Enum.Font.SourceSans
	Box.PlaceholderColor3 = Color3.fromRGB(45, 45, 45)
	Box.PlaceholderText = "TextBox"
	Box.Text = ""
	Box.TextColor3 = Color3.fromRGB(0, 0, 0)
	Box.TextScaled = true
	Box.TextSize = 14.000
	Box.TextWrapped = true

	Box.FocusLost:Connect(function()
        if min then
            if tonumber(Box.Text) < min then
                Box.Text = min
            end
        end
        if max then
            if tonumber(Box.Text) > max then
                Box.Text = max
            end
        end
        
        text = Box.Text
        Label.Text = string.format("  %s (%s)",name,text)
        callback(Box.Text)
	end)

    if default then
        Label.Text = string.format("  %s (%s)",name,default)
        callback(default)
    end
end

function createSettingButton(name,callback)
	local status = false
	local Setting = Instance.new("Frame")
	local Label = Instance.new("TextLabel")
	local Button = Instance.new("TextButton")


	Setting.Name = "Setting"
	Setting.Parent = UIMain
	Setting.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Setting.BackgroundTransparency = 0.800
	Setting.BorderSizePixel = 0
	Setting.Position = UDim2.new(0.0636983067, 0, 0.0351000354, 0)
	Setting.Size = UDim2.new(0.85, 0, 0.162249923, 0)

	Label.Name = "Label"
	Label.Parent = Setting
	Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label.BackgroundTransparency = 1.000
	Label.BorderSizePixel = 0
	Label.Position = UDim2.new(0, 0, 0.0500000007, 0)
	Label.Size = UDim2.new(1, 0, 0.400000006, 0)
	Label.Font = Enum.Font.SourceSans
	Label.Text = string.format("  %s (%s)",name,(status and "ON" or "OFF"))
	Label.TextColor3 = (status and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
	Label.TextScaled = true
	Label.TextSize = 14.000
	Label.TextStrokeTransparency = 0.700
	Label.TextWrapped = true
	Label.TextXAlignment = Enum.TextXAlignment.Left

	Button.Name = "Button"
	Button.Parent = Setting
	Button.AnchorPoint = Vector2.new(0.5, 0)
	Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Button.BorderSizePixel = 0
	Button.Position = UDim2.new(0.5, 0, 0.5, 0)
	Button.Size = UDim2.new(0.925000012, 0, 0.445199907, 0)
	Button.Font = Enum.Font.SourceSans
	Button.Text = "Toggle"
	Button.TextColor3 = Color3.fromRGB(0, 0, 0)
	Button.TextScaled = true
	Button.TextSize = 14.000
	Button.TextWrapped = true

	Button.MouseButton1Click:Connect(function()
		status = not status
		Label.Text = string.format("  %s (%s)",name,(status and "ON" or "OFF"))
		Label.TextColor3 = (status and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
		callback(status)
	end)

end


createSettingButton("Kill-Aura",function(v)
    settings.aura = v
end)

createSettingButton("Legit",function(v)
    settings.legit = v
end)

createSettingBox("Range",function(v)
    if tonumber(v) ~= nil then
        settings.size = tonumber(v)
    end
end,20,"number",1,100)

createSettingButton("Show Range",function(v)
    settings.showrange = v
end)

UIS.InputBegan:Connect(function(input,no)
    if no then return end
    if input.KeyCode == Enum.KeyCode.RightAlt then
        UIMain.Visible = not UIMain.Visible
    end
end)
