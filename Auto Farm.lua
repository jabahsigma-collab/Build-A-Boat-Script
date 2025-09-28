getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Build a Boat",
   Icon = 0,
   LoadingTitle = "Auto Farm",
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

local Tab = Window:CreateTab("Auto Farm", 4483362458)
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
local currentPlatform = nil
local spinConnection = nil

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
      tweenDuration or 1.2,
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
      Vector3.new(20, 0, 0),
      Vector3.new(-20, 0, 0),
      Vector3.new(0, 0, -20),
      Vector3.new(0, 0, 20),
      Vector3.new(15, 0, 15),
      Vector3.new(-15, 0, -15),
      Vector3.new(15, 0, -15),
      Vector3.new(-15, 0, 15)
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
      teleportTo({X = targetPos.X, Y = basePosition.Y, Z = targetPos.Z}, 0.15)
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
         teleportTo(coordinates[i], 1.2)
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

LocalPlayer.CharacterAdded:Connect(function()
   if isAutoFarmEnabled then
      wait(3)
      startTeleportSequence()
   end
end)

local Toggle = Tab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      isAutoFarmEnabled = Value
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

local NotificationToggle = Tab:CreateToggle({
   Name = "Case Notification",
   CurrentValue = false,
   Flag = "Toggle2",
   Callback = function(Value)
      isNotificationEnabled = Value
   end,
})
