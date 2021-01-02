-- VR Essentials
-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VRService = game:GetService("VRService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local newCFrame = CFrame.new()
local Camera = workspace.CurrentCamera
local leftHanded = false -- Change this to true if ur born incorrect
local devMode = false
local mainHand
if not VRService.VREnabled and not devMode then LocalPlayer:Kick("\n\n-=[VR ESSENTIALS]=-\nYou are not in VR!\nPlease open SteamVR.\n") return end
repeat wait() until LocalPlayer.Character and LocalPlayer.Character.PrimaryPart
if devMode then
    rconsoleprint("Loaded dev mode.")
    rconsolename("VR Essentials")
end
if not devMode then
    StarterGui:SetCore("VRLaserPointerMode",0)
    StarterGui:SetCore("VREnableControllerModels",false)
    StarterGui:SetCore("TopbarEnabled", false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat,false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health,false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,false)
end
-- Folder
local menuFolder = Instance.new("Folder",workspace)
menuFolder.Name = "VR Essentials"
-- Hands
local rightHand = Instance.new("Part",menuFolder)
local leftHand = Instance.new("Part",menuFolder)
rightHand.Anchored = true
rightHand.CanCollide = false
rightHand.Size = Vector3.new(0.35,0.35,0.35)
rightHand.Transparency = 0.3
rightHand.Color = Color3.new(0,0.4,0)
rightHand.Material = "SmoothPlastic"
leftHand.Anchored = true
leftHand.CanCollide = false
leftHand.Size = Vector3.new(0.35,0.35,0.35)
leftHand.Transparency = 0.3
leftHand.Color = Color3.new(0,0.4,0)
leftHand.Material = "SmoothPlastic"
mainHand = leftHanded and leftHand or rightHand 
mainHand.Color = Color3.new(0.3,1,0.3)
-- Menu Parts (this make the actual part instances)
local middleMenuPart = Instance.new("Part",menuFolder)
local rightMenuPart = Instance.new("Part",menuFolder)
local leftMenuPart = Instance.new("Part",menuFolder)
middleMenuPart.Anchored = true
middleMenuPart.CanCollide = false
middleMenuPart.Position = LocalPlayer.Character.PrimaryPart.Position+Vector3.new(0,50,0)
middleMenuPart.Size = Vector3.new(3,4,0.2)
middleMenuPart.Transparency = 0
middleMenuPart.Color = Color3.fromRGB(230,230,230)
middleMenuPart.Material = "Wood"
rightMenuPart.Anchored = true
rightMenuPart.CanCollide = false
rightMenuPart.Position = LocalPlayer.Character.PrimaryPart.Position+Vector3.new(0,0,0)
rightMenuPart.Size = Vector3.new(3,4,0.2)
rightMenuPart.Transparency = 0
rightMenuPart.Color = Color3.fromRGB(230,230,230)
rightMenuPart.Material = "Wood"
leftMenuPart.Anchored = true
leftMenuPart.CanCollide = false
leftMenuPart.Position = LocalPlayer.Character.PrimaryPart.Position+Vector3.new(0,50,0)
leftMenuPart.Size = Vector3.new(3,4,0.2)
leftMenuPart.Transparency = 0
leftMenuPart.Color = Color3.fromRGB(230,230,230)
leftMenuPart.Material = "Wood"

local pages = {
    welcomePage = {},
    firstPage = {},
    CLOVRPage = {},
    settingsPage = {},
}

function changePage(pageName,start)
    for i,v in next, pages do
        for _i,_v in next, v do
            if _v.Transparency == 1 or start then continue end
            spawn(function()
                wait(0.2)
                for i=50,100,2 do RunService.RenderStepped:Wait()
                    _v.Transparency = i/100
                end
            end)
            if _v:FindFirstChild("gui") and _v.gui:FindFirstChild("text") then
                spawn(function()
                    for i=0,100,2 do RunService.RenderStepped:Wait()
                        _v.gui.text.TextTransparency = i/100
                    end
                end)
            end
        end
    end
    wait(0.75)
    for i,v in next, pages[pageName] do
        spawn(function()
            for i=99,38,-2 do RunService.RenderStepped:Wait()
                v.Transparency = i/100
            end
        end)
        if v:FindFirstChild("gui") and v.gui:FindFirstChild("text") then
            spawn(function()
                wait(0.3)
                for i=100,0,-2 do RunService.RenderStepped:Wait()
                    v.gui.text.TextTransparency = i/100
                end
            end)
        end
    end
end

local objects = {
    buttons = {},
    textLabels = {},
}

_G.options = {
    viewportEnabled = false,
    ragdollHeadMovement = true,
    hideCharacter = false,
}
local chatnearbyonly = false
local clovrRan = false
local clovrButtonDebounce = false
local features = {
    buttons = {
        --welcomePage
        {C1 = CFrame.new(0,0,-0.15),text = "Start",size = 3,parent = middleMenuPart,flag = "start",textSize = 80,page = "welcomePage",callback = function()
            changePage("firstPage")
        end},
        --firstPage
        {C1 = CFrame.new(0,0,-0.15),text = "CLOVR",size = 3,parent = middleMenuPart,flag = "clovrButton",textSize = 80,page = "firstPage",callback = function()
            if clovrButtonDebounce then return end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                if LocalPlayer.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
                    changePage("CLOVRPage")
                else
                    clovrButtonDebounce = true
                    objects.buttons["clovrButton"].textlabel.Text = "MUST BE R6!"
                    wait(3)
                    clovrButtonDebounce = false
                    objects.buttons["clovrButton"].textlabel.Text = "CLOVR"
                end
            end
        end},
        {C1 = CFrame.new(0,-0.75,-0.15),text = "Settings",size = 3,parent = middleMenuPart,flag = "settingsbutton",textSize = 80,page = "firstPage",callback = function()
            changePage("settingsPage")
        end},
        --CLOVRPage
        {C1 = CFrame.new(0,-0.5,-0.15),text = "Run CLOVR",size = 2.5,parent = middleMenuPart,flag = "rclovr",textSize = 50,page = "CLOVRPage",callback = function()
            if clovrRan then return end
            clovrRan = true
            spawn(loadstring(game:HttpGet("https://raw.githubusercontent.com/sj0rs1/VR/main/CLOVR.lua",true)))
            -- CLOVR made by 0866, Abacaxl, Unverified, slurpey and Iris.
            -- https://v3rmillion.net/showthread.php?tid=953077 (Original CLOVR thread by Abacaxl, I edited a few lines to fix simulation radius.)
            -- I HAVE permission from Abacaxl to put it into my script. Proof: https://i.imgur.com/gr5qllX.png
        end},
        {C1 = CFrame.new(0,1.5-0.7,-0.15),text = "Toggle Viewport",size = 2,parent = rightMenuPart,flag = "toggleviewport",textSize = 60,page = "CLOVRPage",callback = function()
            _G.options.viewportEnabled = not _G.options.viewportEnabled
            objects.textLabels["viewport"].textlabel.Text = _G.options.viewportEnabled and "Viewport: Enabled" or "Viewport: Disabled"
        end},
        {C1 = CFrame.new(0,0.5-0.7,-0.15),text = "Toggle Hide Character",size = 2,parent = rightMenuPart,flag = "togglehidechar",textSize = 40,page = "CLOVRPage",callback = function()
            _G.options.hideCharacter = not _G.options.hideCharacter
            objects.textLabels["hctext"].textlabel.Text = _G.options.hideCharacter and "Hide Character: Enabled" or "Hide Character: Disabled"
        end},
        {C1 = CFrame.new(0,-1.3,-0.15),text = "Back to main menu",size = 1.5,parent = middleMenuPart,flag = "back2page",textSize = 40,page = "CLOVRPage",callback = function()
            changePage("firstPage")
        end},
        --settingsPage
        {C1 = CFrame.new(-0.6,1,-0.15),text = "Chat Mode Nearby",size = 1,parent = middleMenuPart,flag = "chatmodelocal",textSize = 40,page = "settingsPage",callback = function()
            objects.textLabels["cmt"].textlabel.Text = "Chat Mode: Nearby"
            chatnearbyonly = true
        end},
        {C1 = CFrame.new(0.6,1,-0.15),text = "Chat Mode All",size = 1,parent = middleMenuPart,flag = "chatmodeall",textSize = 40,page = "settingsPage",callback = function()
            objects.textLabels["cmt"].textlabel.Text = "Chat Mode: All"
            chatnearbyonly = false
        end},
        {C1 = CFrame.new(0,-2,-0.15),text = "Rejoin",size = 2,parent = rightMenuPart,flag = "rj",textSize = 50,page = "settingsPage",callback = function()
            game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId,game.JobId)
        end},
        {C1 = CFrame.new(0,-1.3,-0.15),text = "Back to main menu",size = 1.5,parent = middleMenuPart,flag = "back2page2",textSize = 40,page = "settingsPage",callback = function()
            changePage("firstPage")
        end},
    },
    textLabels = {
        --welcomePage
        {C1 = CFrame.new(0,2,-0.15),text = "Welcome to VR Essentials!",parent = middleMenuPart,flag = "welcomeMessage",size = 3,scaled = true,textSize = 70,page = "welcomePage"},
        {C1 = CFrame.new(0,2,-0.15),text = "Credits",parent = rightMenuPart,flag = "credit",size = 3,scaled = true,textSize = 70,page = "welcomePage"},
        {C1 = CFrame.new(0,1.3,-0.15),text = "CLOVR:",parent = rightMenuPart,flag = "clovr",size = 3,scaled = true,textSize = 70,page = "welcomePage"},
        {C1 = CFrame.new(0,0.8,-0.15),text = "0866,",parent = rightMenuPart,flag = "0866",size = 3,scaled = true,textSize = 70,page = "welcomePage"},
        {C1 = CFrame.new(0,0.3,-0.15),text = "Abacaxl,",parent = rightMenuPart,flag = "Abacaxl",size = 3,scaled = true,textSize = 70,page = "welcomePage"},
        {C1 = CFrame.new(0,-0.2,-0.15),text = "Unverified,",parent = rightMenuPart,flag = "Unverified",size = 3,scaled = true,textSize = 70,page = "welcomePage"},
        {C1 = CFrame.new(0,-0.7,-0.15),text = "slurpey,",parent = rightMenuPart,flag = "slurpey",size = 3,scaled = true,textSize = 70,page = "welcomePage"},
        {C1 = CFrame.new(0,-1.2,-0.15),text = "Iris",parent = rightMenuPart,flag = "Iris",size = 3,scaled = true,textSize = 70,page = "welcomePage"},
        --firstPage
        {C1 = CFrame.new(0,2,-0.15),text = "Features",parent = middleMenuPart,flag = "testm",size = 3,scaled = true,textSize = 70,page = "firstPage"},
        --CLOVRPage
        {C1 = CFrame.new(0,2,-0.15),text = "CLOVR",parent = middleMenuPart,flag = "clovr2",size = 3,scaled = true,textSize = 70,page = "CLOVRPage"},
        {C1 = CFrame.new(0,2,-0.15),text = "CLOVR Settings",parent = rightMenuPart,flag = "clovrsettings",size = 3,scaled = true,textSize = 50,page = "CLOVRPage"},
        {C1 = CFrame.new(0,1.05-0.7,-0.15),text = "Viewport: Disabled",parent = rightMenuPart,flag = "viewport",size = 2,scaled = true,textSize = 50,page = "CLOVRPage"},
        {C1 = CFrame.new(0,0.05-0.7,-0.15),text = "Hide Character: Disabled",parent = rightMenuPart,flag = "hctext",size = 2,scaled = true,textSize = 50,page = "CLOVRPage"},
        --optionsPage
        {C1 = CFrame.new(0,1.5,-0.15),text = "Chat Mode: All",parent = middleMenuPart,flag = "cmt",size = 2,scaled = true,textSize = 50,page = "settingsPage"},

    },
}--hideCharacter
-- Create the buttons, textlabels etc
local chatLogPart = Instance.new("Part",leftMenuPart)
local weldLogs = Instance.new("Weld",leftMenuPart)
local surfaceGuiLogs = Instance.new("SurfaceGui",chatLogPart)
local scrollFrameLogs = Instance.new("ScrollingFrame",surfaceGuiLogs)
local UIListLayoutLogs = Instance.new("UIListLayout",scrollFrameLogs)
surfaceGuiLogs.CanvasSize = Vector2.new(400,450)
chatLogPart.Anchored = false
chatLogPart.Size = Vector3.new(3,4,0.15)
chatLogPart.Transparency = 0.35
chatLogPart.Position = leftMenuPart.Position
chatLogPart.Color = Color3.fromRGB(255,255,255)
chatLogPart.CanCollide = false
chatLogPart.Material = "Neon"
scrollFrameLogs.Size = UDim2.new(1,0,1,0)
scrollFrameLogs.Transparency = 1
scrollFrameLogs.TopImage = ""
scrollFrameLogs.MidImage = ""
scrollFrameLogs.BottomImage = ""
weldLogs.Part0 = chatLogPart
weldLogs.Part1 = leftMenuPart
weldLogs.C1 = CFrame.new(0,0,-0.15)

