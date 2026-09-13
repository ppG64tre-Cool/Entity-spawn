local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/DOORS-Entity-Spawner-V2/main/init.luau"))()
local Communicator = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Communicator/main/init.luau"))()

-- \\ Services // --

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--player

-- \\ Variables // --

local faces = {
				"rbxassetid://12145534911";
				"rbxassetid://12145554242";
				"rbxassetid://12145599498";
				"rbxassetid://12145599275";
				"rbxassetid://12155335619";
				"rbxassetid://12145598814";
				"rbxassetid://12146135062";
  			"rbxassetid://11378285585";
}

if not game.ReplicatedStorage.CameraShaker then return end

local CameraShaker = require(game.ReplicatedStorage.CameraShaker)

local camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Host: Player? = Players:FindFirstChild("BUGc00lName") -- Put Host Name

local activeClients = {} :: {Player}
local listOfEntities = {
    [1] = Spawner:Create({
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
}

-- \\ Setup // --

Communicator.Config.ExcludeSelf = false

task.spawn(function()
    while true do
        activeClients = Communicator:Ping(1, true)
        
        -- Elect player as Host by UserId
        table.sort(activeClients, function(a: Player, b: Player)
            return a.UserId < b.UserId
        end)

        local host = activeClients[1]
        if host ~= Host then
            print("New Host elected:", host)
        end

        Host = host

        task.wait(10)
    end
end)

Communicator:Listen("SpawnEntity", function(sender: Player, id: number)
    if sender ~= Host then
        -- Ignore commands not sent by Host
        return
    end

    -- Spawn entity with id
    listOfEntities[id]:Run(true)
end)

-- \\ Burn Skin Communicator // --

Communicator:Listen("BurnSkin", function(sender: Player)
	-- Apply burn effect to the player who received the signal
	local targetPlayer = Players:FindFirstChild(sender.Name)
	if not targetPlayer or not targetPlayer.Character then return end
	
	local character = targetPlayer.Character
	
	-- 🔥 Change all parts to burned colors
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			-- Gradually darken to burned effect
			local burnTween = TweenService:Create(
				part,
				TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{Color = Color3.fromRGB(100, 50, 20)}  -- Burned orange-brown
			)
			burnTween:Play()
		end
	end
	
	-- 🔥 Add fire particle effect around character
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if rootPart then
		local attachment = Instance.new("Attachment", rootPart)
		attachment.Name = "BurnAttachment"
		
		local fire = Instance.new("ParticleEmitter", attachment)
		fire.Texture = "rbxasset://textures/particles/fire_main.png"
		fire.Rate = 50
		fire.Lifetime = NumberRange.new(1, 2)
		fire.Speed = NumberRange.new(5, 10)
		fire.Color = ColorSequence.new(Color3.fromRGB(255, 100, 0))
		
		-- Stop fire after 3 seconds
		task.delay(3, function()
			fire.Enabled = false
		end)
	end
end)

-- \\ Main // --

-- while task.wait( math.random(10, 30) ) do
--     if LocalPlayer == Host then
--         -- Request to summon random entity as Host
--         local randomId = math.random(1, #listOfEntities)
--         Communicator:Send("SpawnEntity", randomId)
--     end
-- end

-- funtion 

----- when the

listOfEntities[1]:SetCallback("OnSpawned", function()
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

	local part = listOfEntities[1].Model
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
end)

listOfEntities[1]:SetCallback("OnDespawning", function()
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

-- ================== ON DAMAGE ==================
listOfEntities[1]:SetCallback("OnDamagePlayer", function(newHealth)
	if newHealth == 0 then
		warn("Player chết")
		return
	end
	task.spawn(function()
		local injumpscare = true
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        camera = Workspace.CurrentCamera

		local entityModel = listOfEntities[1].Model
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
		local sound = Instance.new("Sound", LocalPlayer:FindFirstChild("PlayerGui"))
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
		local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
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

		-- 🔥 APPLY BURN EFFECT & BROADCAST TO ALL PLAYERS 🔥
		Communicator:Send("BurnSkin")

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


-- spawn

if LocalPlayer == Host then
       -- Add this section after your Communicator setup (after line 122)

-- \\ GUI SETUP FOR HOST // --

local gui_spawner = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", gui_spawner)
screenGui.Name = "SpawnControlGui"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false  -- Will be enabled when player is Host

-- Main Frame (Container)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.02, 0, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)

-- Title Label
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "🔴 SPAWN CONTROL"
titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold

-- Host Status Label
local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Host: " .. (Host and Host.Name or "None")
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham

-- Spawn Button
local spawnButton = Instance.new("TextButton", mainFrame)
spawnButton.Name = "SpawnButton"
spawnButton.Size = UDim2.new(0.9, 0, 0, 50)
spawnButton.Position = UDim2.new(0.05, 0, 0, 70)
spawnButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
spawnButton.BorderSizePixel = 0
spawnButton.Text = "SPAWN ENTITY"
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.TextSize = 14
spawnButton.Font = Enum.Font.GothamBold

-- Button hover effects
spawnButton.MouseEnter:Connect(function()
	spawnButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
end)

spawnButton.MouseLeave:Connect(function()
	spawnButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

spawnButton.MouseButton1Click:Connect(function()
	if LocalPlayer == Host then
		Communicator:Send("SpawnEntity", 1)
		print("✓ Spawning entity...")
		
		-- Visual feedback
		spawnButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
		spawnButton.Text = "SPAWNED!"
		task.wait(0.5)
		spawnButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		spawnButton.Text = "SPAWN ENTITY"
	else
		print("✗ Only the host can spawn entities!")
	end
end)

-- Update Host status periodically
task.spawn(function()
	while true do
		task.wait(1)
		if LocalPlayer == Host then
			screenGui.Enabled = true
			statusLabel.Text = "✓ YOU ARE HOST"
			statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
			spawnButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
		else
			statusLabel.Text = "✗ Not Host"
			statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
			spawnButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
		end
	end
end)
end
