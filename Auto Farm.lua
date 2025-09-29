getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local UserInputService = game:GetService("UserInputService")

local Window = Rayfield:CreateWindow({
   Name = "Build a Boat Auto Farm",
   Icon = 0,
   LoadingTitle = "Build a Boat Auto Farm - By JABA",
   LoadingSubtitle = "by JABA",
   ShowText = "Rayfield",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "key",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"JABA"}
   }
})

local PlayerTab = Window:CreateTab("Player", 4483362458)
local HitboxTab = Window:CreateTab("Hitbox", 4483362458)
local NotificationTab = Window:CreateTab("Notification", 4483362458)
local AutoFarmTab = Window:CreateTab("Auto Farm", 4483362458)
local QuestsTab = Window:CreateTab("Quests", 4483362458)
local EspTab = Window:CreateTab("Esp", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local coordinates = {
   {X = -47.76, Y = 55.02, Z = 1258.08},
   {X = -52.27, Y = 53.22, Z = 2068.29},
   {X = -53.37, Y = 61.48, Z = 2824.95},
   {X = -45.59, Y = 58.28, Z = 3620.83},
   {X = -49.42, Y = 94.42, Z = 4382.18},
   {X = -49.77, Y = 85.24, Z = 5045.65},
   {X = -56.34, Y = 73.38, Z = 5798.88},
   {X = -63.25, Y = 56.97, Z = 6656.30},
   {X = -57.12, Y = 55.64, Z = 7369.10},
   {X = -55.99, Y = 70.30, Z = 8114.71},
   {X = -30.76, Y = -140.06, Z = 8931.41},
   {X = -51.55, Y = -359.38, Z = 9495.63}
}

local isAutoFarmEnabled = false
local isTeleporting = false
local isNotificationEnabled = false
local isAntiAfkEnabled = false
local isWalkSpeedEnabled = false
local isJumpPowerEnabled = false
local isHitboxExpanderEnabled = false
local isCaseExpanderEnabled = false
local isQuestTeleportEnabled = false
local isEspEnabled = false
local currentPlatform = nil
local spinConnection = nil
local originalCaseSizes = {}
local highlights = {}
local espColor = Color3.fromRGB(255, 0, 0)

local function startSpinning(speed)
   if spinConnection then
      spinConnection:Disconnect()
      spinConnection = nil
   end
   spinConnection = RunService.Heartbeat:Connect(function(deltaTime)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         local hrp = LocalPlayer.Character.HumanoidRootPart
         hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(speed) * deltaTime, 0)
      end
   end)
end

local function stopSpinning()
   if spinConnection then
      spinConnection:Disconnect()
      spinConnection = nil
   end
end

LocalPlayer.CharacterRemoving:Connect(function()
   stopSpinning()
end)

local function createPlatform(position)
   if currentPlatform then
      currentPlatform:Destroy()
      currentPlatform = nil
   end
   
   local part = Instance.new("Part")
   part.Size = Vector3.new(30, 0.5, 30)
   part.Position = position + Vector3.new(0, -3, 0)
   part.Anchored = true
   part.Transparency = 0.5
   part.CanCollide = true
   part.Parent = Workspace
   currentPlatform = part
end

local function teleportTo(coord, tweenDuration)
   if isTeleporting or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      return
   end

   isTeleporting = true
   local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
   local targetPosition = Vector3.new(coord.X, coord.Y, coord.Z)
   
   createPlatform(targetPosition)
   
   local tweenInfo = TweenInfo.new(
      tweenDuration or 1.5,
      Enum.EasingStyle.Linear,
      Enum.EasingDirection.InOut,
      0,
      false,
      0
   )
   
   humanoidRootPart.Anchored = true
   local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
   tween:Play()
   tween.Completed:Wait()
   wait(0.1)
   humanoidRootPart.Anchored = false
   isTeleporting = false
end

