-- Import spawner

local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/DOORS-Entity-Spawner-V2/main/init.luau"))()
local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local faces = {
				"rbxassetid://12145534911",
				"rbxassetid://12145554242",
				"rbxassetid://12145599498",
				"rbxassetid://12145599275",
				"rbxassetid://12155335619",
				"rbxassetid://12145598814",
				"rbxassetid://12146135062",
				"rbxassetid://11378285585"
}

local entity = Spawner:Create({
	Entity = {
		Name = "A60",
		Asset = "https://github.com/ppG64tre-Cool/Entity-spawn/raw/main/ReModelA60HC.rbxm",
		HeightOffset = 1
	},
	Lights = {
		Flicker = {
			Enabled = false,
			Duration = 1
		},
		Shatter = false,
		Repair = false
	},
	Earthquake = {
		Enabled = true
	},
	CameraShake = {
		Enabled = true,
		Range = 135,
		Values = {20, 30, 0.1, 0.1} -- Magnitude, Roughness, FadeIn, FadeOut
	},
	Movement = {
		Speed = 275,
		Delay = 7.5,
		Reversed = false
	},
	Rebounding = {
		Enabled = true,
		Type = "Ambush", -- "Blitz"
		Min = 3,
		Max = 10,
		Delay = 0.5
	},
	Damage = {
		Enabled = true,
		IgnoreHiding = false,
		Range = 100,
		Amount = 0
	},
	Crucifixion = {
        Type = "Guiding",
		Enabled = true,
		Range = math.huge,
		Resist = true,
		Break = false
	},
	Death = {
		Type = "Curious", -- "Curious"
		Hints = {"Death", "Hints", "Go", "Here"},
		Cause = ""
	}
})

-- local entity = spawner.Create({
-- 	Entity = {
-- 		Name = "A60",
-- 		Asset = "https://github.com/ppG64tre-Cool/Entity-spawn/blob/main/ReModelA60HC.rbxm?raw=true",
-- 		HeightOffset = 1
-- 	},
-- 	Lights = {
-- 		Flicker = {Enabled = false, Duration = 10},
-- 		Shatter = false,
-- 		Repair = false
-- 	},
-- 	Earthquake = {Enabled = true},
-- 	CameraShake = {
-- 		Enabled = true,
-- 		Range = 100,
-- 		Values = {20, 30, 0.1, 0.1}
-- 	},
-- 	Movement = {
-- 		Speed = 300,
-- 		Delay = 8,
-- 		Reversed = false
-- 	},
-- 	Rebounding = {
-- 		Enabled = true,
-- 		Type = "Ambush",
-- 		Min = 4,
-- 		Max = 10,
-- 		Delay = 0.5
-- 	},
-- 	Damage = {
-- 		Enabled = true,
-- 		Range = 100,
-- 		Amount = 0
-- 	},
-- 	Crucifixion = {
-- 		Enabled = true,
-- 		Range = math.huge,
-- 		Resist = true,
-- 		Break = true
-- 	},
-- 	Death = {
-- 		Type = "Guiding",
-- 		Hints = {"Death", "Hints", "Go", "Here"},
-- 		Cause = ""
-- 	}
-- })

-- Hiệu ứng ánh sáng

