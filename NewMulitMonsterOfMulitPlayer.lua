local Spawner = loadstring(game:HttpGet("https://github.com/ppG64tre-Cool/Entity-spawn/raw/main/init.luau"))()
local Communicator = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Communicator/main/init.luau"))()

-- \\ Services // --

local Players = game:GetService("Players")
local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- \\ Variables // --

local LocalPlayer = Players.LocalPlayer
local Host: Player? = Players:FindFirstChild("BUGc00lName")

local activeClients = {} :: {Player}
local running = false  -- Moved to module scope to fix scope issues

local function lerp(a,b,c)
	return a + (a - b) * c
end


--\\ Functions //--

local function SummonMulitMonster()

    local player = LocalPlayer
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
    		Enabled = false,
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
    
    -- ================== ON SPAWN ==================
    entity:SetCallback("OnSpawned", function()
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
    
    	running = true
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
    
    entity:SetCallback("OnDespawning", function()
    		running = false

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
    
    		-- Tắt tất cả âm thanh tạm thời
    		local allSounds = {}
    		for _, obj in ipairs(game:GetDescendants()) do
    			if obj:IsA("Sound") and obj.IsPlaying then
    				obj:Stop()
    				table.insert(allSounds, obj)
    			end
    		end
    
    		-- Âm thanh jumpscare
    		local playerGui = player:WaitForChild("PlayerGui")
    		local sound = Instance.new("Sound", playerGui)
    		sound.SoundId = "rbxassetid://132942725846535"
    		sound.Volume = 10
    		sound:Play()
    
    		-- A-60 đến sát người chơi
    		primaryPart.Anchored = true
    		entityModel.PrimaryPart = primaryPart
    
    		local targetPos = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 10
    		
    		
    
    		-- CAMERA BÁM THEO
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
			primaryPart.CFrame = primaryPart.CFrame:Lerp(CFrame.new(desiredPos),0.5)
			--camera.CFrame = CFrame.lookAt(camera.CFrame.Position, primaryPart.Position)
		end)


		--------------------------------------------------------------------
		-- 😱 HIỆU ỨNG JUMPSCARE SAU 1 GIÂY (DISPLAY HÌNH ẢNH + TWEEN)
		--------------------------------------------------------------------
		task.wait(1.08)
            if not character:GetAttribute("Hiding") then
    		    if not injumpscare then return end
    		local gui = Instance.new("ScreenGui", player.PlayerGui)
    		gui.IgnoreGuiInset = true
    		gui.ResetOnSpawn = false
    		gui.DisplayOrder = -9999
    
    		local img = Instance.new("ImageLabel", gui)
    		local rng = Random.new()
            img.Image = faces[rng:NextInteger(1,#faces)]
    		img.BackgroundTransparency = 1
    		img.Size = UDim2.fromScale(0.35, 0.35)
    		img.Position = UDim2.fromScale(0.325, 0.325)
    		img.Rotation = 0
            img.ImageColor3 = Color3.fromRGB(10, 10, 10)
    	    img.ScaleType = Enum.ScaleType.Fit
    		img.ImageTransparency = 1
    
    		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    		local tween = TweenService:Create(img, tweenInfo, {
    			ImageTransparency = 0.25,
    			Rotation = Random.new():NextNumber(-25,25),
    			Size = UDim2.fromScale(2, 2),
    			Position = UDim2.fromScale(-0.5 + Random.new():NextNumber(-0.085,0.085), -0.5 + Random.new():NextNumber(-0.085,0.085))
    		})
    
    		tween:Play()
    		tween.Completed:Wait()
    
    		if camConn then camConn:Disconnect() end
    		camera.CameraType = Enum.CameraType.Custom
    
    		for _, s in ipairs(allSounds) do
    			if s and s.Parent then s:Play() end
    		end
    		game.Players.LocalPlayer.Character.Humanoid.Health -= 1000
    		game.ReplicatedStorage.GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Multi Monster"
        Communicator:Send("BurnSkin")
    
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
    		task.wait(2)
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
    entity:Run()
end


-- \\ Setup // --

Communicator.Config.ExcludeSelf = false

task.spawn(function()
    while true do
        activeClients = Communicator:Ping(1, true)
        
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


Communicator:Listen("SpawnEntity", function(sender: Player, Name: string)
    if sender ~= Host then
        return
    end

    SummonMulitMonster()
end)

Communicator:Listen("BurnSkin", function(sender: Player)
	local targetPlayer = Players:FindFirstChild(sender.Name)
	if not targetPlayer or not targetPlayer.Character then return end
	
	local character = targetPlayer.Character

	for _, cls in ipairs({"Shirt", "ShirtGraphic", "Pants"}) do
		local obj = character:FindFirstChildOfClass(cls)
		if obj then pcall(function() obj:Destroy() end) end
	end

	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			for _, child in ipairs(part:GetChildren()) do
				if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceAppearance") then
					pcall(function() child:Destroy() end)
				elseif child:IsA("SpecialMesh") or child:IsA("Mesh") then
					pcall(function() child.TextureId = "" end)
					pcall(function() child.VertexColor = Vector3.new(1,1,1) end)
				end
			end

			pcall(function() part.TextureID = "" end)
			pcall(function() part:SetAttribute("OriginalTexture", nil) end)

			pcall(function()
				part.Material = Enum.Material.CrackedLava
				part.Color = Color3.fromRGB(255, 85, 0)
			end)

			for _, child in ipairs(part:GetChildren()) do
				if child:IsA("SurfaceGui") then
					pcall(function() child:Destroy() end)
				end
			end
		end
	end
	
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			if not part:FindFirstChild("LavaAttachment") then
				local attachment = Instance.new("Attachment", part)
				attachment.Name = "LavaAttachment"
				
				local lava = Instance.new("ParticleEmitter", attachment)
				lava.Texture = "rbxasset://textures/particles/fire_main.png"
				lava.Rate = 40
				lava.Lifetime = NumberRange.new(1.2, 2.0)
				lava.Speed = NumberRange.new(6, 10)
				lava.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 140, 0)),
					ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 0)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 0))
				})
				lava.Size = NumberSequence.new(0.6, 0.2)
				lava.Transparency = NumberRange.new(0.2, 0.9)
				lava.Drag = 4
				lava.Rotation = NumberRange.new(0, 360)
				lava.RotSpeed = NumberRange.new(-40, 40)
				
				task.delay(6, function()
					if lava and lava.Parent then
						lava.Enabled = false
						task.delay(3, function()
							if attachment and attachment.Parent then
								attachment:Destroy()
							end
						end)
					end
				end)
			end
		end
	end
