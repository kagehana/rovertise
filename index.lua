-- variables
local delay     = 1.5
local distance  = 1
local pservice  = game:GetService('Players')
local localp    = pservice.LocalPlayer
local character = localp.Character or localp.CharacterAdded:Wait()
local humanoid  = character:WaitForChild("Humanoid")
local rootPart  = character:WaitForChild("HumanoidRootPart")
local center    = rootPart.Position
local angle     = math.pi / 2
local url       = '/inflict'
local chars     = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local phrases   = {
    'fedK biteK join %s',
    'join %s if u get money',
    'hot girls in %s',
    'join %s for whitelist',
    'join %s if ur not broke',
    '%s over everything',
    'join %s we rock archive',
    'join %s for giveaways',
    '5k rbx giveaway %s'
}

-- containers
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

local function orbit()
    local plrs = game:GetService('Players'):GetPlayers()
    local plr  = plrs[math.random(#plrs)]

    coroutine.wrap(function()
        while wait() do
            local angular = tick() * angle
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
coroutine.wrap(function()
    while task.wait(3) do
        orbit()
    end
end)()

-- teleport bot to new server
coroutine.wrap(function()
    task.wait(10)

    print('TELEPORTING\nG\nG\nG\nG\nG\nG\nG\nG\nG\nG\nG')
    game:GetService('TeleportService'):Teleport(417267366)
end)()

-- advertise
while task.wait(delay) do
    local str = phrases[random(#phrases)]
    local adv = str:format(url) .. ' | ' .. gen(15)

    chat:FireServer(adv, "All")
    print('@ijustwantchanel & @lostmyarchive were here')
end
