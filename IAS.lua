local namecall

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = game:GetService("Players").LocalPlayer

local TargetCircle
local TravelPart
local TravelProximityPromt

if workspace:FindFirstChild("Biomes") and workspace:FindFirstChild("Biomes"):FindFirstChild("Otherworld Gates") then
	TargetCircle = workspace.Biomes:FindFirstChild("Otherworld Gates").OtherworldGate.Target.CenterCircle2
end
if workspace:FindFirstChild("Teleports") and workspace:FindFirstChild("Teleports"):FindFirstChild("World2Sign") then
	TravelPart = workspace.Teleports.World2Sign.Sign
	TravelProximityPromt = workspace.Teleports.World2Sign.Sign.Attachment.WorldTravel
end
local Altar
local MainRing
local Rebirth_ProximityPrompt
if workspace:FindFirstChild("Altar") then
	Altar = workspace:FindFirstChild("Altar") 
	MainRing = Altar:FindFirstChild("A Main Ring")
	Rebirth_ProximityPrompt = MainRing:FindFirstChildOfClass("Attachment"):FindFirstChildOfClass("ProximityPrompt")
end


local MoneyRemote = ReplicatedStorage:FindFirstChild("Coins"):FindFirstChild("PickUpCoin")
local BuyRemote = ReplicatedStorage:FindFirstChild("DataFunction")
local ProjectileRemote = ReplicatedStorage:FindFirstChild("Projectiles"):FindFirstChild("FireProjectile")
local Projectile = ReplicatedStorage:FindFirstChild("Projectiles"):FindFirstChild("Arrow")

local Enabled = false
local ArrowDamage = 0
local InstaKill = false
local KillAura = false

local function fire(vector,damage)
	ProjectileRemote:FireServer(Projectile,game:GetService("HttpService"):GenerateGUID(),vector,vector,vector,damage)
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local venyx = library.new("Infinite Archery Simulator", 5013109572)

local page = venyx:addPage("Main", 5012544693)
local mainsection = page:addSection("main stuff lol")

mainsection:addButton("Infinite Coins", function()
	MoneyRemote:FireServer(99e9)
end)

mainsection:addToggle("Toggle Custom Arrow Damage", nil, function(value)
	Enabled = value
end)

mainsection:addTextbox("Custom Arrow Damage", 0, function(value, focusLost)
	if focusLost then
		ArrowDamage = (tonumber(value) ~= nil and tonumber(value) or 1000)
	end
end)

mainsection:addButton("Kill Every Animal (Very Laggy)",function()
	for _,instance in ipairs(workspace:GetChildren()) do
		if instance:FindFirstChildOfClass("Humanoid") and instance:FindFirstChild("Torso") then
			fire(instance:FindFirstChild("Torso").Position,10^12)
		end
	end
end)


mainsection:addToggle("Kill Aura (Animals)", nil, function(value)
	KillAura = value
end)

mainsection:addButton("Rebirth", function()
	if game.PlaceId ~= 7003468110 then
		venyx:Notify("Rebirth", "Teleporting.. (you'll be teleported to another place, so re-execute it once ur finished teleporting and press rebirth button again)")
		wait(2)
		game:GetService("TeleportService"):Teleport(7003468110)
	else
		if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
			MoneyRemote:FireServer(10^8)
			BuyRemote:InvokeServer("buy","Heroic Cthulu Bow",1)

			Player.Character:FindFirstChild("HumanoidRootPart").CFrame = MainRing.CFrame
			wait(0.8)
			fireproximityprompt(Rebirth_ProximityPrompt)
		end
	end
end)

mainsection:addSlider("WalkSpeed", 16, 16, 100, function(value)
	if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
		Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = tonumber(value)
	end
end)


mainsection:addKeybind("UI Toggle", Enum.KeyCode.RightAlt, function()
venyx:toggle()
end, function() end)


-- load
venyx:SelectPage(venyx.pages[1], true)

RunService.Heartbeat:Connect(function()
	if KillAura == true and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
		local HumanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")
		for _,instance in ipairs(workspace:GetChildren()) do
			if instance:FindFirstChildOfClass("Humanoid") and instance:FindFirstChild("Torso") then
				local Torso = instance:FindFirstChild("Torso")
				local magnitude = (HumanoidRootPart.Position - Torso.Position).Magnitude
				if magnitude < 25 then
					fire(Torso.Position,10^12)
				end
			end
		end
	end
end)

namecall = hookmetamethod(game,"__namecall",function(...)
    local self,caller,method,args = ...,getcallingscript(),getnamecallmethod(),{...}
    table.remove(args,1)

	if tostring(self) == "FireProjectile" then
        if Enabled then
			args[6] = ArrowDamage
		end
    end

    return namecall(self,unpack(args))
end)