function addMessage(message,plrName)
    if chatnearbyonly then
        if Players[plrName] and Players[plrName].Character and Players[plrName].Character.PrimaryPart and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
            local mag = (Players[plrName].Character.PrimaryPart.Position-LocalPlayer.Character.PrimaryPart.Position).magnitude
            if mag > 35 then return end 
        else
            return
        end
    end
    local messageFrame = Instance.new("Frame",scrollFrameLogs)
    local nameLabel = Instance.new("TextLabel",messageFrame)
    local messageLabel = Instance.new("TextLabel",messageFrame)
    messageFrame.Size = UDim2.new(1,0,0,25)
    messageFrame.BackgroundTransparency = 1

    nameLabel.Size = UDim2.new(0.35,0,1,0)
    nameLabel.Text = "   "..plrName
    nameLabel.TextColor3 = Color3.new(0,0,0)
    nameLabel.BackgroundColor3 = Color3.fromRGB(230,230,230)
    nameLabel.Font = "Nunito"
    nameLabel.TextSize = 17
    nameLabel.BorderSizePixel = 0
    nameLabel.TextXAlignment = "Left"

    messageLabel.Position = UDim2.new(0.35,0,0,0)
    messageLabel.Size = UDim2.new(0.65,0,1,0)
    messageLabel.Text = "   "..message
    messageLabel.TextColor3 = Color3.new(0,0,0)
    messageLabel.BackgroundColor3 = Color3.fromRGB(200,200,200)
    messageLabel.Font = "Nunito"
    messageLabel.TextSize = 15
    messageLabel.BorderSizePixel = 0
    messageLabel.TextXAlignment = "Left"
