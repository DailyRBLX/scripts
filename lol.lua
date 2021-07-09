--gui

local Player = game.Players.LocalPlayer
local Character = Player.Character
local StarterScript = game.StarterPlayer.StarterCharacterScripts:WaitForChild("Anticheat")
function findscriptconnection(connection, scr)
    local connections = getconnections(connection)
    local scrconnection = nil
    for _, tbl in next, connections do
        local env = getfenv(tbl.Function)
        for _, val in next, env do
            if val == scr then
                scrconnection = tbl
                break
            end
        end
    end
    return scrconnection
end

if not shared.bypassed then
    local gmt = getrawmetatable(game)
    local oldnamecall = gmt.__namecall
    local oldindex = gmt.__index
    local oldnewindex = gmt.__newindex
    setreadonly(gmt, false)
    local s = Instance.new("Hint", workspace)
    s.Text = "Bypassing Anticheat.."
    local t = findscriptconnection(game.Players.LocalPlayer.CharacterAdded, game.Players.LocalPlayer.PlayerScripts.Client)
    t:Disable()
    Player.CharacterAdded:Connect(function()
        local char = Player.Character or Player.CharacterAdded:Wait()

        if char:FindFirstChild("Anticheat") then
            local a = char:FindFirstChild("Anticheat")
            a:Destroy()
        end
        char.ChildAdded:Connect(function(obj)
            if obj.Name == "Anticheat" then
                obj:Destroy()
            end
        end)
    end)

    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" then
            if tostring(self):lower() == "1event" then
                return wait(9e9)
            end
        elseif method == "Kick" and self == Player then
            return wait(9e9)
        end
        return oldnamecall(self, ...)
    end)
    gmt.__index = newcclosure(function(self, key, value, ...)
        if key == "Disabled" and self.Name == "Anticheat" then return false end
        return oldindex(self, key, value, ...)
    end)
    gmt.__newindex = newcclosure(function(self, key, value,...)
        if key == "Disabled" and self.Name == "Anticheat" then return wait(9e9) end
        return oldnewindex(self, key, value, ...)
    end)


    s.Text = "Bypassed!"
    shared.bypassed = true
    game.Debris:AddItem(s, 5)
end
--/ Services
function serv(n)
    return game:service(n)
end

local Players = serv("Players")
local CoreGui = serv("CoreGui")
local ReplicatedStorage = serv("ReplicatedStorage")
local ReplicatedFirst = serv("ReplicatedFirst")
local RunService = serv("RunService")
local Lighting = serv("Lighting")

--/ Variables
local Player = Players.LocalPlayer
local CustomFunctions = {}
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DailyRBLX/sine-hub/main/ui.lua",true))()

local Main = Library:CreateTabHolder("SineHub")

function tab(tabname,corner)
    return Main:CreateTab(tabname,corner)
end

function button(tab,name,callback)
    return tab:Button(name,callback)
end

function toggle(tab,name,callback,default)
    return tab:Toggle(name,callback,default)
end

function slider(tab,name,callback,min,max,default)
    return tab:Slider(name,min,max,default,callback)
end

function dropdown(tab,name,optionvalues,callback)
    return tab:Dropdown(name,optionvalues,callback)
end

function colorpicker(tab,name,default,callback,info)
    return tab.ColorPicker({
        Text = name,
        Default = default,
        Callback = function(Value)
            callback(Value.R * 255, Value.G * 255, Value.B * 255)
        end,
        Menu = (info ~= nil and {
            Information = function(self)
                MainHubFrame.Banner({
                    Text = tostring(info)
                })
            end
        } or {})
    })
end

local Functions = {
    ["getreg"] = debug.getregistry,
    ["getupvalues"] = debug.getupvalues,
    ["getupvalue"] = debug.getupvalue,
    ["setupvalue"] = debug.setupvalue,
}

function CustomFunctions.getsenv(scr)
    local env = nil;
    for i,v in pairs(Functions.getreg()) do
        if (type(v) == "function" and getfenv(v).script and getfenv(v).script == scr) then
            env = getfenv(v);
            break
        end
    end
    return env
end

function getcharacter()
    return Player.Character
end

