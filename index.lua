-- @asfdajshf
-- @lostmyarchive
-- gg/inflict




-- wait until game is loaded
while not game:IsLoaded() do
    task.wait()
end

-- wait a bit more as a failsafe
task.wait(1.5)

-- delete all seats to prevent disruption
for _, v in pairs(game:GetDescendants()) do
    if v:IsA('Seat') then
        v:Destroy()
    end
end


------------------
--[[ services ]]--
------------------
local players    = game:GetService('Players')
local http       = game:GetService('HttpService')
local replicated = game:GetService('ReplicatedStorage')



-----------------
--[[ logging ]]--
-----------------
local client = players.LocalPlayer

request({
    Url     = 'https://discord.com/api/webhooks/1329366427295154186/Yfee3TElJUh5pp_Ow6MoBwHub8tu_DMth8ys7antyxbETufnHGAvvvP3SHHi8FYDPGkA',
    Method  = 'POST',
    Headers = { 
        ['User-Agent']   = 'rovertise',
        ['Content-Type'] = 'application/json'
    },
    Body    = http:JSONEncode({
        ['embeds'] = {{
            ['description'] = ('**%s**'):format(game.JobId),
            ['fields']      = {{
                ['name']   = 'Client',
                ['value']  = ('> Username: `%s`\n> Identifier: `%d`'):format(client.Name, client.UserId),
                ['inline'] = true
            }, {
                ['name']   = 'Server',
                ['value']  = ('> Players: `%d`\n> Ping: `%d`'):format(#players:GetPlayers(), (client:GetNetworkPing() * 1000)),
                ['inline'] = true
            }},
            ['timestamp']   = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    })
})



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
    	'hot people join %s',
    	'nitro giveaway %s',
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

local function msg(targ)
    local str = phrases[random(#phrases)]
    local adv = str:format(url) .. ' | ' .. gen(10)

    if adv:find('%%s') then
        adv = adv:format(targ.DisplayName)
    end

    chat:FireServer(adv, "All")
end


-- orbit()
---------------------------------
-- orbits a random player in-game

local delay     = 2.15
local distance  = 1
local angle     = math.pi / 2
local orbiting  = false
local lastpn    = client

local function orbit()
    local character = client.Character or client.CharacterAdded:Wait()
    local humanoid  = character:WaitForChild("Humanoid")
    local rootPart  = character:WaitForChild("HumanoidRootPart")
    local plrs = game:GetService('Players'):GetPlayers()
    local plr  = plrs[math.random(#plrs)]

    print(lastpn, plr.Name)

    while (plr.Name == lastpn) or (plr.Name == client.Name) do
        plr = plrs[math.random(#plrs)]
    end
    
    lastpn   = plr.Name
    orbiting = true

    coroutine.wrap(function()
        task.wait(0.15)

        msg(targ)

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


-- teleport()
----------------------------
-- teleports to a new server

local function teleport(jid)
    game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, jid, client)
end


-- transport()
----------------------------
-- initiates a server-change

local function transport()
    local jobs = http:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
    local job = jobs.data[math.random(#jobs.data)]

    queue_on_teleport([[loadstring(game:HttpGet('https://raw.githubusercontent.com/kagehana/rovertise/refs/heads/main/index.lua', true))()]])
    
    local success = pcall(function() teleport(job.id) end)

    while (not success) or job.id == game.JobId do
        
        job = jobs.data[math.random(#jobs.data)]
        
        task.wait(0.5)

        success = pcall(function() teleport(job.id) end)
    end
end



-------------------
--[[ processes ]]--
-------------------

-- create orbiting thread
coroutine.wrap(function()
    orbit()

    while task.wait(delay) do
        orbiting = false

        orbit()
    end
end)()

-- thread for joining new server
coroutine.wrap(function()
    task.wait((#players:GetPlayers() * 2.2) + 1)

    transport()
end)()
