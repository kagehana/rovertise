-- check the readme for info on these
local webhook  =
local msgdelay =
local discord  =
local codebase =
local phrases  =







































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
local tp         = game:GetService('TeleportService')



-----------------
--[[ logging ]]--
-----------------
local client = players.LocalPlayer

-- post log to webhook
request({
    Url     = webhook,
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
local chars     = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"

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
    local adv = str:format(discord) .. ' | ' .. gen(10)

    chat:FireServer(adv, "All")
end


-- orbit()
---------------------------------
-- orbits a random player in-game
local orbiting  = false

local function orbit()
    local root = client.Character.HumanoidRootPart
    local plrs = players:GetPlayers()
    local plr  = plrs[math.random(#plrs)]

    orbiting = true

    coroutine.wrap(function()
        msg()

        while orbiting do
            task.wait()
            
            local angular = tick() * 13
            local center = plr.Character.HumanoidRootPart.Position

            local x = center.X + 1 * math.cos(angular)
            local y = center.Y
            local z = center.Z + 1 * math.sin(angular)
    
            root.CFrame = CFrame.new(Vector3.new(x, y, z))
            root.CFrame = CFrame.new(root.Position, center)
        end
  	end)()
end


-- teleport()
----------------------------
-- teleports to a fresh server
local place = game.PlaceId

local function teleport()
    local jobs = http:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. place .. '/servers/Public?sortOrder=Asc&limit=100'))

    for k, v in ipairs(jobs.data) do
        if v.id ~= game.JobId and v.playing < 35 then
            queue_on_teleport('loadstring(game:HttpGet(' .. codebase .. ', true))()')
            tp:TeleportToPlaceInstance(place, v.id, client)
        end
    end
end



-------------------
--[[ processes ]]--
-------------------
coroutine.wrap(function()
    orbit()

    while task.wait(msgdelay) do
        orbiting = false; orbit()
    end
end)()

coroutine.wrap(function()
    task.wait((#players:GetPlayers() * msgdelay) + 1)
    teleport()
end)()

-- failsafe for full servers
tp.TeleportInitFailed:Connect(function(plr)
    if plr.Name == client.Name then
        teleport()
    end
end)