local function chaoticTeleports()
   local lastCoord = coordinates[#coordinates]
   local basePosition = Vector3.new(lastCoord.X, lastCoord.Y, lastCoord.Z)
   local chaoticOffsets = {
      Vector3.new(0, 10, 0),
      Vector3.new(0, -10, 0)
   }
   
   local startTime = tick()
   if isNotificationEnabled then
      Rayfield:Notify({
         Title = "Touched Case",
         Content = "Case",
         Duration = 6.5,
         Image = 4483362458
      })
   end
   while tick() - startTime < 3 and isAutoFarmEnabled do
      local randomOffset = chaoticOffsets[math.random(1, #chaoticOffsets)]
      local targetPos = basePosition + randomOffset
      teleportTo({X = targetPos.X, Y = targetPos.Y, Z = targetPos.Z}, 0.7)
      wait(0.1)
   end
end

local function startTeleportSequence()
   spawn(function()
      if not isAutoFarmEnabled then return end
      
      for i = 1, #coordinates do
         if not isAutoFarmEnabled then
            if currentPlatform then
               currentPlatform:Destroy()
               currentPlatform = nil
            end
            return
         end
         teleportTo(coordinates[i], 1.5)
         if i == 4 then
            wait(1)
         else
            wait(0.05)
         end
      end
      
      if isAutoFarmEnabled then
         startSpinning(30)
         chaoticTeleports()
         while isAutoFarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 do
            wait(0.5)
         end
         if currentPlatform then
            currentPlatform:Destroy()
            currentPlatform = nil
         end
      end
   end)
end

local function startAntiAfk()
   spawn(function()
      while isAntiAfkEnabled do
         if LocalPlayer.Character then
            UserInputService:SendInput(Enum.KeyCode.Space, true)
            wait(0.1)
            UserInputService:SendInput(Enum.KeyCode.Space, false)
         end
         wait(30)
      end
   end)
end

local function updateWalkSpeed(value)
   if isWalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.WalkSpeed = value
   end
end

local function updateJumpPower(value)
   if isJumpPowerEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.JumpPower = value
   end
end

local function updateHitboxSize(value)
   if isHitboxExpanderEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
      LocalPlayer.Character.Head.Size = Vector3.new(value, value, value)
   end
end

local function updateCaseSize(value)
   if isCaseExpanderEnabled then
      for _, obj in pairs(Workspace:GetDescendants()) do
         if obj.Name == "GoldenChest" and obj:IsA("BasePart") then
            if not originalCaseSizes[obj] then
               originalCaseSizes[obj] = obj.Size
            end
            obj.Size = Vector3.new(value, value, value)
         end
      end
   end
end

local function addHighlight(character)
   if character then
      local highlight = Instance.new("Highlight")
      highlight.Adornee = character
      highlight.FillColor = espColor
      highlight.OutlineColor = espColor
      highlight.Parent = character
      return highlight
   end
end

local function enableEsp()
   for _, player in pairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character then
         highlights[player] = addHighlight(player.Character)
      end
   end
end

local function disableEsp()
   for _, highlight in pairs(highlights) do
      if highlight then
         highlight:Destroy()
      end
   end
   highlights = {}
end

local function updateEspColor()
   for _, highlight in pairs(highlights) do
      if highlight then
         highlight.FillColor = espColor
         highlight.OutlineColor = espColor
      end
   end
end

for _, player in pairs(Players:GetPlayers()) do
   if player ~= LocalPlayer then
      player.CharacterAdded:Connect(function(char)
         if isEspEnabled then
            highlights[player] = addHighlight(char)
         end
      end)
      if isEspEnabled and player.Character then
         highlights[player] = addHighlight(player.Character)
      end
   end
end

Players.PlayerAdded:Connect(function(player)
   if player ~= LocalPlayer then
      player.CharacterAdded:Connect(function(char)
         if isEspEnabled then
            highlights[player] = addHighlight(char)
         end
      end)
   end
end)

LocalPlayer.CharacterAdded:Connect(function()
   if isAutoFarmEnabled then
      wait(3)
      startTeleportSequence()
   end
   if isWalkSpeedEnabled then
      updateWalkSpeed(PlayerTab:GetSliderValue("WalkSpeedSlider"))
   end
   if isJumpPowerEnabled then
      updateJumpPower(PlayerTab:GetSliderValue("JumpPowerSlider"))
   end
   if isHitboxExpanderEnabled then
      updateHitboxSize(HitboxTab:GetSliderValue("HitboxSlider"))
   end
end)

local WalkSpeedToggle = PlayerTab:CreateToggle({
   Name = "WalkSpeed",
   CurrentValue = false,
   Flag = "Toggle4",
   Callback = function(Value)
      isWalkSpeedEnabled = Value
      Rayfield:Notify({
         Title = Value and "WalkSpeed Enabled" or "WalkSpeed Disabled",
         Content = Value and "WalkSpeed adjustment is now active" or "WalkSpeed adjustment is now inactive",
         Duration = 6.5,
         Image = 4483362458
      })
      if Value then
         updateWalkSpeed(PlayerTab:GetSliderValue("WalkSpeedSlider"))
      else
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
         end
      end
   end,
})

local WalkSpeedSlider = PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
      updateWalkSpeed(Value)
   end,
})

local JumpPowerToggle = PlayerTab:CreateToggle({
   Name = "JumpPower",
   CurrentValue = false,
   Flag = "Toggle5",
   Callback = function(Value)
      isJumpPowerEnabled = Value
      Rayfield:Notify({
         Title = Value and "JumpPower Enabled" or "JumpPower Disabled",
         Content = Value and "JumpPower adjustment is now active" or "JumpPower adjustment is now inactive",
         Duration = 6.5,
         Image = 4483362458
      })
      if Value then
         updateJumpPower(PlayerTab:GetSliderValue("JumpPowerSlider"))
      else
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = 50
         end
      end
   end,
})

local JumpPowerSlider = PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {16, 100},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 16,
   Flag = "JumpPowerSlider",
   Callback = function(Value)
      updateJumpPower(Value)
   end,
})