end)

-- \\ Main // --

if LocalPlayer == Host then
    -- \\ MOBILE-FRIENDLY HOST GUI SETUP // --
    
    local gui_spawner = LocalPlayer:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui", gui_spawner)
    screenGui.Name = "SpawnControlGui"
    screenGui.ResetOnSpawn = false
    screenGui.Enabled = false
    
    -- Main Container Frame
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 240, 0, 170)
    mainFrame.Position = UDim2.new(0.5, -120, 0.3, 0) -- Centered on screen for better touch reach
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    mainFrame.Visible = true
    
    local uiCornerFrame = Instance.new("UICorner", mainFrame)
    uiCornerFrame.CornerRadius = UDim.new(0, 10)

    -- Floating Mobile Toggle Button (Draggable)
    local toggleButton = Instance.new("TextButton", screenGui)
    toggleButton.Name = "MobileToggle"
    toggleButton.Size = UDim2.new(0, 50, 0, 50) -- Large touch target for thumbs
    toggleButton.Position = UDim2.new(0.05, 0, 0.3, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    toggleButton.BorderSizePixel = 2
    toggleButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
    toggleButton.Text = "MENU"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 11
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Active = true

    local uiCornerBtn = Instance.new("UICorner", toggleButton)
    uiCornerBtn.CornerRadius = UDim.new(0.5, 0) -- Circular floating button

    -- Dragging Logic for Mobile Touch
    local dragging = false
    local dragStart = Vector3.new()
    local startPos = UDim2.new()
    local hasMoved = false

    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = toggleButton.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 6 then
                hasMoved = true
            end
            toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Open/Close Panel on Touch Tap (only if not dragging)
    toggleButton.Activated:Connect(function()
        if not hasMoved then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    -- Title Label
    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "🔴 SPAWN CONTROL"
    titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    titleLabel.TextSize = 15
    titleLabel.Font = Enum.Font.GothamBold

    local uiCornerTitle = Instance.new("UICorner", titleLabel)
    uiCornerTitle.CornerRadius = UDim.new(0, 10)

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
    spawnButton.Position = UDim2.new(0.05, 0, 0, 80)
    spawnButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    spawnButton.BorderSizePixel = 0
    spawnButton.Text = "SPAWN ENTITY"
    spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    spawnButton.TextSize = 14
    spawnButton.Font = Enum.Font.GothamBold

    local uiCornerSpawn = Instance.new("UICorner", spawnButton)
    uiCornerSpawn.CornerRadius = UDim.new(0, 8)

    spawnButton.Activated:Connect(function()
    	if LocalPlayer == Host then
    		Communicator:Send("SpawnEntity", 1)
    		print("✓ Spawning entity...")
    		
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
    			statusLabel.Text = "✓ YOU ARE Host"
    			statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    		end
    	end
    end)
end