function changehumanoidproperty(property,value)
    local char = getcharacter()
    if not char then return end
    local humanoid = char:WaitForChild("Humanoid",60)
    humanoid[property] = value
end

function gethumanoidproperty(property)
    local char = getcharacter()
    if not char then return end
    local humanoid = char:WaitForChild("Humanoid",60)
    return humanoid[property]
end


function gethumanoid()
    local char = getcharacter()
    if not char then return end
    local humanoid = char:WaitForChild("Humanoid",60)
    return humanoid
end

function banner(text,options)
    MainHubFrame.Banner({
        Text = tostring(text),
        Options = (options ~= nil and options or nil)
    })
end

--/ start

if workspace.Structure:FindFirstChild("KillPart") then
    workspace.Structure:FindFirstChild("KillPart"):Destroy()
end


local bp = workspace.Structure.Baseplate
local client = Player.PlayerScripts.Client
local env = CustomFunctions.getsenv(client)
local deatheffecttable = {}
local deatheffects = {}
for i,v in pairs(getgc(true)) do
    if type(v) == "table" then
        if rawget(v,"Inferno") and type(rawget(v,"Inferno")) == "function" then
            deatheffecttable = v
            break
        end
    end
end
if deatheffecttable ~= {} then
    for i,v in pairs(deatheffecttable) do
        deatheffects[tostring(i)] = tostring(i)
    end
end

local ogdown = Vector3.new(0,-8.3115,0)
local down = Vector3.new(0,-8.425,0)
local up = Vector3.new(0,-5.25031,0)

local gmt = getrawmetatable(game)
local oldindex = gmt.__index
setreadonly(gmt,false)
local normalreach = Vector3.new(1,0.800000012,4)
local deatheffectchosen = "None"
local spoofdeatheffect = false
local settings = {damagemethod = "Find Nearest",lowerbaseplate = false,bigbaseplate = false, nodeatheffect = false,antiaimangle = "Circle",antiaim = false,timeesp = false,reach = Vector3.new(1,0.800000012,4),godmode = false,keepreach = false,keepspeed = false,keepjump = false,keepoutline = false,changereach = false,deatheffect = "None",usespoofeddeatheffect = false,autoclickerstatus = false,lockonrange = 35,tp = false}
local autoclickers = {}

local currentspeed = 16
local currentjumppower = 50
function speed(v)
    currentspeed = v
    changehumanoidproperty("WalkSpeed",v)
end

function jump(v)
    currentjumppower = v
    changehumanoidproperty("JumpPower",v)
end



function changereach()
    local character = Player.Character
    if character then
        local tool;
        if character:FindFirstChildOfClass("Tool") then
            tool = character:FindFirstChildOfClass("Tool")
            local handle = tool.Handle
            handle.Size = settings.reach
        end
        
        if not tool then
            if #Player.Backpack:GetChildren() > 1 then
                for i,v in pairs(Player.Backpack:GetChildren()) do
                    local handle = v.Handle
                    handle.Size = settings.reach
                end
            else
                local tool =  Player.Backpack:FindFirstChildOfClass("Tool")
                if not tool then return end
                local handle = tool.Handle
                handle.Size = settings.reach
            end
        else
            local handle = tool.Handle

            handle.Size = settings.reach
        end
    end
end

function reach(v)
    settings.reach = (v == 1 and normalreach or Vector3.new(v,v,v))
    if settings.changereach then
        changereach()
    end
end

function createtimeesp(character,time)
    if character and not character:FindFirstChild("Head") then
        character:WaitForChild("Head")
        wait(0.5)
    end
    if character and character:FindFirstChild("Head") and character:FindFirstChild("Humanoid") and not character:FindFirstChild("Head"):FindFirstChild("TimeESP") then
        local connection
        local humanoid = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")
        local billgui = Instance.new("BillboardGui")
        billgui.Name = "TimeESP"
        billgui.Parent = head
        billgui.Size = UDim2.new(0,150,0,35)
        billgui.StudsOffset = Vector3.new(0,4,0)
        billgui.MaxDistance = math.huge
        local textlabel = Instance.new("TextLabel")
        textlabel.Parent = billgui
        textlabel.Size = UDim2.new(1,0,1,0)
        textlabel.BackgroundTransparency = 1
        textlabel.TextScaled = true
        textlabel.Font = Enum.Font.RobotoMono
        textlabel.TextColor3 = Color3.new(1,1,1)
        textlabel.Text = tostring(time.Value).." Time"
        billgui.Adornee = head
        
        humanoid.Died:Connect(function()
            if connection and billgui then
                billgui:Destroy()
                connection:Disconnect()
            end
        end)
        
        connection = time:GetPropertyChangedSignal("Value"):Connect(function()
            if not billgui then
               connection:Disconnect() 
            end
            textlabel.Text = tostring(time.Value).." Time"
        end)
        
    end
