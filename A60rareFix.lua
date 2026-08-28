-- Import spawner
local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()
local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Khởi tạo entity
local entity = spawner.Create({
	Entity = {
		Name = "A60",
		Asset = "https://github.com/ppG64tre-Cool/Entity-spawn/blob/main/ARE YOU SERI3.rbxm?raw=true",
		HeightOffset = 1
	},
	Lights = {
		Flicker = {Enabled = false, Duration = 1},
		Shatter = false,
		Repair = false
	},
	Earthquake = {Enabled = true},
	CameraShake = {
		Enabled = true,
		Range = 100,
		Values = {20, 30, 0.1, 0.1}
	},
	Movement = {
		Speed = 200,
		Delay = 6,
		Reversed = false
	},
	Rebounding = {
		Enabled = true,
		Type = "Ambush",
		Min = 4,
		Max = 8,
		Delay = 0.5
	},
	Damage = {
		Enabled = true,
		Range = 100,
		Amount = 0.01
	},
	Crucifixion = {
		Enabled = true,
		Range = math.huge,
		Resist = false,
		Break = true
	},
	Death = {
		Type = "Guiding",
		Hints = {"Death", "Hints", "Go", "Here"},
		Cause = ""
	}
})

-- Hiệu ứng ánh sáng

-- ================== ON SPAWN ==================
entity:SetCallback("OnSpawned", function()
	require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("A-60 : Prepare Yourseft", true)
	wait(2)
	local lighting = game.Lighting
	lighting.MainColorCorrection.TintColor = Color3.fromRGB(255, 0, 0)
	lighting.MainColorCorrection.Contrast = 0.2
	TweenService:Create(lighting.MainColorCorrection, TweenInfo.new(2.5), {Contrast = 0}):Play()
	TweenService:Create(lighting.MainColorCorrection, TweenInfo.new(20), {TintColor = Color3.fromRGB(255, 255, 255)}):Play()

	-- Camera Shake
	local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
	local camara = game.Workspace.CurrentCamera
	local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
		camara.CFrame = camara.CFrame * shakeCf
	end)
	camShake:Start()
	camShake:ShakeOnce(40,70,0,4,2,12)
	local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
	local camara = game.Workspace.CurrentCamera

	local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(cf)
		camara.CFrame = camara.CFrame * cf
	end)

	camShake:Start()
	camShake:Shake(CameraShaker.Presets.Earthquake)

	local part = workspace:WaitForChild("A60")
	local object = part:WaitForChild("RushNew")
	local attachment = object:WaitForChild("Main")
	local emitter = attachment:FindFirstChildWhichIsA("Face")

	object.CanCollide = false

	local running = true
	spawn(function()
		while running and emitter and emitter:IsDescendantOf(workspace) do
			local textures = {
				"rbxassetid://12145534911",
				"rbxassetid://12145554242",
				"rbxassetid://12145599498",
				"rbxassetid://12145599275",
				"rbxassetid://12155335619",
				"rbxassetid://12145598814",
				"rbxassetid://12146135062",
				"rbxassetid://11378285585"
			}
			for _, tex in ipairs(textures) do
				emitter.Texture = tex
				task.wait()
			end
		end
	end)

	entity:SetCallback("OnDespawning", function()
		running = false

		local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
			camera.CFrame = camera.CFrame * shakeCf
		end)
		camShake:Start()
		camShake:ShakeOnce(50, 50, 0, 2, 1, 6)

		local tints = {
			{Color = Color3.fromRGB(30, 30, 30), Time = 0.5},
			{Color = Color3.fromRGB(60, 60, 60), Time = 0.5},
			{Color = Color3.fromRGB(120, 120, 120), Time = 1.2},
			{Color = Color3.fromRGB(255, 255, 255), Time = 1.2}
		}

		for _, tint in ipairs(tints) do
			local t = TweenService:Create(lighting.MainColorCorrection, TweenInfo.new(tint.Time), {TintColor = tint.Color})
			t:Play()
			task.wait(tint.Time)
		end
	end)
end)