-- ================== ON SPAWN ==================
entity:SetCallback("OnSpawned", function()
	pcall(function()
        local lighting = game.Lighting
		lighting.MainColorCorrection.TintColor = Color3.fromRGB(255, 0, 0)
	    lighting.MainColorCorrection.Contrast = 0.2
	    TweenService:Create(lighting.MainColorCorrection, TweenInfo.new(2.5), {Contrast = 0}):Play()
	TweenService:Create(lighting.MainColorCorrection, TweenInfo.new(20), {TintColor = Color3.fromRGB(255, 255, 255)}):Play()

	-- Camera Shake
	local camara = game.Workspace.CurrentCamera
	local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
		camara.CFrame = camara.CFrame * shakeCf
	end)
	camShake:Start()
	camShake:ShakeOnce(40,70,0,4,2,12)
	
	local camShake2 = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(cf)
		camara.CFrame = camara.CFrame * cf
	end)
	camShake2:Start()
	camShake2:Shake(CameraShaker.Presets.Earthquake)
				
	end)

	local part = entity.Model
	local object = part:WaitForChild("RushNew")
	local attachment = object:WaitForChild("Main")
	local emitter = attachment:FindFirstChildWhichIsA("ParticleEmitter")
	local ambiencesound = part:WaitForChild("AmbienceSounds")
	for _,sounds in pairs(part:GetDescendants()) do
		if sounds:IsA("Sound") and sounds:IsDescendantOf(ambiencesound) then
			sounds.Volume = 0
	    end
	end

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
			local t = TweenService:Create(game.Lighting.MainColorCorrection, TweenInfo.new(tint.Time), {TintColor = tint.Color})
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
		local injumpscare = true
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        camera = Workspace.CurrentCamera

		local entityModel = entity.Model
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
		local sound = Instance.new("Sound", player:FindFirstChild("PlayerGui"))
		sound.SoundId = "rbxassetid://132942725846535"
		sound.Volume = 10
		sound:Play()

		-- A-60 đến sát người chơi
		primaryPart.Anchored = true
		entityModel.PrimaryPart = primaryPart

		local targetPos = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 10
		local moveTween = TweenService:Create(primaryPart, TweenInfo.new(0.2), {
			CFrame = CFrame.new(targetPos)
		})
		moveTween:Play()
		moveTween.Completed:Wait()

		-----------------------------------
		-- 🚫 KHÓA DI CHUYỂN NGƯỜI CHƠI
		-----------------------------------
		--humanoid.WalkSpeed = 0
		--humanoid.JumpPower = 0
		--humanoid.PlatformStand = true


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

				injumpscare = false

                if sound ~= nil and sound:IsA("Sound") then
					sound:Stop()
				    sound:Destroy()
				end		

			    return
			end

			-- Bám theo camera
			local desiredPos = camera.CFrame.Position + camera.CFrame.LookVector * 4
			primaryPart.CFrame = CFrame.new(desiredPos)
			camera.CFrame = CFrame.lookAt(camera.CFrame.Position, primaryPart.Position)
		end)


		--------------------------------------------------------------------
		-- 😱 HIỆU ỨNG JUMPSCARE SAU 1 GIÂY (DISPLAY HÌNH ẢNH + TWEEN)
		--------------------------------------------------------------------
		task.wait(0.88)
        if not character:GetAttribute("Hiding") then
		    if not injumpscare then return end
			-- GUI cho jumpscare
		local gui = Instance.new("ScreenGui", player.PlayerGui)
		gui.IgnoreGuiInset = true
		gui.ResetOnSpawn = false
		gui.DisplayOrder = -9999

		local img = Instance.new("ImageLabel", gui)
		local rng = Random.new()
        img.Image = faces[rng:NextInteger(1,#faces)]
		img.BackgroundTransparency = 1
		img.Size = UDim2.fromScale(0.35, 0.35)          -- nhỏ lúc đầu
		img.Position = UDim2.fromScale(0.325, 0.325)
		img.Rotation = 0
        img.ImageColor3 = Color3.fromRGB(10, 10, 10)
	    img.ScaleType = Enum.ScaleType.Fit
		img.ImageTransparency = 1                     -- bắt đầu ẩn

		-- Tween hiển thị + xoay + phóng to
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		local tween = TweenService:Create(img, tweenInfo, {
			ImageTransparency = 0.25,                    -- hiện lên
			Rotation = Random.new():NextNumber(-25,25),                             -- xoay nhẹ sang phải
			Size = UDim2.fromScale(2, 2),         -- phóng to chút
			Position = UDim2.fromScale(-0.5 + Random.new():NextNumber(-0.085,0.085), -0.5 + Random.new():NextNumber(-0.085,0.085))
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
		-- This code was generated by Cobalt
-- https://github.com/notpoiu/cobalt

        if game:GetService("ReplicatedStorage").RemotesFolder.DeathHint then
			local Event = game:GetService("ReplicatedStorage").RemotesFolder.DeathHint
            firesignal(Event.OnClientEvent, 
             {
        "That One Is Multi Monster.";
		"A60 But i never seen him before, how did you encounter him?";				
		"it not instanty kill.";
		"just dont make it too late.";
		"See You Next.";
           },
    "Yellow"
						)
		end
		wait(2)
		gui:Destroy()
	    task.delay(15, function()
				if sound ~= nil and sound:IsA("Sound") then
					sound:Stop()
				    sound:Destroy()
				end		
		end)
		end
	end)
end)

-- ================== CHẠY ENTITY ==================
entity:Run(true)