end

function removetimeesp(character)
    if character and character:FindFirstChild("Head") then
        local head = character:FindFirstChild("Head")
        if head:FindFirstChild("TimeESP") then
            head:FindFirstChild("TimeESP"):Destroy()
        end
    end
end

local cam = workspace.CurrentCamera
function characterangle(angle) -- Pasted from RobloxForums
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        local camcf = cam.CFrame
        Player.Character.HumanoidRootPart.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(camcf.lookVector.X, 0, camcf.lookVector.Z)) * CFrame.Angles(0, math.rad(angle), 0)
	end
end


function swordoutline(v)
    local character = Player.Character
    if v == true then
        if character then
            if character:FindFirstChildOfClass("Tool") then
                local tool = character:FindFirstChildOfClass("Tool")
                if not tool.Handle:FindFirstChildOfClass("SelectionBox") then
                    local e = Instance.new("SelectionBox",tool.Handle)
                    e.Visible = true
                    e.Adornee = tool.Handle
                end
            end
        end
        for i,v in pairs(Player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                local e = Instance.new("SelectionBox",v.Handle)
                e.Visible = true
                e.Adornee = v.Handle
            end
        end
    elseif v == false then
        if character then
            if character:FindFirstChildOfClass("Tool") then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool.Handle:FindFirstChildOfClass("SelectionBox") then
                    tool.Handle:FindFirstChildOfClass("SelectionBox"):Destroy()
                end
            end
        end
        for i,v in pairs(Player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                if v.Handle:FindFirstChildOfClass("SelectionBox") then
                    v.Handle:FindFirstChildOfClass("SelectionBox"):Destroy()
                end
            end
        end
    end
end

function timeesp(v)
    settings.timeesp = v
    if settings.timeesp == false then
        for i,v in pairs(Players:GetPlayers()) do
            removetimeesp(v.Character)
        end
    elseif settings.timeesp == true then
        for i,v in pairs(Players:GetPlayers()) do
            if v ~= Player then
                createtimeesp(v.Character,v.leaderstats.TimeAlive)
            end
        end
    end
end

function g(tool)
    local tbl = {breaking = false}
    autoclickers[tool.Name] = tbl
    local newtbl = autoclickers[tool.Name]

    coroutine.resume(coroutine.create(function()
        while true do
            wait(0.05)
            if not tool or tool.Parent == nil then break end
            if tool.Parent ~= Player.Character then break end
            if tool.Parent == Player.Backpack then break end
            if newtbl.breaking == true then break end
            tool:Activate()

        end
    end))
end
function r(tool)
    if autoclickers[tool.Name] and autoclickers[tool.Name].breaking ~= true then
        local a = autoclickers[tool.Name]
        a.breaking = true
    end
end

function autoclicker(v)
    settings.autoclickerstatus = v
    if settings.autoclickerstatus == false then
        if Player.Character then
            for i,v in pairs(Player.Character:GetChildren()) do
                if v:IsA("Tool") then
                    r(v)
                end
            end
        end
        for i,v in pairs(Player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                r(v)
            end
        end
    end
    if settings.autoclickerstatus == true then
        if Player.Character then
            for i,v in pairs(Player.Character:GetChildren()) do
                if v:IsA("Tool") then
                    g(v)
                end
            end
        end
        for i,v in pairs(Player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                g(v)
            end
        end
    end
end

function changesetting(setting,value)
    settings[setting] = value
end

local SettingsToChange = {
    ["Ambient"] = true,
    ["OutdoorAmbient"] = true,
    ["ColorShift_Bottom"] = true,
    ["ColorShift_Top"] = true,
    
}
local OldSettings = {}

for i,v in pairs(SettingsToChange) do
    OldSettings[i] = game.Lighting[i]
end

function lightingc(r,g,b)
    for i,v in pairs(SettingsToChange) do
       game.Lighting[i] = Color3.fromRGB(r, g, b)
    end
end

function antiaim(v)
    changesetting("antiaim",v)
    if v == true then
        Player.Character.Humanoid.AutoRotate = false
    else
        Player.Character.Humanoid.AutoRotate = true
    end
end

function bptp(v)
    changesetting("lowerbaseplate",v)
    for i,v in pairs(workspace.Structure:GetChildren()) do
        if v.Name ~= "Baseplate" and not v.Name:lower():find("leaderboard") and v.Name ~= "SpawnLocation" then
            v.CanCollide = v
        end
    end
    if v then
        bp.Position = down
    else
        bp.Position = up
    end
end

local crouchanim = nil;

function crouch(a)
    if a == true then
        if crouchanim == nil then
            local Anim = Instance.new("Animation")
            Anim.AnimationId = "rbxassetid://282574440"
            crouchanim = Player.Character.Humanoid:LoadAnimation(Anim)
            crouchanim.Looped = true
            crouchanim:Play()
        else
            crouchanim:Play()
        end
    else
        crouchanim:Stop()
    end
end


function onrespawn()
    local hum = gethumanoid()
    crouchanim = nil;
    if settings.keepspeed then
        changehumanoidproperty("WalkSpeed",currentspeed)
    end
    if settings.keepjump then
        changehumanoidproperty("JumpPower",currentjumppower)
    end
    if settings.keepreach then
        changereach()
    end
    if settings.keepoutline then
        swordoutline(true)
    end

    if hum then
        hum.ChildAdded:Connect(function(obj)
            if obj.Name == "deatheffect" and settings.nodeatheffect then
                obj:Destroy()
            end
        end)
    end
    

end

function turncharacter(val)
    for i,v in pairs(Player.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            if val then
                v.Material = Enum.Material.ForceField
            else
                v.Material = Enum.Material.Plastic
            end
        end
    end
end

function turnswords(val)
    for i,v in pairs(Player.Character:GetChildren()) do
        if v:IsA("Tool") then
            if val then
                v.Handle.Material = Enum.Material.ForceField
            else
                v.Handle.Material = Enum.Material.Plastic
            end
        end
    end
    for i,v in pairs(Player.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            if val then
                v.Handle.Material = Enum.Material.ForceField
            else
                v.Handle.Material = Enum.Material.Plastic
            end
        end
    end
end

local tab_Player = tab("Player")
local tab_Sword = tab("Sword")
local tab_Visual = tab("Visual")
local tab_Settings = tab("Settings")
-- slider(tab,name,callback,min,max,default,info)
-- toggle(tab,name,callback,default,info)
-- dropdown(tab,name,callback,optionvalues,info)


--/ Player
do
    toggle(tab_Player,"Transparent Character", function(v) turncharacter(v) end,false)
    toggle(tab_Player,"Transparent Sword", function(v) turnswords(v) end,false)


    slider(tab_Player,"WalkSpeed",function(v) speed(v) end,16,55,16)
    --slider(tab_Player,"JumpPower",function(v) jump(v) end,50,100,50)

    toggle(tab_Player,"Change Killeffect", function(v) changesetting("usespoofeddeatheffect",v) end,false)

    toggle(tab_Player,"Spin/Anti Aim",function(v) antiaim(v) end,false)
   	dropdown(tab_Player,"Angles",{"Circle","Backwards","Left","Right"},function(Value) changesetting("antiaimangle",Value) end)

    toggle(tab_Player, "No Deatheffect", function(v) changesetting("nodeatheffect",v) end,false)
    toggle(tab_Player, "Lower Baseplate", function(v) bptp(v) end,false)

    toggle(tab_Player, "Big Baseplate", function(v) changesetting("bigbaseplate",v) end,false)

    toggle(tab_Player,"FE Crouch/Hide", function(v) crouch(v) end, false)
end

--/ Sword
do  
    toggle(tab_Sword,"Sword Outline",function(v) swordoutline(v) end,false)

    toggle(tab_Sword,"Killaura", function(v) changesetting("lockon",v) end,false)
    slider(tab_Sword,"Killaura distance",function(v) changesetting("lockonrange",v) end,10,100,15)
    toggle(tab_Sword,"Sword TP", function(v) changesetting("tp",v) end,false)
    dropdown(tab_Sword,"Attack Method",{"Find Nearest","Everyone Near"},function(Value) changesetting("damagemethod",Value) end)

    toggle(tab_Sword,"Sword AutoClicker", function(v) autoclicker(v) end,false)

    toggle(tab_Sword,"Change Reach",function(v) changesetting("changereach",v) end,false)
    slider(tab_Sword,"Reach",function(v) reach(v) end,1,15,1)

end

--/ Visual
--function button(tab,name,callback,info)
--function colorpicker(tab,name,default,callback,info)
do
    toggle(tab_Visual, "Time ESP", function(v) timeesp(v) end,false)
    button(tab_Visual,"Reset Lighting",function(v)
        for i,v in pairs(SettingsToChange) do
            game.Lighting[i] = OldSettings[i]
        end
    end)
end

--/ Settings
do
    dropdown(tab_Settings,"Death Effects",{"Hallow's Edge","Night Lord","Void Sword","Gingerbread","Snow Sword","Ice Sword","Lightning","CandyCane","Ghostwalker","Gladius","Radiance","Darkheart","Inferno"},function(Value) changesetting("deatheffect",Value) end)

    toggle(tab_Settings,"Keep WalkSpeed",function(v) changesetting("keepspeed",v) end,false)
    toggle(tab_Settings,"Keep JumpPower",function(v) changesetting("keepjump",v) end,false)
    toggle(tab_Settings,"Keep Reach",function(v) changesetting("keepreach",v) end,false)
    toggle(tab_Settings,"Keep Sword Outline",function(v) changesetting("keepoutline",v) end,false)
end

--/ Character

Player.CharacterAdded:Connect(function()
    Player.Character:WaitForChild("Humanoid",60)
    wait(1.5)
    onrespawn()
end)

--/ Players
local espconnections = {}
spawn(function()
    for i,v in pairs(Players:GetPlayers()) do
        if v ~= Player then
            espconnections[v.UserId] = v.CharacterAdded:Connect(function()
                if settings.timeesp then
                    v.Character:WaitForChild("Head")
                    wait(0.5)
                    createtimeesp(v.Character,v.leaderstats.TimeAlive)
                end
            end)
        end
    end
    Players.PlayerAdded:Connect(function(plr)
        espconnections[plr.UserId] = plr.CharacterAdded:Connect(function()
            if settings.timeesp then
                plr.Character:WaitForChild("Head")
                wait(0.5)
                createtimeesp(plr.Character,plr.leaderstats.TimeAlive)
            end
        end)
    end)
    Players.PlayerRemoving:Connect(function(plr)
        if espconnections[plr.UserId] then
            espconnections[plr.UserId]:Disconnect()
            espconnections[plr.UserId] = nil
        end
    end)
end)
--/ Metatables


gmt.__index = newcclosure(function(self,key)
    if tostring(self) == "deatheffect" and key == "Value" and settings.usespoofeddeatheffect == true then
        return settings.deatheffect
    end
    return oldindex(self,key)
end)



--/ Loop

function findnearest()
    local person = nil
    local nearestdistance = math.huge
    for i,v in pairs(Players:GetPlayers()) do
        if (v and v.Character and Player.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 and v ~= Player) then
            local hrp = v.Character:FindFirstChild("HumanoidRootPart")
            local mine = Player.Character:FindFirstChild("HumanoidRootPart")
            local mag = (hrp.Position - mine.Position).magnitude
            if (mag < nearestdistance) then
                nearestdistance = mag
                person = v
            end
        end
    end
    return person
end

getrenv().error = function()
    return
end

getgenv().error = function()
    return
end
local spinangle = 0;
RunService.Heartbeat:Connect(function()
    if (settings.lockon) then
        local range = settings.lockonrange
        if (Player.Character) then
            if (settings.damagemethod == "Find Nearest") then
                if (Player and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid").Health > 0) then
                    local Character = Player.Character
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    local Root = Character:FindFirstChild("HumanoidRootPart")
                    local sword = nil;
                    local handle = nil
                    if (Player.Character:FindFirstChildOfClass("Tool")) then
                        sword = Player.Character:FindFirstChildOfClass("Tool")
                    end
                    if (Player.Backpack:FindFirstChildOfClass("Tool")) and sword == nil then
                        sword = Player.Backpack:FindFirstChildOfClass("Tool")
                    end
                    if (handle == nil) then
                        if (sword) then
                            Handle = sword:FindFirstChild("Handle")
                        end
                    end
        
        
                    if (sword) then
                        if (sword.Parent ~= Character) then
                            Humanoid:UnequipTools()
                            Humanoid:EquipTool(sword)
                        end
                        local player = findnearest()
                        if (player) then
                            local Character = player.Character
                            if (Character and Character:FindFirstChildOfClass("Humanoid") and Character:FindFirstChild("HumanoidRootPart") and (Root.Position - Character:FindFirstChild("HumanoidRootPart").Position).Magnitude <= settings.size) then
                                local Enemy_Root = Character:FindFirstChild("HumanoidRootPart")
                                local Enemy_Humanoid = Character:FindFirstChildOfClass("Humanoid")
        
                                if Enemy_Humanoid.Health > 0 then
                                    sword:Activate()
                                    for i,v in pairs(Character:GetChildren()) do
                                        if v:IsA("BasePart") then
                                            firetouchinterest_f(Handle, v, 0)
                                            firetouchinterest_f(Handle, v, 1)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            elseif (settings.damagemethod == "Everyone Near") then
                for i,v in pairs(Players:GetPlayers()) do
                    if v ~= Player then
                        local hrp = v.Character.HumanoidRootPart
                        local mine = Player.Character.HumanoidRootPart
                        local hum = Player.Character.Humanoid
                        if (hrp and mine and hum) then
                            if ((hrp.Position - mine.Position).magnitude < range and (hrp.Position.X <= -23 or hrp.Position.X >= 23 or hrp.Position.Z <= -23 or hrp.Position.Z >= 23))  then
                                local sword = nil;
                                if (Player.Character:FindFirstChildOfClass("Tool")) then
                                    sword = Player.Character:FindFirstChildOfClass("Tool")
                                end
                                if (Player.Backpack:FindFirstChildOfClass("Tool")) and sword == nil then
                                    sword = Player.Backpack:FindFirstChildOfClass("Tool")
                                end


                                if (sword) then
                                    local handle = sword.Handle

                                    if (sword.Parent == Player.Backpack) then
                                        sword.Parent = Player.Character
                                    end
                                    if (settings.tp) then
                                        sword.Handle.Position = (hrp.Position + Vector3.new(math.random(),math.random(),math.random()) + Vector3.new(math.random(),math.random(),math.random()))
                                    end
                                    sword:Activate()
                                    for i,v in pairs(v.Character:GetChildren()) do
                                        if v:IsA("BasePart") then
                                            firetouchinterest_f(handle, v, 0)
                                            firetouchinterest_f(handle, v, 1)
                                        end
                                    end
                                end
                            else
                                continue
                            end
                        else
                            continue
                        end
                    end
                end
            end
        end
    end
end)
RunService.Heartbeat:Connect(function()
    if (spinangle >= 360) then
        spinangle = 10
    else
        spinangle = spinangle + 10
    end
    if (settings.antiaim) then
        if (settings.antiaimangle == "Circle") then
            characterangle(spinangle)
        elseif (settings.antiaimangle == "Backwards") then
            characterangle(180)
        elseif (settings.antiaimangle == "Left") then
            characterangle(90)
        elseif (settings.antiaimangle == "Right") then
            characterangle(-90)
        end
    end
    if (settings.bigbaseplate) then
        bp.Size = Vector3.new(2048,bp.Size.Y,2048)
    end
end)
