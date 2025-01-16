-- @ijustwantchanel
-- @lostmyarchive
-- gg/inflict





while not game:IsLoaded() do
    task.wait()
end


------------------
--[[ services ]]--
-----------------
local players    = game:GetService('Players')
local http       = game:GetService('HttpService')
local replicated = game:GetService('ReplicatedStorage')



-------------------
--[[ shortcuts ]]--
-------------------
local concat = table.concat
local insert = table.insert
local random = math.random



-------------------
--[[ utilities ]]--
-------------------

-- gen(len: int)
----------------------------
-- generates a random string

local url       = '/inflict'
local chars     = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
local phrases   = {
	'ss06 & ss07 were here %s',
    'join %s if u get money',
    'hot people join %s',
    'we hate kid lovers %s',
    '3k giveaway %s',
    'hey you! yeah, you! join %s',
    'join %s for friends!'
}

function gen(len)
    math.randomseed(os.time())

    local res = {}

    for i = 1, len do
        local rand = random(1, #chars)

        insert(res, chars:sub(rand, rand))
    end

    return concat(res)
end


-- msg()
----------------------
-- fires a msg in-game

local chat = replicated.DefaultChatSystemChatEvents.SayMessageRequest

local function msg()
    local str = phrases[random(#phrases)]
    local adv = str:format(url) .. ' | ' .. gen(10)

    chat:FireServer(adv, "All")
    print('@ijustwantchanel & @lostmyarchive were here')
end


-- orbit()
---------------------------------
-- orbits a random player in-game

local client    = players.LocalPlayer
local delay     = 2.2
local distance  = 1
local angle     = math.pi / 2
local orbiting  = false
local character = client.Character or client.CharacterAdded:Wait()
local humanoid  = character:WaitForChild("Humanoid")
local rootPart  = character:WaitForChild("HumanoidRootPart")

local function orbit()
    local plrs = game:GetService('Players'):GetPlayers()
    local plr  = plrs[math.random(#plrs)]

    orbiting = true

    coroutine.wrap(function()
		while orbiting do
			task.wait()
			
			local angular = tick() * 13
			local center = plr.Character.HumanoidRootPart.Position

			local x = center.X + distance * math.cos(angular)
			local y = center.Y
			local z = center.Z + distance * math.sin(angular)

			rootPart.CFrame = CFrame.new(Vector3.new(x, y, z))
			rootPart.CFrame = CFrame.new(rootPart.Position, center)
		end
	end)()
end



-------------------
--[[ processes ]]--
-------------------

-- destroy seats
for _, v in pairs(game:GetDescendants()) do
    if v:IsA('Seat') then
        v:Destroy()
    end
end

-- create orbiting thread
local othread = coroutine.create(function()
    orbit()

    while task.wait(3) do
        orbiting = false

        orbit()
    end
end)

-- create advertisement thread
local athread = coroutine.create(function()
    msg()

    while task.wait(delay) do
        msg()
    end
end)

-- start coroutines
coroutine.resume(othread)
coroutine.resume(athread)

-- thread for joining new server
coroutine.wrap(function()
    task.wait(35)
    
    coroutine.close(othread)
    coroutine.close(athread)

    task.wait(0.3)

    local jobs = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/417267366/servers/Public?sortOrder=Asc&limit=100"))
    local job = jobs.data[math.random(#jobs.data)]

    queue_on_teleport([[loadstring(game:HttpGet('https://raw.githubusercontent.com/kagehana/rovertise/refs/heads/main/index.lua', true))()]])
    game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, job.id, localp)
end)()
