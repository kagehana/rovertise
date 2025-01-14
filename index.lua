-- variables
local delay     = 2.2
local distance  = 1
local pservice  = game:GetService('Players')
local localp    = pservice.LocalPlayer
local character = localp.Character or localp.CharacterAdded:Wait()
local humanoid  = character:WaitForChild("Humanoid")
local rootPart  = character:WaitForChild("HumanoidRootPart")
local center    = rootPart.Position
local angle     = math.pi / 2
local orbiting  = false
local url       = '/inflict'
local chars     = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
local phrases   = {
    'join %s if u get money',
    'hot people in %s',
    'we hate kid lovers %s',
    'kilex is a swatted, kid loving loser %s',
    'join %s we rock archive',
    '5k giveaway %s'
}

-- containers
local HttpService = game:getService('HttpService')
local chat = game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest

-- shortcuts
local concat = table.concat
local insert = table.insert
local random = math.random

-- functions
function gen(len)
    math.randomseed(os.time())

    local res = {}

    for i = 1, len do
        local rand = random(1, #chars)

        insert(res, chars:sub(rand, rand))
    end

    return concat(res)
end

local function msg()
    local str = phrases[random(#phrases)]
    local adv = str:format(url) .. ' | ' .. gen(10)

    print(adv)

    chat:FireServer(adv, "All")
    print('@ijustwantchanel & @lostmyarchive were here')
end

local function orbit()
    local plrs = game:GetService('Players'):GetPlayers()
    local plr  = plrs[math.random(#plrs)]

    orbiting = true

    coroutine.wrap(function()
		while orbiting do
			task.wait()
			
			local angular = tick() * 1
			local center = plr.Character.HumanoidRootPart.Position

			local x = center.X + distance * math.cos(angular)
			local y = center.Y
			local z = center.Z + distance * math.sin(angular)

			rootPart.CFrame = CFrame.new(Vector3.new(x, y, z))
			rootPart.CFrame = CFrame.new(rootPart.Position, center)
		end
	end)()
end

-- remove seats
for _, v in pairs(game:GetDescendants()) do
    if v:IsA('Seat') then
        v:Destroy()
    end
end

-- orbit players
local oc = coroutine.create(function()
    orbit()

    while task.wait(3) do
        orbiting = false

        orbit()
    end
end)

-- advertise
local ac = coroutine.create(function()
    msg()

    while task.wait(delay) do
        msg()
    end
end)

coroutine.resume(ac)
coroutine.resume(oc)

-- teleport bot to new server
coroutine.wrap(function()
    task.wait(35)
    
    coroutine.close(oc)
    coroutine.close(ac)

    task.wait(0.3)

    local jobs = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/417267366/servers/Public?sortOrder=Asc&limit=100"))
    local job = jobs.data[math.random(#jobs.data)]

    game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, job.id, localp)
end)()
