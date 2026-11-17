-- PS99 PRO EXPLOIT v2 | By Alone1337x
-- Bağımsız, Kütüphanesiz, Stabil Versiyon

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- -----------------------------
-- 1. BASİT GUI MENÜSÜ (BAĞIMSIZ)
-- -----------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PS99_HackMenu"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.fromScale(0.3, 0.5)
mainFrame.Position = UDim2.fromScale(0.7, 0.2)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.fromScale(1, 0.15)
title.BackgroundTransparency = 1
title.Text = "PS99 PRO v2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local function createButton(name, yPos, onClick)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.fromScale(0.9, 0.12)
    btn.Position = UDim2.fromScale(0.05, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name:upper()
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextScaled = true
    btn.BorderSizePixel = 0
    btn.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

-- -----------------------------
-- 2. MODÜLLER
-- -----------------------------

-- A) FLY MODE (UÇUŞ)
local flyActive = false
local flySpeed = 50

local flyBtn = createButton("Fly Mode (F)", 0.15, function()
    flyActive = not flyActive
    flyBtn.BackgroundColor3 = flyActive and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(40, 40, 40)
    if not flyActive then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        root.AssemblyLinearVelocity = Vector3.zero
    end
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        flyActive = not flyActive
        flyBtn.BackgroundColor3 = flyActive and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(40, 40, 40)
        if not flyActive then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if flyActive and character and root and humanoid then
        local cam = workspace.CurrentCamera
        local look = cam.CFrame.LookVector
        local up = cam.CFrame.UpVector
        local right = cam.CFrame.RightVector
        
        local move = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + look end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - look end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - right end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + right end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + up end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - up end
        
        if move.Magnitude > 0 then
            root.AssemblyLinearVelocity = move.Unit * flySpeed
        else
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

-- B) SPEED BOOST (HIZ)
local speedBtn = createButton("Speed Boost (50)", 0.25, function()
    local current = humanoid.WalkSpeed
    if current > 20 then
        humanoid.WalkSpeed = 16
        speedBtn.Text = "SPEED BOOST (50)"
    else
        humanoid.WalkSpeed = 50
        speedBtn.Text = "RESET SPEED (16)"
    end
end)

-- C) AUTO HATCH (OTOMATİK YUMURTA)
local hatchBtn = createButton("Auto Hatch", 0.35, function()
    hatchBtn:GetAttribute("Active") == nil and hatchBtn:SetAttribute("Active", true) or hatchBtn:SetAttribute("Active", not hatchBtn:GetAttribute("Active"))
    local isActive = hatchBtn:GetAttribute("Active")
    hatchBtn.BackgroundColor3 = isActive and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(40, 40, 40)
    
    if isActive then
        task.spawn(function()
            print("[PS99] Auto Hatch Başlatıldı...")
            while hatchBtn:GetAttribute("Active") do
                -- PS99 Remote'larını Dinle
                local remotes = ReplicatedStorage:WaitForChild("ReplicatedFirst"):WaitForChild("Remotes")
                local hatchRemote = remotes:FindFirstChild("Hatch") or remotes:FindFirstChild("HatchEgg")
                
                if hatchRemote then
                    -- Envanterdeki Yumurtaları Tara
                    local playerGui = player:WaitForChild("PlayerGui")
                    local inventory = playerGui:FindFirstChild("Inventory") or playerGui:FindFirstChild("EggInventory")
                    
                    if inventory then
                        for _, egg in pairs(inventory:GetDescendants()) do
                            if egg:IsA("Frame") and (egg.Name:find("Egg") or egg:GetAttribute("IsEgg")) then
                                local eggId = egg:GetAttribute("EggId") or egg:GetAttribute("ItemId") or egg.Name
                                pcall(function()
                                    hatchRemote:FireServer(eggId)
                                end)
                                wait(0.5) -- Spam'i Önle
                            end
                        end
                    end
                end
                wait(1)
            end
            print("[PS99] Auto Hatch Durduruldu.")
        end)
    end
end)

-- D) PET ESP (VURGU)
local espBtn = createButton("Pet ESP", 0.45, function()
    espBtn:GetAttribute("Active") == nil and espBtn:SetAttribute("Active", true) or espBtn:SetAttribute("Active", not espBtn:GetAttribute("Active"))
    local isActive = espBtn:GetAttribute("Active")
    espBtn.BackgroundColor3 = isActive and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(40, 40, 40)
    
    if isActive then
        task.spawn(function()
            while espBtn:GetAttribute("Active") do
                for _, desc in pairs(workspace.Descendants) do
                    if desc:IsA("Model") and desc.Name:find("Pet") then
                        if not desc:FindFirstChild("PS99_ESP") then
                            local h = Instance.new("Highlight")
                            h.FillColor = Color3.fromRGB(0, 255, 128)
                            h.FillTransparency = 0.5
                            h.OutlineColor = Color3.fromRGB(0, 255, 128)
                            h.OutlineTransparency = 0
                            h.Name = "PS99_ESP"
                            h.Parent = desc
                        end
                    else
                        local esp = desc:FindFirstChild("PS99_ESP")
                        if esp then esp:Destroy() end
                    end
                end
                wait(0.5)
            end
        end)
    else
        for _, desc in pairs(workspace.Descendants) do
            local esp = desc:FindFirstChild("PS99_ESP")
            if esp then esp:Destroy() end
        end
    end
end)

-- E) TELEPORT (IŞINLANMA)
createButton("Teleport to Farm", 0.55, function()
    local farm = workspace:FindFirstChild("Farm") or workspace:FindFirstChild("PlayerFarm")
    if farm then
        pcall(function()
            root.CFrame = farm:GetPivot() + Vector3.new(0, 10, 0)
            print("[PS99] Çiftliğe Işınlandı!")
        end)
    else
        print("[PS99] Çiftlik Bulunamadı!")
    end
end)

print("[PS99] Pro Exploit v2 Yüklendi. Menü aktif.")