-- ================== ON DAMAGE ==================
entity:SetCallback("OnDamagePlayer", function(newHealth)
	if newHealth == 0 then
		warn("Player chết")
		return
	end
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

		local entityModel = workspace:FindFirstChild("A60")
		local primaryPart = entityModel and entityModel:FindFirstChild("RushNew")
		if not primaryPart then return end

		-- 🔇 Tắt tất cả âm thanh tạm thời
		local allSounds = {}
		for _, obj in ipairs(game:GetDescendants()) do
			if obj:IsA("Sound") and obj.IsPlaying then
				obj:Stop()
				table.insert(allSounds, obj)
			end
		end

		-- Âm thanh jumpscare
		local sound = Instance.new("Sound", workspace)
		sound.SoundId = "rbxassetid://103879029437685"
		sound.Volume = 10
		sound:Play()

		-- A-60 đến sát người chơi
		primaryPart.Anchored = true
		entityModel.PrimaryPart = primaryPart

		local targetPos = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 10
		local moveTween = TweenService:Create(primaryPart, TweenInfo.new(0.2), {
			CFrame = CFrame.new(targetPos, camera.CFrame.Position)
		})
		moveTween:Play()
		moveTween.Completed:Wait()

		-----------------------------------
		-- 🚫 KHÓA DI CHUYỂN NGƯỜI CHƠI
		-----------------------------------
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		humanoid.PlatformStand = true


		-----------------------------------
		-- 📌 CAMERA BÁM THEO (NHƯ CŨ)
		-----------------------------------
		local camConn
		camConn = RunService.RenderStepped:Connect(function()
			-- Nếu người chơi trốn, hủy jumpscare
			if character:GetAttribute("Hiding") then
				if camConn then camConn:Disconnect() end
				camera.CameraType = Enum.CameraType.Custom

				for _, s in ipairs(allSounds) do
					if s and s.Parent then s:Play() end
				end

				primaryPart.Anchored = false
				return
			end

			-- Bám theo camera
			local desiredPos = camera.CFrame.Position + camera.CFrame.LookVector * 4
			primaryPart.CFrame = CFrame.new(desiredPos, camera.CFrame.Position)
			camera.CFrame = CFrame.lookAt(camera.CFrame.Position, primaryPart.Position)
		end)


		--------------------------------------------------------------------
		-- 😱 HIỆU ỨNG JUMPSCARE SAU 1 GIÂY (DISPLAY HÌNH ẢNH + TWEEN)
		--------------------------------------------------------------------
		task.wait(0.88)

		-- GUI cho jumpscare
		local gui = Instance.new("ScreenGui", player.PlayerGui)
		gui.IgnoreGuiInset = true
		gui.ResetOnSpawn = false

		local img = Instance.new("ImageLabel", gui)
		img.Image = "rbxassetid://16020415559"
		img.BackgroundTransparency = 1
		img.Size = UDim2.fromScale(0.8, 0.8)          -- nhỏ lúc đầu
		img.Position = UDim2.fromScale(0.1, 0.1)
		img.Rotation = 0
		img.ImageTransparency = 1                     -- bắt đầu ẩn

		-- Tween hiển thị + xoay + phóng to
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		local tween = TweenService:Create(img, tweenInfo, {
			ImageTransparency = 0,                    -- hiện lên
			Rotation = 20,                             -- xoay nhẹ sang phải
			Size = UDim2.fromScale(0.95, 0.95)         -- phóng to chút
		})

		tween:Play()
		tween.Completed:Wait()

		-- Sau tween, bạn có thể thêm hiệu ứng khác nếu muốn
		if camConn then camConn:Disconnect() end
		camera.CameraType = Enum.CameraType.Custom

		for _, s in ipairs(allSounds) do
			if s and s.Parent then s:Play() end
		end
		game.Players.LocalPlayer.Character.Humanoid.Health -= 1000
		game.ReplicatedStorage.GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Multi Monster"
		wait(2)
		gui:Destroy()
	end)
end)

-- ================== CHẠY ENTITY ==================
entity:Run()
