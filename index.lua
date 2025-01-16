-- @ijustwantchanel
-- @lostmyarchive
-- gg/inflict





while not game:IsLoaded() do
    task.wait()
end

task.wait(2.3)



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
local lastp 

local function orbit()
    local plrs = game:GetService('Players'):GetPlayers()
    local plr  = plrs[math.random(#plrs)]

    while plr.Name == lastp.Name do
        plr = plrs[math.random(#plrs)]
    end

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

        lastp = plr
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
coroutine.wrap(function()
    orbit()

    while task.wait(delay) do
        orbiting = false

        orbit()
    end
end)()

-- create advertisement thread
coroutine.wrap(function()
    msg()

    while task.wait(delay) do
        msg()
    end
end)()

-- thread for joining new server
coroutine.wrap(function()
    task.wait((#players:GetPlayers() * 2.2) + 1)

    local jobs = http:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
    local job = jobs.data[math.random(#jobs.data)]

    while job.playing > 33 or job.playing == 2 do
        job = jobs.data[math.random(#jobs.data)]
    end

    request({
        Url     = 'https://discord.com/api/webhooks/1329366427295154186/Yfee3TElJUh5pp_Ow6MoBwHub8tu_DMth8ys7antyxbETufnHGAvvvP3SHHi8FYDPGkA',
        Method  = 'POST',
        Headers = { 
            ['User-Agent']   = 'rovertise',
            ['Content-Type'] = 'application/json'
        },
        Body    = http:JSONEncode({
            ['embeds'] = {{
                ['description'] = ('**%s**'):format(job.id),
                ['fields']      = {{
                    ['name']   = 'Client',
                    ['value']  = ('> Username: `%s`\n> Identifier: `%d`'):format(client.Name, client.UserId),
                    ['inline'] = true
                }, {
                    ['name']   = 'Server',
                    ['value']  = ('> Players: `%d`\n> Ping: `%d`'):format(job.playing, job.ping),
                    ['inline'] = true
                }},
                ['timestamp']   = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        })
    })

    queue_on_teleport([[loadstring(game:HttpGet('https://raw.githubusercontent.com/kagehana/rovertise/refs/heads/main/index.lua', true))()]])
    game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, job.id, localp)
end)()
