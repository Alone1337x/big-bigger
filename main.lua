-- PS99 PRO EXPLOIT
-- By DeepHat

-- 1. Kütüphaneyi Yükle (Hydroxene)
local Hydro = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stravant/Fluent/main/src/init.lua"))()

-- 2. Temel Referanslar
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- 3. Menüyü Oluştur
local tab = Hydro:CreateTab("PS99", "Pet Simulator 99 Pro Panel")

-- --- MODÜL 1: UÇUŞ (FLY) ---
local flyToggle = tab:CreateToggle("Fly Mode", false)
local flyActive = false
local flySpeed = 50

flyToggle:OnChanged(function(state)
    flyActive = state
    if not flyActive then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        root.AssemblyLinearVelocity = Vector3.zero
    end
end)

RunService.RenderStepped:Connect(function()
    if flyActive and character and root then
        local camera = workspace.CurrentCamera
        local lookVector = camera.CFrame.LookVector
        local upVector = camera.CFrame.UpVector
        local rightVector = camera.CFrame.RightVector
        
        local moveVector = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + lookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - lookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - rightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + rightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + upVector end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector = moveVector - upVector end
        
        if moveVector.Magnitude > 0 then
            root.AssemblyLinearVelocity = moveVector.Unit * flySpeed
        else
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

-- --- MODÜL 2: HIZ AYARI (SPEED) ---
local speedSlider = tab:CreateSlider("Walk Speed", 16, 0, 100, 16)
speedSlider:OnChanged(function(value)
    humanoid.WalkSpeed = value
end)

-- --- MODÜL 3: OTOMATİK YUMURTA KIRMA (AUTO HATCH) ---
local hatchToggle = tab:CreateToggle("Auto Hatch", false)
local hatching = false

hatchToggle:OnChanged(function(state)
    hatching = state
    if hatching then
        task.spawn(function()
            local remotes = ReplicatedStorage:WaitForChild("ReplicatedFirst"):WaitForChild("Remotes")
            while hatching do
                local eggInventory = player:WaitForChild("PlayerGui"):FindFirstChild("Inventory")
                if eggInventory then
                    for _, egg in pairs(eggInventory:GetChildren()) do
                        if egg:IsA("Frame") and egg.Name:find("Egg") then
                            local hatchRemote = remotes:FindFirstChild("Hatch")
                            if hatchRemote then
                                hatchRemote:FireServer(egg:GetAttribute("EggId") or egg.Name)
                                wait(0.5)
                            end
                        end
                    end
                end
                wait(1)
            end
        end)
    end
end)

-- --- MODÜL 4: PET ESP (VURGU) ---
local espToggle = tab:CreateToggle("Pet ESP", false)
local espActive = false

espToggle:OnChanged(function(state)
    espActive = state
    if espActive then
        task.spawn(function()
            while espActive do
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
                        local existingESP = desc:FindFirstChild("PS99_ESP")
                        if existingESP then existingESP:Destroy() end
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

-- --- MODÜL 5: TELEPORT (TELEPORT) ---
tab:CreateButton("Teleport to Farm", function()
    local farm = workspace:FindFirstChild("Farm")
    if farm then
        root.CFrame = farm:GetPivot() + Vector3.new(0, 10, 0)
        print("Çiftliğe ışınlandın!")
    else
        print("Çiftlik bulunamadı!")
    end
end)

print("PS99 Pro Exploit Yüklendi. Menüyü sağ üstte bul.")
