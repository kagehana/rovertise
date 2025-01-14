-- variables
local delay     = 2.5
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
      'join %s if u get money',
      'hot girls in %s',
      'join %s for whitelist',
      'join %s for nitro',
      'join %s if ur not broke',
      '%s over everything',
      'free nitro in %s'
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

-- process
coroutine.wrap(function()
    while task.wait(1) do
        orbit()
    end
end)()

while task.wait(delay) do
    local str = phrases[random(#phrases)]
    local adv = str:format(url) .. ' | ' .. gen(15)

    chat:FireServer(adv, "All")
    print('@ijustwantchanel & @lostmyarchive were here')
end