local HitboxToggle = HitboxTab:CreateToggle({
   Name = "Hitbox Expander",
   CurrentValue = false,
   Flag = "Toggle6",
   Callback = function(Value)
      isHitboxExpanderEnabled = Value
      Rayfield:Notify({
         Title = Value and "Hitbox Expander Enabled" or "Hitbox Expander Disabled",
         Content = Value and "Hitbox expansion is now active" or "Hitbox expansion is now inactive",
         Duration = 6.5,
         Image = 4483362458
      })
      if Value then
         updateHitboxSize(HitboxTab:GetSliderValue("HitboxSlider"))
      else
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            LocalPlayer.Character.Head.Size = Vector3.new(1, 1, 1)
         end
      end
   end,
})

local HitboxSlider = HitboxTab:CreateSlider({
   Name = "Hitbox Size",
   Range = {1, 10},
   Increment = 0.1,
   Suffix = "Size",
   CurrentValue = 1,
   Flag = "HitboxSlider",
   Callback = function(Value)
      updateHitboxSize(Value)
   end,
})

local CaseExpanderToggle = HitboxTab:CreateToggle({
   Name = "Case Expander",
   CurrentValue = false,
   Flag = "Toggle7",
   Callback = function(Value)
      isCaseExpanderEnabled = Value
      Rayfield:Notify({
         Title = Value and "Case Expander Enabled" or "Case Expander Disabled",
         Content = Value and "Case size adjustment is now active" or "Case size adjustment is now inactive",
         Duration = 6.5,
         Image = 4483362458
      })
      if Value then
         updateCaseSize(HitboxTab:GetSliderValue("CaseSlider"))
      else
         for obj, size in pairs(originalCaseSizes) do
            if obj and obj.Parent then
               obj.Size = size
            end
         end
         originalCaseSizes = {}
      end
   end,
})

local CaseSlider = HitboxTab:CreateSlider({
   Name = "Case Size",
   Range = {1, 10},
   Increment = 0.1,
   Suffix = "Size",
   CurrentValue = 1,
   Flag = "CaseSlider",
   Callback = function(Value)
      updateCaseSize(Value)
   end,
})

local NotificationToggle = NotificationTab:CreateToggle({
   Name = "Case Notification",
   CurrentValue = false,
   Flag = "Toggle2",
   Callback = function(Value)
      isNotificationEnabled = Value
      Rayfield:Notify({
         Title = Value and "Case Notification Enabled" or "Case Notification Disabled",
         Content = Value and "Case notifications are now active" or "Case notifications are now inactive",
         Duration = 6.5,
         Image = 4483362458
      })
   end,
})

local Toggle = AutoFarmTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      isAutoFarmEnabled = Value
      Rayfield:Notify({
         Title = Value and "Auto Farm Enabled" or "Auto Farm Disabled",
         Content = Value and "Auto Farm is now active" or "Auto Farm is now inactive",
         Duration = 6.5,
         Image = 4483362458
      })
      if Value then
         if LocalPlayer.Character then
            startTeleportSequence()
         end
      else
         if currentPlatform then
            currentPlatform:Destroy()
            currentPlatform = nil
         end
         stopSpinning()
      end
   end,
})

local AntiAfkToggle = MiscTab:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = false,
   Flag = "Toggle3",
   Callback = function(Value)
      isAntiAfkEnabled = Value
      Rayfield:Notify({
         Title = Value and "Anti AFK Enabled" or "Anti AFK Disabled",
         Content = Value and "Anti AFK is now active" or "Anti AFK is now inactive",
         Duration = 6.5,
         Image = 4483362458
      })
      if Value then
         startAntiAfk()
      end
   end,
})

local QuestTeleportToggle = QuestsTab:CreateToggle({
   Name = "Teleport to Cloud",
   CurrentValue = false,
   Flag = "Toggle8",
   Callback = function(Value)
      isQuestTeleportEnabled = Value
      Rayfield:Notify({
         Title = Value and "Quest Teleport Enabled" or "Quest Teleport Disabled",
         Content = Value and "Teleporting to Cloud" or "Quest teleport is now inactive",
         Duration = 6.5,
         Image = 4483362458
      })
      if Value then
         local questFolder = Workspace:FindFirstChild("Quest")
         if questFolder then
            local cloud = questFolder:FindFirstChild("Cloud")
            if cloud and cloud:IsA("Model") then
               local part2 = cloud:FindFirstChild("Part2")
               if part2 then
                  local pos = part2.Position
                  teleportTo({X = pos.X, Y = pos.Y, Z = pos.Z}, 1.5)
               end
            end
         end
      end
   end,
})

local EspToggle = EspTab:CreateToggle({
   Name = "Highlight",
   CurrentValue = false,
   Flag = "Toggle9",
   Callback = function(Value)
      isEspEnabled = Value
      Rayfield:Notify({
         Title = Value and "ESP Highlight Enabled" or "ESP Highlight Disabled",
         Content = Value and "Player highlighting is now active" or "Player highlighting is now inactive",
         Duration = 6.5,
         Image = 4483362458
      })
      if Value then
         enableEsp()
      else
         disableEsp()
      end
   end,
})

local ColorPicker = EspTab:CreateColorPicker({
   Name = "Highlight Color",
   Color = Color3.fromRGB(255, 0, 0),
   Flag = "EspColorPicker",
   Callback = function(Color)
      espColor = Color
      updateEspColor()
   end,
})