end
for i,v in next, Players:GetPlayers() do
    v.Chatted:connect(function(m)
        addMessage(m,v.Name)
    end)
end
Players.PlayerAdded:connect(function(v)
    v.Chatted:connect(function(m)
        addMessage(m,v.Name)
    end)
end)

for i,v in next, features.buttons do
    if not v.flag then v.flag = v.text end
    local poopPart = Instance.new("Part",v.parent)
    local weld = Instance.new("Weld",v.parent)
    local surfaceGui = Instance.new("SurfaceGui",poopPart)
    local textLabel = Instance.new("TextLabel",surfaceGui)
    surfaceGui.CanvasSize = Vector2.new(280*v.size,150)
    surfaceGui.Name = "gui"
    textLabel.Text = v.text
    textLabel.Visible = true
    textLabel.Size = UDim2.new(1,0,1,0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(0,0,0)
    textLabel.Font = "Nunito"
    textLabel.TextSize = v.textSize
    textLabel.Name = "text"
    textLabel.TextTransparency = 1
    poopPart.Anchored = false
    poopPart.Size = Vector3.new(v.size,0.4,0.15)
    poopPart.Transparency = 1
    poopPart.Position = v.parent.Position
    poopPart.Color = Color3.fromRGB(255,255,255)
    poopPart.CanCollide = false
    poopPart.Material = "Neon"
    weld.Part0 = poopPart
    weld.Part1 = v.parent
    weld.C1 = v.C1
    local flag = v.flag or v.text
    local poop = {
        part = poopPart,
        weld = weld,
        textlabel = textLabel,
        callback = v.callback,
        flag = flag,
    }
    table.insert(pages[v.page],poopPart)
    objects.buttons[flag] = poop
end
for i,v in next, features.textLabels do
    if not v.flag then v.flag = v.text end
    local poopPart = Instance.new("Part",v.parent)
    local weld = Instance.new("Weld",v.parent)
    local surfaceGui = Instance.new("SurfaceGui",poopPart)
    local textLabel = Instance.new("TextLabel",surfaceGui)
    surfaceGui.CanvasSize = Vector2.new(333*v.size,200)
    surfaceGui.Name = "gui"
    textLabel.Text = v.text
    textLabel.Visible = true
    textLabel.Size = UDim2.new(1,0,1,0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(0,0,0)
    textLabel.Font = "Nunito"
    textLabel.TextSize = v.textSize
    textLabel.Name = "text"
    textLabel.TextScaled = v.scaled or false
    textLabel.TextTransparency = 1
    poopPart.Anchored = false
    poopPart.Size = Vector3.new(v.size,0.4,0.05)
    poopPart.Transparency = 1
    poopPart.Position = v.parent.Position
    poopPart.Color = Color3.fromRGB(255,255,255)
    poopPart.CanCollide = false
    poopPart.Material = "Neon"
    weld.Part0 = poopPart
    weld.Part1 = v.parent
    weld.C1 = v.C1
    local flag = v.flag or v.text
    local poop = {
        part = poopPart,
        weld = weld,
        textlabel = textLabel,
        flag = flag,
    }
    table.insert(pages[v.page],poopPart)
    objects.textLabels[flag] = poop
end
-- Menu code
local hiding = false
function updateMenuPos(hide)
    if hiding then return end
    rightHand.Transparency = hide and 1 or 0.3
    leftHand.Transparency = hide and 1 or 0.3
    if hide then
        hiding = true
        for i=1,400 do RunService.RenderStepped:Wait() -- Stupid flying anim
            middleMenuPart.Position += Vector3.new(0,i/200,0)
            rightMenuPart.Position += Vector3.new(0,i/200,0)
            leftMenuPart.Position += Vector3.new(0,i/200,0)
            weldLogs.C1 = CFrame.new(0,0,-0.15)
            for i,v in next, features.buttons do
                objects.buttons[v.flag].weld.C1 = v.C1
            end
            for i,v in next, features.textLabels do
                objects.textLabels[v.flag].weld.C1 = v.C1
            end
        end
        hiding = false
        return
    end
    renderCFrame = Camera:GetRenderCFrame()
    middleMenuPart.CFrame = CFrame.new(renderCFrame.p + renderCFrame.LookVector*2, renderCFrame.p)
    middleMenuPart.Orientation -= Vector3.new(middleMenuPart.Orientation.X,0,0)
    middleMenuPart.Position -= Vector3.new(0, 0.75,0)
    rightMenuPart.CFrame = middleMenuPart.CFrame * CFrame.new(-2,0,0)
    rightMenuPart.CFrame = CFrame.new(rightMenuPart.Position, renderCFrame.p)
    rightMenuPart.CFrame = rightMenuPart.CFrame * CFrame.new(-2,0,0)
    rightMenuPart.Position -= Vector3.new(0,0.75,0)
    rightMenuPart.Orientation -= Vector3.new(rightMenuPart.Orientation.X,0,0)
    leftMenuPart.CFrame = middleMenuPart.CFrame * CFrame.new(2,0,0)
    leftMenuPart.CFrame = CFrame.new(leftMenuPart.Position, renderCFrame.p)
    leftMenuPart.CFrame = leftMenuPart.CFrame * CFrame.new(2,0,0)
    leftMenuPart.Position -= Vector3.new(0,0.75,0)
    leftMenuPart.Orientation -= Vector3.new(leftMenuPart.Orientation.X,0,0)
    wait()
    weldLogs.C1 = CFrame.new(0,0,-0.15)
    for i,v in next, features.buttons do
        objects.buttons[v.flag].weld.C1 = v.C1
    end
    for i,v in next, features.textLabels do
        objects.textLabels[v.flag].weld.C1 = v.C1
    end
end

local debounce = false
function checkPresses()-- Detects if you are pressing the buttons on the menu
    if debounce then return end
    for i,v in next, objects.buttons do
        if v.part.Transparency ~= 1 and (v.part.Position - mainHand.Position).magnitude <= 0.25 then
            debounce = true
            v.part.Color = Color3.fromRGB(200,200,200)
            repeat wait()
                local mag = (v.part.Position - mainHand.Position).magnitude
            until mag >= 0.8
            v.part.Color = Color3.fromRGB(255,255,255)
            debounce = false
            v.callback()
        end
    end
end

function userCFrameChanged()-- Stolen math from one of RobloxVR's games (https://www.roblox.com/games/924343510)
	local userHeadCFrame = UserInputService:GetUserCFrame(Enum.UserCFrame.Head)
	local userRightHandCFrame = UserInputService:GetUserCFrame(Enum.UserCFrame.RightHand)
    local userLeftHandCFrame = UserInputService:GetUserCFrame(Enum.UserCFrame.LeftHand)
    if userRightHandCFrame == newCFrame then
        userRightHandCFrame = Camera:GetRenderCFrame() * CFrame.new(0.2,-0.5,-1) * CFrame.Angles(0,0,0)
    else
        userRightHandCFrame = Camera.CoordinateFrame * userRightHandCFrame * CFrame.new(0,0,0.3) * CFrame.Angles(-math.pi*.25,0,0)
    end
    if userLeftHandCFrame == newCFrame then
		userLeftHandCFrame = userRightHandCFrame * CFrame.Angles(0,0,0) * CFrame.new(0,0,-1.3)
	else
		userLeftHandCFrame = Camera.CoordinateFrame * userLeftHandCFrame * CFrame.new(0,0,0.3) * CFrame.Angles(-math.pi*.25,0,0)
    end
    rightHand.CFrame = userRightHandCFrame
    leftHand.CFrame = userLeftHandCFrame
end

VRService.UserCFrameChanged:Connect(userCFrameChanged)
UserInputService.InputBegan:connect(function(key,processed)
    if processed then return end
    if key.KeyCode == Enum.KeyCode.ButtonR1 or devMode and key.KeyCode == Enum.KeyCode.P then
        updateMenuPos()
    end
    if key.KeyCode == Enum.KeyCode.ButtonL1 or devMode and key.KeyCode == Enum.KeyCode.L then
        updateMenuPos(true)
    end
end)

updateMenuPos()
changePage("welcomePage",true)
spawn(function()
    RunService.RenderStepped:connect(function()
        scrollFrameLogs.CanvasPosition = Vector2.new(0,(#scrollFrameLogs:GetChildren()-1)*25)
        scrollFrameLogs.CanvasSize = UDim2.new(0, 0, 0, UIListLayoutLogs.AbsoluteContentSize.Y)
    end)
end)
while RunService.RenderStepped:Wait() do
    checkPresses()
end

