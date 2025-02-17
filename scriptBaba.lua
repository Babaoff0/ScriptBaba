-- Créer le ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Créer un Frame pour contenir les boutons
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

-- Créer les boutons
local button1 = Instance.new("TextButton")
button1.Parent = frame
button1.Size = UDim2.new(0, 200, 0, 50)
button1.Position = UDim2.new(0.5, -100, 0.3, -25)
button1.Text = "Auto Collect Heart"

local button2 = Instance.new("TextButton")
button2.Parent = frame
button2.Size = UDim2.new(0, 200, 0, 50)
button2.Position = UDim2.new(0.5, -100, 0.7, -25)
button2.Text = "Auto Farm VIP basic"

-- Variables pour l'état des scripts
local actionEnabledHeart = false
local actionEnabledVIP = false

-- Fonction pour activer/désactiver Auto Collect Heart
local function teleportToTreasures()
    print("🔄 Auto-farm TreasureService activé ! (Version rapide)")

    while actionEnabledHeart do
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")

        if not hrp then
            print("❌ Erreur : HumanoidRootPart introuvable !")
            task.wait(1)
            continue
        end

        local treasureFolder = workspace:FindFirstChild("Treasure")
        if not treasureFolder then
            print("❌ Erreur : Le dossier Treasure est introuvable dans workspace.")
            task.wait(1)
            continue
        end

        -- Récupérer tous les TreasureServices dans le dossier
        local treasureServices = {}
        for _, obj in ipairs(treasureFolder:GetDescendants()) do
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                table.insert(treasureServices, obj)
            end
        end

        -- TP à chaque TreasureService plus rapidement
        for _, treasure in ipairs(treasureServices) do
            hrp.CFrame = treasure.CFrame + Vector3.new(0, 2, 0)
            task.wait(0.4)
        end

        task.wait(0.1)
    end
end

-- Fonction pour activer/désactiver Auto Farm VIP basic
local function autoFarmVIP()
    local runService = game:GetService("RunService")
    runService.Heartbeat:Connect(function()
        local fireballArgs = { [1] = Vector3.new(454.44305419921875, 13.059944152832031, 292.54302978515625) }
        local hitArgs = { [1] = workspace.Dummy.NormalDummy.VIPDummy.Humanoid }

        task.spawn(function()
            game:GetService("ReplicatedStorage").Packages.Knit.Services.HitService.RF.Fireball:InvokeServer(unpack(fireballArgs))
        end)

        task.spawn(function()
            game:GetService("ReplicatedStorage").Packages.Knit.Services.HitService.RF.Hit:InvokeServer(unpack(hitArgs))
        end)
    end)
end

-- Fonction de gestion des clics sur les boutons
button1.MouseButton1Click:Connect(function()
    if actionEnabledHeart then
        actionEnabledHeart = false
        button1.Text = "On/Off"
        print("❌ Script Auto Collect Heart désactivé")
    else
        actionEnabledHeart = true
        button1.Text = "Off/On"
        coroutine.wrap(teleportToTreasures)()
        print("✅ Script Auto Collect Heart activé")
    end
end)

button2.MouseButton1Click:Connect(function()
    if actionEnabledVIP then
        actionEnabledVIP = false
        button2.Text = "On/Off"
        print("❌ Script Auto Farm VIP basic désactivé")
    else
        actionEnabledVIP = true
        button2.Text = "Off/On"
        autoFarmVIP()
        print("✅ Script Auto Farm VIP basic activé")
    end
end)
