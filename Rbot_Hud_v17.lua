-- ============================================================
-- Rbot Hud  + Auto Farm Bone
--  ()  6  ""
--  Auto Farm  /  2 /
-- ============================================================
local Players      = game:GetService("Players")
local RS           = game:GetService("ReplicatedStorage")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer
local playerGui = lp:WaitForChild("PlayerGui")
local MAX_SPEED = 300

local CONFIG = {
    -- Combat
    Range         = 5000,
    HeightAbove   = 20,   --  (  UI)

    --
    GatherMobs     = true,
    GatherCount    = 12,    --
    GatherRadius   = 300,   --  (studs )
    GatherInterval = 0.12,  --
    GatherHitRange = 60,    --  studs (/  )
    WaitHeight    = 30,  --  (studs )
    CircleRadius  = 3,
    CircleSpeed   = 2,
    FlySpeedMul   = 3,
    AttackVal     = 0.40000000596046448, --  (Cobalt: RegisterAttack 0.40000000596046448, 1)
    AttackVal2    = 1,
    UseCapturedAttack = true, -- true =  RegisterAttack  M1  ()  AttackVal/AttackVal2
    WeaponID      = "178d0c21",
    SwingWait     = 0.08,
    HitCooldown   = 0.18,
    MaxAttackTime = 3.0,
    PersistLowered  = false, -- true =
    SafeHitHeight   = 12,  --
    NoDamageTimeout = 5,   --  HP  =
    IgnoreMobTime   = 8,   --
    UnlockWait    = 0.15,
    Debug         = true,
    AutoBuso      = true,  --  (Buso)
    ScanAll       = true,

    -- Auto Farm Bone:  ()
    Bone = {
        areas = {
            Vector3.new(-8724.46875, 140.04049682617188, 6044.52880859375),     -- 1 Reborn Skeleton
            Vector3.new(-9344.947265625, 171.87747192382812, 6201.3876953125),  -- 2 ( )
            Vector3.new(-9631.95703125, 171.8341827392578, 6053.44775390625),   -- 3 Demonic Soul
            Vector3.new(-9555.7529296875, 23.460342407226562, 6041.04248046875),-- 4 ( )
            Vector3.new(-10205.0859375, 152.68914794921875, 5861.9296875),      -- 5 Living Zombie
            Vector3.new(-9609.3515625, 4.978241920471191, 6361.974609375),      -- 6 Posessed Mummy
        },
        --  ( areas)
        -- {} =  () | "Posessed Mummy"   "Possessed Mummy"
        mobs = {
            { "Reborn Skeleton" },
            {},
            { "Demonic Soul" },
            {},
            { "Living Zombie" },
            { "Posessed Mummy", "Possessed Mummy" },
        },
        radius           = 300, --  (studs )
        noEnemyThreshold = 4,   --  ( 0.5   2 ) = /
    },
    FarmAreaTimeout = 30,

    -- Elite Hunter: \224\184\163\224\184\177\224\184\154\224\185\128\224\184\132\224\184\167\224\184\170 EliteHunter \224\185\129\224\184\165\224\185\137\224\184\167\224\184\163\224\184\173\224\184\154\224\184\173\224\184\170\224\185\128\224\184\129\224\184\180\224\184\148 \224\184\149\224\184\181\224\185\128\224\184\137\224\184\158\224\184\178\224\184\176\224\185\128\224\184\161\224\184\183\224\185\136\224\184\173\224\185\128\224\184\129\224\184\180\224\184\148\224\185\129\224\184\165\224\185\137\224\184\167
    Elite = {
        bosses        = { "Diablo", "Deandre", "Urban" }, -- boss model names to look for
        pollInterval  = 2,    -- check spawn every N seconds
        textInterval  = 3,    -- read GUI text every N seconds
        questInterval = 60,   -- re-send EliteHunter while waiting (seconds)
        killTimeout   = 240,  -- max seconds spent on one boss
        hoverHeight   = 30,
        -- island name (lowercase, as it appears in the game text) = position
        -- used when the text names an island but the boss model is not loaded yet
        -- example: ["hydra island"] = Vector3.new(x, y, z),
        islands = {},
    },

    -- Auto Farm Chest: island hopping
    Chest = {
        islandHeight = 80,    -- fly this high above an island point
        islandRadius = 2000,  -- only chests within this distance of the island point count as "on this island"
        -- true = also add the islands the game lists in workspace._WorldOrigin.Locations
        -- false = use only the list below (when the list is not empty)
        mergeLocations = false,
        extraIslands = {
            { name = "Port Town", pos = Vector3.new(-405.9332275390625, 24.857810974121094, 5557.609375) },
            { name = "Hydra Island", pos = Vector3.new(5397.5087890625, 1072.38037109375, 557.808837890625) },
            { name = "Great Tree", pos = Vector3.new(2502.485107421875, 109.58799743652344, -6797.93115234375) },
            { name = "Floating Turtle", pos = Vector3.new(-12550.9990234375, 336.4303283691406, -7409.5634765625) },
            { name = "Haunted Castle", pos = Vector3.new(-9548.9599609375, 141.58465576171875, 5535.09521484375) },
            { name = "Castle on the Sea", pos = Vector3.new(-5052.56103515625, 314.0031433105469, -3007.475341796875) },
            { name = "Sea of Treats", pos = Vector3.new(-913.6770629882812, 58.42280578613281, -10889.0703125) },
            { name = "Tiki Outpost", pos = Vector3.new(-16279.650390625, 48.70333480834961, 536.9451904296875) },
            { name = "Chocolate Island", pos = Vector3.new(506.58807373046875, 24.208946228027344, -12438.6962890625) },
            { name = "Peanut Island", pos = Vector3.new(-2077.119384765625, 37.56906509399414, -10216.7275390625) },
            { name = "Cake Island", pos = Vector3.new(-1895.8695068359375, 37.25876998901367, -11887.3916015625) },
            -- { name = "Jellybean Island", pos = Vector3.new(x, y, z) }, -- add coordinates to enable
        },
    },       --
}

------------------------------------------------------------
-- State
------------------------------------------------------------
local State = {
    autoFarm = false,
    levelFarmOn = false,
    levelFarmStatus = "ปิดระบบฟาร์มเลเวล",
    adminBossOn = false,
    fruitFinderOn = false,
    fruitFinderFlying = false,
    seaFarmOn = false,
    seaSelectedBoat = nil,
    seaBoatOptions = { "Dinghy", "Sloop", "Brigade", "Grand Brigade", "Miracle", "The Sentinel", "Guardian", "Lantern", "Beast Hunter", "Sleigh" },
    seaBoatModel = nil,
    seaBoatSpeed = 250,
    seaWeaponTypes = { Melee = true, Fruit = false, Sword = false, Gun = false },
    seaWeaponCycleIndex = 0,
    seaBasicCycleIndex = 0,
    seaGunLastShot = 0,
    seaGunAutoFire = true,
    seaGunRange = 1000,
    weapon = nil,
    statSelection = {},
    uiScale = 1,
    uiScaleSaved = false,
    v4Enabled = true,
    settingsFile = "RbotHudSettings.json",
    savePending = false,
    gunAutoTargetPart = nil,
    gunAutoEnemy = nil,
    gunAutoLoop = false,
    seaSkills = { Z = false, X = false, C = false, V = false },
    seaSkillLast = {},
    seaTargets = { SeaBeast = true, Terrorshark = true, Piranha = true, Shark = true, FishCrewMember = true, GhostShip = true },
    buying   = false,
    speed    = 100,
    level    = "-",
    quest    = "-",
    mob      = "-",
    dist     = "-",
    flyLV    = nil,
    flyAtt   = nil,
}

function State.loadSettings()
    if type(readfile) ~= "function" then return end
    local ok, saved = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(State.settingsFile))
    end)
    if not ok or type(saved) ~= "table" then return end
    if tonumber(saved.speed) then State.speed = math.clamp(tonumber(saved.speed), 1, MAX_SPEED) end
    if tonumber(saved.seaBoatSpeed) then State.seaBoatSpeed = math.clamp(math.floor(tonumber(saved.seaBoatSpeed)), 1, 400) end
    if type(saved.seaSelectedBoat) == "string" then State.seaSelectedBoat = saved.seaSelectedBoat end
    if type(saved.weapon) == "string" then State.weapon = saved.weapon end
    if type(saved.seaGunAutoFire) == "boolean" then State.seaGunAutoFire = saved.seaGunAutoFire end
    if type(saved.fruitFinderOn) == "boolean" then State.fruitFinderOn = saved.fruitFinderOn end
    if type(saved.v4Enabled) == "boolean" then State.v4Enabled = saved.v4Enabled end
    if tonumber(saved.uiScale) then
        State.uiScale = math.clamp(tonumber(saved.uiScale), 0.35, 2)
        State.uiScaleSaved = true
    end
    for key in pairs(State.seaWeaponTypes) do
        if type(saved.seaWeaponTypes) == "table" and type(saved.seaWeaponTypes[key]) == "boolean" then
            State.seaWeaponTypes[key] = saved.seaWeaponTypes[key]
        end
    end
    for key in pairs(State.seaTargets) do
        if type(saved.seaTargets) == "table" and type(saved.seaTargets[key]) == "boolean" then
            State.seaTargets[key] = saved.seaTargets[key]
        end
    end
    for key in pairs(State.seaSkills) do
        if type(saved.seaSkills) == "table" and type(saved.seaSkills[key]) == "boolean" then
            State.seaSkills[key] = saved.seaSkills[key]
        end
    end
    if type(saved.statSelection) == "table" then
        for key in pairs(State.statSelection) do State.statSelection[key] = nil end
        for key, value in pairs(saved.statSelection) do
            if type(key) == "string" and value == true then State.statSelection[key] = true end
        end
    end
end

function State.saveSettings()
    if type(writefile) ~= "function" then return false end
    local payload = {
        speed = State.speed,
        seaBoatSpeed = State.seaBoatSpeed,
        seaSelectedBoat = State.seaSelectedBoat,
        seaWeaponTypes = State.seaWeaponTypes,
        seaTargets = State.seaTargets,
        seaSkills = State.seaSkills,
        seaGunAutoFire = State.seaGunAutoFire,
        fruitFinderOn = State.fruitFinderOn,
        weapon = State.weapon,
        statSelection = State.statSelection,
        v4Enabled = State.v4Enabled,
    }
    if State.uiScaleSaved then payload.uiScale = State.uiScale end
    local ok, encoded = pcall(function()
        return game:GetService("HttpService"):JSONEncode(payload)
    end)
    if not ok then return false end
    return pcall(writefile, State.settingsFile, encoded)
end

function State.scheduleSave()
    if State.savePending then return end
    State.savePending = true
    task.delay(0.35, function()
        State.savePending = false
        State.saveSettings()
    end)
end

State.loadSettings()

------------------------------------------------------------
-- Remote Finder
------------------------------------------------------------
local function hasNil()
    return type(getnilinstances) == "function"
end

local function findNetRemote(name)
    local modules = RS:FindFirstChild("Modules")
    if not modules then return nil end
    local net = modules:FindFirstChild("Net")
    if not net then return nil end
    local r = net:FindFirstChild(name)
    if r then return r end
    for _, d in ipairs(net:GetChildren()) do
        if d.Name:lower():find(name:lower(), 1, true) then
            return d
        end
    end
    return nil
end

local function findRemoteExact(name)
    for _, d in ipairs(RS:GetDescendants()) do
        if d.Name == name and d:IsA("RemoteEvent") then return d end
    end
    return nil
end

local AttackEvent = findNetRemote("RE/RegisterAttack")
                 or findNetRemote("RegisterAttack")
                 or findRemoteExact("RE/RegisterAttack")
                 or findRemoteExact("RegisterAttack")

local HitEvent    = findNetRemote("RE/RegisterHit")
                 or findNetRemote("RegisterHit")
                 or findRemoteExact("RE/RegisterHit")
                 or findRemoteExact("RegisterHit")

local ShootGunEvent = findNetRemote("RE/ShootGunEvent")
                  or findNetRemote("ShootGunEvent")
                  or findRemoteExact("RE/ShootGunEvent")
                  or findRemoteExact("ShootGunEvent")

print("[Load] AttackEvent:", AttackEvent and AttackEvent:GetFullName() or "nil")
print("[Load] HitEvent:",    HitEvent    and HitEvent:GetFullName()    or "nil")
print("[Load] getnilinstances:", hasNil() and "\224\184\161\224\184\181" or "\224\185\132\224\184\161\224\185\136\224\184\161\224\184\181")

if not HitEvent then
    warn("[Load] \224\184\171\224\184\178 HitEvent \224\185\132\224\184\161\224\185\136\224\185\128\224\184\136\224\184\173 \226\128\148 Auto Farm Bone \224\184\136\224\184\176\224\185\128\224\184\163\224\184\180\224\185\136\224\184\161\224\185\132\224\184\161\224\185\136\224\185\132\224\184\148\224\185\137")
end

------------------------------------------------------------
--  RegisterAttack
--  M1  1-2  ()
--  AttackVal/AttackVal2 ( [Attack])
------------------------------------------------------------
State.attackArgs = nil
State.ownFire    = false
local function describe(v, depth)
    depth = depth or 0
    local ty = typeof(v)
    if ty == "Instance" then
        return v.ClassName .. ":" .. v.Name
    elseif ty == "table" then
        if depth >= 2 then return "{...}" end
        local parts, count = {}, 0
        for k, x in pairs(v) do
            count = count + 1
            if count <= 6 then
                parts[#parts + 1] = tostring(k) .. "=" .. describe(x, depth + 1)
            end
        end
        return "{" .. table.concat(parts, ", ") .. (count > 6 and (", +" .. (count - 6) .. " more") or "") .. "}"
    end
    return ty .. ":" .. tostring(v)
end
local function fmtArgs(t)
    local out = {}
    for i = 1, t.n do out[i] = describe(t[i]) end
    return table.concat(out, ", ")
end
State.hitDumpCount = 0
if AttackEvent and hookmetamethod and getnamecallmethod then
    local okHook, errHook = pcall(function()
        local old
        old = hookmetamethod(game, "__namecall", function(self, ...)
            --  RegisterHit  ( )  M1  3-5
            if self == HitEvent and not State.ownFire
               and State.hitDumpCount < 6 and getnamecallmethod() == "FireServer" then
                State.hitDumpCount = State.hitDumpCount + 1
                print("[Hit-Real] \224\185\128\224\184\129\224\184\161\224\184\170\224\185\136\224\184\135 RegisterHit: (" .. fmtArgs(table.pack(...)) .. ")")
            end
            if self == AttackEvent and not State.ownFire
               and getnamecallmethod() == "FireServer" then
                local args = table.pack(...)
                local prev = State.attackArgs
                State.attackArgs = args
                if CONFIG.Debug and (not prev or fmtArgs(prev) ~= fmtArgs(args)) then
                    print("[Attack] \224\185\128\224\184\129\224\184\161\224\184\170\224\185\136\224\184\135 RegisterAttack: (" .. fmtArgs(args) .. ")")
                end
            end
            return old(self, ...)
        end)
    end)
    print("[Load] \224\184\136\224\184\177\224\184\154\224\184\132\224\185\136\224\184\178 RegisterAttack:", okHook and "\224\184\158\224\184\163\224\185\137\224\184\173\224\184\161 (\224\184\129\224\184\148 M1 \224\185\128\224\184\173\224\184\135\224\184\170\224\184\177\224\184\129 1-2 \224\184\132\224\184\163\224\184\177\224\185\137\224\184\135)" or ("\224\184\165\224\185\137\224\184\161\224\185\128\224\184\171\224\184\165\224\184\167 " .. tostring(errHook)))
else
    print("[Load] \224\184\136\224\184\177\224\184\154\224\184\132\224\185\136\224\184\178 RegisterAttack: \224\185\132\224\184\161\224\185\136\224\184\163\224\184\173\224\184\135\224\184\163\224\184\177\224\184\154 (executor \224\185\132\224\184\161\224\185\136\224\184\161\224\184\181 hookmetamethod) \226\128\148 \224\185\131\224\184\138\224\185\137 AttackVal \224\185\131\224\184\153 CONFIG")
end

local Remotes = RS:WaitForChild("Remotes", 10)
local CommF   = Remotes and Remotes:WaitForChild("CommF_", 10)

------------------------------------------------------------
-- Helper
------------------------------------------------------------
local function getHRP()
    local char = lp.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function getNilPartNear(pos, maxDist)
    if not hasNil() then return nil end
    maxDist = maxDist or 15
    local best, bestDist = nil, maxDist
    for _, obj in ipairs(getnilinstances()) do
        if obj:IsA("BasePart") then
            local d = (obj.Position - pos).Magnitude
            if d < bestDist then best, bestDist = obj, d end
        end
    end
    return best
end

local function getEnemyPart(enemy)
    if not enemy or not enemy.Parent then return nil end
    local p = enemy:FindFirstChild("UpperTorso")
        or enemy:FindFirstChild("Torso")
        or enemy:FindFirstChild("HumanoidRootPart")
        or enemy:FindFirstChild("Head")
        or enemy.PrimaryPart
        or enemy:FindFirstChildWhichIsA("BasePart", true)
    if p then return p end
    if hasNil() then
        local root = enemy:FindFirstChild("HumanoidRootPart")
        if root then return getNilPartNear(root.Position, 15) end
    end
    return nil
end

local function isEnemyDead(enemy)
    if not enemy or not enemy.Parent then return true end
    local hum = enemy:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return true end
    return false
end

local function getWeaponID()
    local char = lp.Character
    if not char then return CONFIG.WeaponID end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return CONFIG.WeaponID end
    for _, v in ipairs(tool:GetDescendants()) do
        if v:IsA("StringValue") and v.Name:lower():find("id") then
            return v.Value
        elseif v:IsA("NumberValue") and v.Name:lower():find("id") then
            return tostring(v.Value)
        end
    end
    local attr = tool:GetAttribute("WeaponID") or tool:GetAttribute("ID")
    if attr then return tostring(attr) end
    return CONFIG.WeaponID
end

local function equipWeapon(requestedCategory)
    local char = lp.Character
    if not char then return end

    if State.seaFarmOn then
        local order = { "Melee", "Fruit", "Sword", "Gun" }
        local tips = { Melee = "melee", Fruit = "blox fruit", Sword = "sword", Gun = "gun" }
        local backpack = lp:FindFirstChild("Backpack")
        local hum = char:FindFirstChildOfClass("Humanoid")
        local categories = {}
        if requestedCategory then
            categories[1] = requestedCategory
        else
            local startIndex = State.seaBasicCycleIndex or State.seaWeaponCycleIndex or 0
            for offset = 1, #order do
                local index = ((startIndex + offset - 1) % #order) + 1
                if State.seaWeaponTypes[order[index]] then
                    categories[#categories + 1] = order[index]
                end
            end
        end
        for _, category in ipairs(categories) do
            local wantedTip = tips[category]
            local index = table.find(order, category)
            if wantedTip and State.seaWeaponTypes[category] then
                local current = char:FindFirstChildOfClass("Tool")
                if current and tostring(current.ToolTip):lower() == wantedTip then
                    if requestedCategory then
                        State.seaWeaponCycleIndex = index or State.seaWeaponCycleIndex
                    else
                        State.seaBasicCycleIndex = index or State.seaBasicCycleIndex
                    end
                    return true
                end
                if backpack and hum then
                    for _, candidate in ipairs(backpack:GetChildren()) do
                        if candidate:IsA("Tool") and tostring(candidate.ToolTip):lower() == wantedTip then
                            if requestedCategory then
                                State.seaWeaponCycleIndex = index or State.seaWeaponCycleIndex
                            else
                                State.seaBasicCycleIndex = index or State.seaBasicCycleIndex
                            end
                            hum:EquipTool(candidate)
                            task.wait(0.1)
                            local equipped = char:FindFirstChildOfClass("Tool")
                            return equipped == candidate or (equipped and tostring(equipped.ToolTip):lower() == wantedTip)
                        end
                    end
                end
            end
        end
        if requestedCategory or #categories > 0 then return false end
    end

    --
    local want = State.weapon
    if want then
        local wantedTip = ({ Melee = "melee", Gun = "gun", Fruit = "blox fruit", Sword = "sword" })[want]
        local cur = char:FindFirstChildOfClass("Tool")
        if cur and ((wantedTip and tostring(cur.ToolTip):lower() == wantedTip) or cur.Name == want) then return end
        local bp = lp:FindFirstChild("Backpack")
        local picked
        if bp and wantedTip then
            for _, candidate in ipairs(bp:GetChildren()) do
                if candidate:IsA("Tool") and tostring(candidate.ToolTip):lower() == wantedTip then
                    picked = candidate
                    break
                end
            end
        else
            picked = bp and bp:FindFirstChild(want)
        end
        if picked and picked:IsA("Tool") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:EquipTool(picked)
            else
                picked.Parent = char
            end
            task.wait(0.1)
            return
        end
    end

    if char:FindFirstChildOfClass("Tool") then return end
    local backpack = lp:FindFirstChild("Backpack")
    if not backpack then return end
    local tool = backpack:FindFirstChild("Combat")
              or backpack:FindFirstChild("Sword")
              or backpack:FindFirstChild("Melee")
              or backpack:FindFirstChildOfClass("Tool")
    if tool then
        tool.Parent = char
        task.wait(0.1)
    end
end

local function isMobWanted(enemy, filter)
    if not filter or #filter == 0 then return true end
    local n = enemy.Name:lower()
    local plainName = n:gsub("%s*%[lv%.%s*%d+%]$", "")
    for _, key in ipairs(filter) do
        local wanted = key:lower()
        if n == wanted or plainName == wanted then return true end
    end
    return false
end

local function getNearestEnemy(mobFilter)
    local hrp = getHRP()
    if not hrp then return nil end
    local pos = hrp.Position
    local nearest, nearestDist = nil, CONFIG.Range

    local containers = {}
    local en = workspace:FindFirstChild("Enemies")
        or workspace:FindFirstChild("enemies")
        or workspace:FindFirstChild("Monsters")
    if en then table.insert(containers, en) end
    if CONFIG.ScanAll then table.insert(containers, workspace) end

    for _, container in ipairs(containers) do
        for _, obj in ipairs(container:GetChildren()) do
            local ign = State.ignore and State.ignore[obj]
            if ign and tick() >= ign then
                State.ignore[obj] = nil
                ign = nil
            end
            if obj:IsA("Model")
               and obj ~= lp.Character
               and not ign
               and isMobWanted(obj, mobFilter)
            then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local part = getEnemyPart(obj)
                    if part then
                        local dist = (pos - part.Position).Magnitude
                        if dist < nearestDist then
                            nearest, nearestDist = obj, dist
                        end
                    end
                end
            end
        end
        if nearest and container ~= workspace then break end
    end

    return nearest, nearestDist
end

local function lockHRP(hrp)
    if not hrp then return end
    hrp.Anchored = true
    hrp.AssemblyLinearVelocity  = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

local function unlockHRP(hrp)
    if not hrp then return end
    hrp.Anchored = false
    hrp.AssemblyLinearVelocity  = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

------------------------------------------------------------
-- Noclip while Auto Farm is enabled
------------------------------------------------------------
local noclipConnection = nil
local noclipAddedConnection = nil
local originalCollisions = {}
local waterSwimState = { humanoid = nil, wasEnabled = nil }

local function setPartNoclip(part)
    if not part or not part:IsA("BasePart") then return end
    if originalCollisions[part] == nil then
        originalCollisions[part] = part.CanCollide
    end
    part.CanCollide = false
end

local function enableNoclip()
    if noclipConnection then return end
    local function applyToCharacter(char)
        if not char then return end
        for _, obj in ipairs(char:GetDescendants()) do
            setPartNoclip(obj)
        end
    end
    applyToCharacter(lp.Character)
    noclipAddedConnection = lp.CharacterAdded:Connect(function(char)
        if State.autoFarm or State.levelFarmOn or State.fruitFinderFlying then
            task.wait(0.2)
            applyToCharacter(char)
        end
    end)
    noclipConnection = RunService.Stepped:Connect(function()
        if not State.autoFarm and not State.levelFarmOn and not State.fruitFinderFlying then return end
        local char = lp.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if State.levelFarmOn and hum then
            if waterSwimState.humanoid ~= hum then
                if waterSwimState.humanoid and waterSwimState.humanoid.Parent and waterSwimState.wasEnabled ~= nil then
                    pcall(function() waterSwimState.humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, waterSwimState.wasEnabled) end)
                end
                waterSwimState.humanoid = hum
                local ok, wasEnabled = pcall(function() return hum:GetStateEnabled(Enum.HumanoidStateType.Swimming) end)
                waterSwimState.wasEnabled = ok and wasEnabled
                if not ok then waterSwimState.wasEnabled = true end
            end
            if hum:GetState() == Enum.HumanoidStateType.Swimming then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Physics) end)
            end
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false) end)
        end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") and obj.CanCollide then
                setPartNoclip(obj)
            end
        end
    end)
    print("[Noclip] \224\185\128\224\184\155\224\184\180\224\184\148\224\185\129\224\184\165\224\185\137\224\184\167 \226\128\148 \224\184\155\224\184\180\224\184\148\224\184\129\224\184\178\224\184\163\224\184\138\224\184\153\224\184\130\224\184\173\224\184\135\224\184\149\224\184\177\224\184\167\224\184\165\224\184\176\224\184\132\224\184\163\224\184\130\224\184\147\224\184\176 Auto Farm")
end

local function disableNoclip()
    if State.autoFarm or State.levelFarmOn or State.fruitFinderFlying then return end
    if waterSwimState.humanoid and waterSwimState.humanoid.Parent and waterSwimState.wasEnabled ~= nil then
        pcall(function() waterSwimState.humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, waterSwimState.wasEnabled) end)
    end
    waterSwimState.humanoid, waterSwimState.wasEnabled = nil, nil
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    if noclipAddedConnection then
        noclipAddedConnection:Disconnect()
        noclipAddedConnection = nil
    end
    for part, canCollide in pairs(originalCollisions) do
        if part and part.Parent then
            pcall(function() part.CanCollide = canCollide end)
        end
    end
    table.clear(originalCollisions)
    print("[Noclip] \224\184\155\224\184\180\224\184\148\224\185\129\224\184\165\224\185\137\224\184\167 \226\128\148 \224\184\132\224\184\183\224\184\153\224\184\132\224\185\136\224\184\178 CanCollide \224\185\128\224\184\148\224\184\180\224\184\161")
end

------------------------------------------------------------
-- Cleanup
------------------------------------------------------------
local function cleanupFly()
    if State.flyLV then
        pcall(function() State.flyLV:Destroy() end)
        State.flyLV = nil
    end
    if State.flyAtt then
        pcall(function() State.flyAtt:Destroy() end)
        State.flyAtt = nil
    end

    local h = getHRP()
    if h then
        pcall(function()
            h.Anchored = false
            h.AssemblyLinearVelocity  = Vector3.zero
            h.AssemblyAngularVelocity = Vector3.zero
        end)
        local hum = h.Parent and h.Parent:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.PlatformStand = false end) end
    end
end

------------------------------------------------------------
-- Buso Haki:  ( Character.HasBuso)
--  3
------------------------------------------------------------
local busoChar, busoFails, busoLastTry = nil, 0, 0
local function ensureBuso()
    if not CONFIG.AutoBuso or not CommF then return end
    local char = lp.Character
    if not char then return end
    if busoChar ~= char then
        busoChar, busoFails, busoLastTry = char, 0, 0
    end
    if char:FindFirstChild("HasBuso") then
        busoFails = 0
        return
    end
    if busoFails >= 3 then return end
    if tick() - busoLastTry < 3 then return end
    busoLastTry = tick()
    pcall(function() CommF:InvokeServer("Buso") end)
    task.wait(0.5)
    if char:FindFirstChild("HasBuso") then
        busoFails = 0
        print("[Buso] \224\185\128\224\184\155\224\184\180\224\184\148\224\184\174\224\184\178\224\184\132\224\184\180\224\185\129\224\184\165\224\185\137\224\184\167")
    else
        busoFails = busoFails + 1
    end
end

------------------------------------------------------------
--
-- RegisterHit  UserId  "078da" ()
--  thread  (SendHitsToServer)  executor   thread
------------------------------------------------------------
local HIT_KEY = tostring(lp.UserId):sub(2, 4) .. "078da"

local function getGameHitThread()
    local ok, result = pcall(function()
        local global = RS:FindFirstChild("Global")
        if global and getupvalues then
            for _, v in pairs(getupvalues(require(global).SendHitsToServer)) do
                if type(v) == "thread" and coroutine.status(v) ~= "dead" then
                    return v
                end
            end
        end
    end)
    return ok and result or nil
end

-- thread :
local ownHitThread = coroutine.create(function()
    pcall(function()
        if not HitEvent then return end
        HitEvent:FireServer(HIT_KEY)
        while true do
            local part, others = coroutine.yield()
            HitEvent:FireServer(part, others, nil, HIT_KEY)
        end
    end)
end)
coroutine.resume(ownHitThread)

-- : Head   HumanoidRootPart
local function hitPart(model)
    return model:FindFirstChild("Head")
        or model:FindFirstChild("HumanoidRootPart")
        or getEnemyPart(model)
end

local flyToPoint
local FruitFinder = { highlight = nil, billboard = nil, target = nil, statusLabel = nil, flying = false, candidates = {}, scanning = false, scanToken = 0 }
FruitFinder.names = {
    "rocket", "spin", "blade", "spring", "bomb", "smoke", "spike",
    "flame", "falcon", "eagle", "ice", "sand", "dark", "diamond", "light",
    "rubber", "barrier", "creation", "ghost", "revive", "magma", "quake",
    "buddha", "love", "spider", "sound", "phoenix", "portal", "rumble",
    "lightning", "pain", "blizzard", "gravity", "mammoth", "t rex", "trex",
    "dough", "shadow", "venom", "control", "spirit", "dragon", "leopard",
    "tiger", "kitsune", "yeti", "gas", "magnet",
}

function FruitFinder.matches(name)
    local normalized = (" " .. tostring(name):lower():gsub("[^%w]+", " ") .. " "):gsub("%s+", " ")
    if not normalized:match("%sfruit%s$") then return false end
    local fruitBase = normalized:gsub("%sfruit%s$", " ")
    for _, fruitName in ipairs(FruitFinder.names) do
        if fruitBase:find(" " .. fruitName .. " ", 1, true) then return true end
    end
    return false
end

function FruitFinder.pressFarmSkill(vim, keyCode)
    pcall(function() vim:SendKeyEvent(true, keyCode, false, game) end)
    task.wait(0.15)
    pcall(function() vim:SendKeyEvent(false, keyCode, false, game) end)
end

function FruitFinder.candidate(obj)
    if not (obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart")) then return nil end
    local name = tostring(obj.Name):lower()
    if not name:match("%sfruit$") then return nil end
    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then return nil end
    if not FruitFinder.matches(name) then return nil end
    local parentModel = obj:FindFirstAncestorOfClass("Model")
    if parentModel and FruitFinder.matches(parentModel.Name) then return nil end
    local part = obj:IsA("BasePart") and obj or obj:FindFirstChild("Handle", true)
        or obj:FindFirstChildWhichIsA("BasePart", true)
    if not part or not part:IsDescendantOf(workspace) then return nil end
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character and obj:IsDescendantOf(character) then return nil end
    end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = { obj, lp.Character }
    local groundHit = workspace:Raycast(part.Position + Vector3.new(0, 2, 0), Vector3.new(0, -12, 0), rayParams)
    if not groundHit or groundHit.Material == Enum.Material.Water then return nil end
    local groundGap = part.Position.Y - groundHit.Position.Y
    if groundGap < -1.5 or groundGap > 8 then return nil end
    return obj, part
end

function FruitFinder.cacheCandidate(obj)
    local candidate, part = FruitFinder.candidate(obj)
    if candidate and part then
        FruitFinder.candidates[candidate] = part
    else
        FruitFinder.candidates[obj] = nil
    end
end

function FruitFinder.cacheFrom(obj)
    local current = obj
    for _ = 1, 5 do
        if not current or current == workspace then break end
        if current:IsA("Tool") or current:IsA("Model") or current:IsA("BasePart") then
            FruitFinder.cacheCandidate(current)
        end
        current = current.Parent
    end
end

workspace.DescendantAdded:Connect(function(obj)
    if not State.fruitFinderOn then return end
    if obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart") then
        task.defer(FruitFinder.cacheFrom, obj)
    end
end)

workspace.DescendantRemoving:Connect(function(obj)
    for candidate in pairs(FruitFinder.candidates) do
        if candidate == obj or candidate:IsDescendantOf(obj) then
            FruitFinder.candidates[candidate] = nil
        end
    end
end)

function FruitFinder.seedCache()
    FruitFinder.scanToken += 1
    local token = FruitFinder.scanToken
    FruitFinder.scanning = true
    table.clear(FruitFinder.candidates)
    task.spawn(function()
        local stack = { workspace }
        local processed = 0
        while #stack > 0 and State.fruitFinderOn and FruitFinder.scanToken == token do
            local container = table.remove(stack)
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Tool") or child:IsA("Model") or child:IsA("BasePart") then
                    FruitFinder.cacheCandidate(child)
                end
                if #child:GetChildren() > 0 then table.insert(stack, child) end
                processed += 1
                if processed % 120 == 0 then task.wait() end
                if not State.fruitFinderOn or FruitFinder.scanToken ~= token then break end
            end
        end
        if FruitFinder.scanToken == token then FruitFinder.scanning = false end
    end)
end

function FruitFinder.update()
    if not State.fruitFinderOn then
        if FruitFinder.highlight then FruitFinder.highlight:Destroy() FruitFinder.highlight = nil end
        if FruitFinder.billboard then FruitFinder.billboard:Destroy() FruitFinder.billboard = nil end
        FruitFinder.target = nil
        if FruitFinder.flying then return end
        State.fruitFinderFlying = false
        if FruitFinder.statusLabel then FruitFinder.statusLabel.Text = "ปิดระบบหาผล" end
        return
    end
    local root = getHRP()
    if not root then return end
    local fruits = {}
    for obj in pairs(FruitFinder.candidates) do
        local candidate, part = FruitFinder.candidate(obj)
        if candidate and part then
            FruitFinder.candidates[candidate] = part
            local distance = (part.Position - root.Position).Magnitude
            fruits[#fruits + 1] = { object = candidate, part = part, distance = distance }
        else
            FruitFinder.candidates[obj] = nil
        end
    end
    table.sort(fruits, function(left, right) return left.distance < right.distance end)
    local best = fruits[1]
    local bestObject = best and best.object or nil
    local bestPart = best and best.part or nil
    local bestDistance = best and best.distance or nil
    if FruitFinder.target ~= bestObject then
        if FruitFinder.highlight then FruitFinder.highlight:Destroy() FruitFinder.highlight = nil end
        if FruitFinder.billboard then FruitFinder.billboard:Destroy() FruitFinder.billboard = nil end
        FruitFinder.target = bestObject
        FruitFinder.flying = false
        if bestObject then
            local ok, highlight = pcall(function()
                local h = Instance.new("Highlight")
                h.Name = "RbotFruitFinderHighlight"
                h.FillColor = Color3.fromRGB(70, 220, 120)
                h.OutlineColor = Color3.fromRGB(255, 245, 120)
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Adornee = bestObject
                h.Parent = bestObject
                return h
            end)
            if ok then FruitFinder.highlight = highlight end
            local okBillboard, billboard = pcall(function()
                local gui = Instance.new("BillboardGui")
                gui.Name = "RbotFruitFinderName"
                gui.Adornee = bestPart
                gui.AlwaysOnTop = true
                gui.Size = UDim2.fromOffset(250, 36)
                gui.StudsOffset = Vector3.new(0, 3, 0)
                gui.Parent = bestObject
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Name = "FruitNameDistance"
                nameLabel.BackgroundColor3 = Color3.fromRGB(22, 28, 34)
                nameLabel.BackgroundTransparency = 0.15
                nameLabel.Size = UDim2.fromScale(1, 1)
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextSize = 14
                nameLabel.TextColor3 = Color3.fromRGB(255, 245, 120)
                nameLabel.TextStrokeTransparency = 0.35
                nameLabel.Text = string.format("%s | %.0f studs", bestObject.Name, bestDistance)
                nameLabel.Parent = gui
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 7)
                corner.Parent = nameLabel
                return gui
            end)
            if okBillboard then FruitFinder.billboard = billboard end
        end
    end
    if FruitFinder.billboard and bestObject and FruitFinder.target == bestObject and bestDistance then
        local nameLabel = FruitFinder.billboard:FindFirstChild("FruitNameDistance")
        if nameLabel and nameLabel:IsA("TextLabel") then
            nameLabel.Text = string.format("%s | %.0f studs", bestObject.Name, bestDistance)
        end
    end
    if bestObject and not FruitFinder.scanning and not State.autoFarm and not State.levelFarmOn and flyToPoint and not FruitFinder.flying then
        local targetObject = bestObject
        FruitFinder.flying = true
        State.fruitFinderFlying = true
        enableNoclip()
        task.spawn(function()
            local targetPart = targetObject:IsA("BasePart") and targetObject
                or targetObject:FindFirstChild("Handle", true)
                or targetObject:FindFirstChildWhichIsA("BasePart", true)
            if targetPart then
                flyToPoint(targetPart.Position, 0.25, 120, function()
                    return State.fruitFinderOn and not State.autoFarm and not State.levelFarmOn
                        and FruitFinder.target == targetObject and targetObject.Parent ~= nil
                end)
                if State.fruitFinderOn and targetObject.Parent then task.wait(0.6) end
            end
            FruitFinder.flying = false
            State.fruitFinderFlying = false
            if not State.autoFarm and not State.levelFarmOn then disableNoclip() end
        end)
    end
    if FruitFinder.statusLabel then
        if FruitFinder.scanning then
            FruitFinder.statusLabel.Text = "กำลังสแกนผลที่ตกอยู่..."
        elseif not bestObject then
            FruitFinder.statusLabel.Text = "ยังไม่พบผลที่ตกอยู่ใน Workspace"
        else
            local summary = {}
            for _, fruit in ipairs(fruits) do
                table.insert(summary, string.format("%s — %.0f studs", fruit.object.Name, fruit.distance))
            end
            FruitFinder.statusLabel.Text = string.format("พบ %d ผล\n%s", #fruits, table.concat(summary, "\n"))
        end
    end
end

------------------------------------------------------------
-- Fire Hit
------------------------------------------------------------
local function fireHit(targetPart, enemy, others)
    if not targetPart and enemy then targetPart = getEnemyPart(enemy) end
    if not targetPart then return end

    equipWeapon() --

    -- Fire guns through the game's world-position shooting remote.
    if State.seaGunAutoFire then
        State.gunAutoTargetPart = targetPart
        State.gunAutoEnemy = enemy
        if not State.gunAutoLoop then
            State.gunAutoLoop = true
            task.spawn(function()
                    local lastSimulatedGunClick = 0
                    -- Keep the worker alive through target/tool swaps. A single stale
                    -- instance error must not leave gunAutoLoop stuck true forever.
                    local ok, err = pcall(function()
                        while State.seaGunAutoFire and State.autoFarm do
                            pcall(function()
                                local currentCharacter = lp.Character
                                local currentTool = currentCharacter and currentCharacter:FindFirstChildOfClass("Tool")
                                local root = getHRP()
                                local part = State.gunAutoTargetPart
                                local targetEnemy = State.gunAutoEnemy
                                if currentTool and tostring(currentTool.ToolTip):lower() == "gun"
                                    and root and part and part.Parent
                                    and targetEnemy and targetEnemy.Parent and not isEnemyDead(targetEnemy)
                                    and (part.Position - root.Position).Magnitude <= (State.seaGunRange or 1000)
                                then
                                    -- Fire rapidly through the world-position remote;
                                    -- pulse a simulated click at the target every 3 seconds.
                                    if ShootGunEvent then
                                        pcall(function() ShootGunEvent:FireServer(part.Position, { part }) end)
                                    end
                                    if tick() - lastSimulatedGunClick >= 1.5 then
                                        lastSimulatedGunClick = tick()
                                        pcall(function()
                                            local camera = workspace.CurrentCamera
                                            local vim = game:GetService("VirtualInputManager")
                                            if camera and vim then
                                                local screenPos, visible = camera:WorldToScreenPoint(part.Position)
                                                if visible and screenPos.Z > 0 then
                                                    vim:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 0)
                                                    task.wait(0.03)
                                                    vim:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 0)
                                                end
                                            end
                                        end)
                                    end
                                    State.seaGunLastShot = tick()
                                end
                            end)
                            task.wait(0.05)
                        end
                    end)
                    if not ok then warn("Gun auto-fire loop recovered: " .. tostring(err)) end
                    State.gunAutoTargetPart = nil
                    State.gunAutoEnemy = nil
                    State.gunAutoLoop = false
            end)
        end
    end

    -- The Settings skill selector also applies to non-sea farms.
    if not State.seaFarmOn then
        local vim
        pcall(function() vim = game:GetService("VirtualInputManager") end)
        if vim then
            for _, skillName in ipairs({ "Z", "X", "C", "V" }) do
                local cooldownKey = "global:" .. skillName
                if State.seaSkills[skillName] and tick() - (State.seaSkillLast[cooldownKey] or 0) >= 0.75 then
                    local code = Enum.KeyCode[skillName]
                    FruitFinder.pressFarmSkill(vim, code)
                    State.seaSkillLast[cooldownKey] = tick()
                end
            end
        end
    end

    local wid = getWeaponID()

    -- debug: /ID (  ID )
    if CONFIG.Debug then
        local char = lp.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        local key = (tool and tool.Name or "\224\185\132\224\184\161\224\185\136\224\184\161\224\184\181\224\184\173\224\184\178\224\184\167\224\184\184\224\184\152") .. "|" .. tostring(wid)
        if State.lastWeaponKey ~= key then
            State.lastWeaponKey = key
            print(("[Weapon] \224\184\150\224\184\183\224\184\173: %s | ID: %s%s"):format(
                tool and tool.Name or "\224\185\132\224\184\161\224\185\136\224\184\161\224\184\181", tostring(wid),
                (wid == CONFIG.WeaponID) and " (\224\184\132\224\185\136\224\184\178\224\185\128\224\184\163\224\184\180\224\185\136\224\184\161\224\184\149\224\185\137\224\184\153\224\185\131\224\184\153 CONFIG)" or ""
            ))
            if not tool then
                warn("[Weapon] \224\184\149\224\184\177\224\184\167\224\184\165\224\184\176\224\184\132\224\184\163\224\185\132\224\184\161\224\185\136\224\185\132\224\184\148\224\185\137\224\184\150\224\184\183\224\184\173\224\184\173\224\184\178\224\184\167\224\184\184\224\184\152 \226\128\148 \224\184\136\224\184\176\224\184\149\224\184\181\224\185\132\224\184\161\224\185\136\224\185\130\224\184\148\224\184\153")
            end
        end
    end

    --  ( [Diag])
    do
        local nowT = tick()
        local lg = State.hitLog
        if not lg then lg = {}; State.hitLog = lg end
        lg[#lg + 1] = nowT
        while #lg > 0 and nowT - lg[1] > 3 do table.remove(lg, 1) end
    end

    if AttackEvent then
        State.ownFire = true
        pcall(function()
            local a = State.attackArgs
            if CONFIG.UseCapturedAttack and a then
                AttackEvent:FireServer(table.unpack(a, 1, a.n))
            else
                AttackEvent:FireServer(CONFIG.AttackVal, CONFIG.AttackVal2)
            end
        end)
        State.ownFire = false
        task.wait(CONFIG.SwingWait)
    end
    -- : others =   { {model, part}, ... }
    State.ownFire = true
    pcall(function()
        local list = others or {}
        local th = getGameHitThread()
        if not th and coroutine.status(ownHitThread) ~= "dead" then th = ownHitThread end
        if th then
            local okR = coroutine.resume(th, targetPart, list)
            if not okR then HitEvent:FireServer(targetPart, list, nil, HIT_KEY) end
        else
            HitEvent:FireServer(targetPart, list, nil, HIT_KEY)
        end
    end)
    State.ownFire = false
    task.wait(CONFIG.HitCooldown)
end

------------------------------------------------------------
-- Smooth Fly
------------------------------------------------------------
flyToPoint = function(goalPos, stopDist, timeout, isRunning)
    stopDist  = stopDist or 3
    timeout   = timeout  or 10
    isRunning = isRunning or function() return State.autoFarm or State.levelFarmOn end

    if not isRunning() then return false end

    local hrp = getHRP()
    if not hrp then return false end
    hrp.Anchored = false

    cleanupFly()

    local att = Instance.new("Attachment")
    att.Parent = hrp
    State.flyAtt = att

    local lv = Instance.new("LinearVelocity")
    lv.Attachment0    = att
    lv.MaxForce       = math.huge
    lv.VectorVelocity = Vector3.zero
    lv.Parent         = hrp
    State.flyLV       = lv

    local reached = false
    local t0      = tick()
    local conn

    conn = RunService.Heartbeat:Connect(function(dt)
        if not isRunning() then
            if lv then lv.VectorVelocity = Vector3.zero end
            reached = true
            return
        end
        if reached then return end
        if tick() - t0 > timeout then
            reached = true; return
        end

        local h = getHRP()
        if not h then reached = true; return end

        local dir  = goalPos - h.Position
        local dist = dir.Magnitude

        if dist < stopDist then
            lv.VectorVelocity = Vector3.zero
            reached = true
            return
        end

        local speed = State.speed * CONFIG.FlySpeedMul
        if dist < 25 then
            speed = math.max(speed * (dist / 25), 8)
        end
        lv.VectorVelocity = dir.Unit * speed

        pcall(function()
            h.CFrame = CFrame.lookAt(h.Position, goalPos)
        end)
    end)

    while not reached and isRunning() do
        RunService.Heartbeat:Wait()
    end

    if conn then conn:Disconnect() end
    cleanupFly()

    return reached
end

local function flyToEnemy(enemy, isRunning)
    local target = getEnemyPart(enemy)
    if not target then return end
    local hrp = getHRP()
    if not hrp then return end

    local dist = (hrp.Position - target.Position).Magnitude
    local speed = math.max(State.speed * CONFIG.FlySpeedMul, 1)
    local timeout = math.max(6, (dist / speed) + 4)

    flyToPoint(
        target.Position + Vector3.new(
            0,
            State.loweredAll and math.min(CONFIG.HeightAbove, CONFIG.SafeHitHeight or 5)
                or CONFIG.HeightAbove,
            0
        ),
        3,
        timeout,
        isRunning
    )
end

local function flyToFarmArea(npcKey)
    local info = CONFIG.QuestNPCs[npcKey]
    if not info or not info.farmArea then return false end
    local area = info.farmArea
    --  (farmAreas):
    if info.farmAreas and #info.farmAreas > 0 then
        info._areaIdx = ((info._areaIdx or 0) % #info.farmAreas) + 1
        area = info.farmAreas[info._areaIdx]
    end
    if area.Magnitude == 0 then return false end

    print("[FarmArea] \224\184\154\224\184\180\224\184\153\224\185\132\224\184\155 " .. tostring(area))

    if requeststreamaroundasync then
        pcall(requeststreamaroundasync, area)
        task.wait(0.3)
    end

    local goal = area + Vector3.new(0, CONFIG.WaitHeight or CONFIG.HeightAbove, 0)
    local reached = flyToPoint(goal, 5, CONFIG.FarmAreaTimeout)
    if reached then
        lockHRP(getHRP()) --
        print("[FarmArea] \224\184\150\224\184\182\224\184\135\224\185\129\224\184\165\224\185\137\224\184\167 \224\184\163\224\184\173 1 \224\184\167\224\184\180")
        task.wait(1)
    else
        warn("[FarmArea] \224\184\154\224\184\180\224\184\153\224\185\132\224\184\161\224\185\136\224\184\150\224\184\182\224\184\135")
    end
    return reached
end

------------------------------------------------------------
-- Circle + Attack
------------------------------------------------------------
-- :  {, ...}  CONFIG.GatherCount
local function gatherNearby(enemy, filter)
    local group = { enemy }
    local tPart = getEnemyPart(enemy)
    if not tPart or not enemy.Parent then return group end

    if sethiddenproperty then
        pcall(sethiddenproperty, lp, "SimulationRadius", math.huge)
    end

    for _, obj in ipairs(enemy.Parent:GetChildren()) do
        if #group >= (CONFIG.GatherCount or 3) then break end
        if obj ~= enemy and obj:IsA("Model") and isMobWanted(obj, filter) then
            local hum  = obj:FindFirstChildOfClass("Humanoid")
            local part = getEnemyPart(obj)
            if hum and hum.Health > 0 and part
               and (part.Position - tPart.Position).Magnitude <= (CONFIG.GatherRadius or 200)
            then
                table.insert(group, obj)
            end
        end
    end

    for i = 2, #group do
        local part = getEnemyPart(group[i])
        if part then
            local a = (i - 1) * (math.pi * 2 / math.max(#group - 1, 1))
            pcall(function()
                part.CanCollide = false
                part.AssemblyLinearVelocity = Vector3.zero
                part.CFrame = CFrame.new(
                    tPart.Position + Vector3.new(math.cos(a) * 2, 0, math.sin(a) * 2)
                )
            end)
        end
    end

    return group
end

--  HP  (: ///)
local function hitDiag(enemy, groupSize)
    local char = lp.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local hrp  = getHRP()
    local tool = char and char:FindFirstChildOfClass("Tool")
    local stun = char and char:FindFirstChild("Stun")
    local eh   = enemy and enemy:FindFirstChildOfClass("Humanoid")
    local ep   = enemy and getEnemyPart(enemy)
    local dist = (hrp and ep) and (hrp.Position - ep.Position).Magnitude or -1
    print(("[Diag] \224\184\149\224\184\181\224\185\132\224\184\161\224\185\136\224\185\128\224\184\130\224\185\137\224\184\178 | \224\184\173\224\184\178\224\184\167\224\184\184\224\184\152=%s | Stun=%s | HP\224\184\149\224\184\177\224\184\167\224\185\128\224\184\173\224\184\135=%s | Anchored=%s | PlatformStand=%s | \224\184\163\224\184\176\224\184\162\224\184\176=%.1f | HP\224\184\161\224\184\173\224\184\153=%s | \224\184\129\224\184\165\224\184\184\224\185\136\224\184\161=%d"):format(
        tool and tool.Name or "\224\185\132\224\184\161\224\185\136\224\184\161\224\184\181",
        stun and tostring(stun.Value) or "\224\185\132\224\184\161\224\185\136\224\184\161\224\184\181",
        hum and math.floor(hum.Health) or "?",
        hrp and tostring(hrp.Anchored) or "?",
        hum and tostring(hum.PlatformStand) or "?",
        dist,
        eh and math.floor(eh.Health) or "?",
        groupSize or 1
    ))

    local lg = State.hitLog
    print(("[Diag] \224\184\173\224\184\177\224\184\149\224\184\163\224\184\178\224\184\149\224\184\181 \226\137\136 %.1f \224\184\132\224\184\163\224\184\177\224\185\137\224\184\135/\224\184\167\224\184\180 (3 \224\184\167\224\184\180\224\184\165\224\185\136\224\184\178\224\184\170\224\184\184\224\184\148) | \224\184\170\224\185\136\224\184\135 AttackEvent=%s HitEvent=%s"):format(
        lg and (#lg / 3) or 0, tostring(AttackEvent ~= nil), tostring(HitEvent ~= nil)
    ))

    if tool and State.diagToolDumped ~= tool.Name then
        State.diagToolDumped = tool.Name
        local attrs = {}
        for k, v in pairs(tool:GetAttributes()) do
            attrs[#attrs + 1] = tostring(k) .. "=" .. tostring(v)
        end
        local kids = {}
        for _, d in ipairs(tool:GetDescendants()) do
            if #kids < 14 then kids[#kids + 1] = d.ClassName .. ":" .. d.Name end
        end
        print("[Diag] \224\184\173\224\184\178\224\184\167\224\184\184\224\184\152 attributes: " .. (#attrs > 0 and table.concat(attrs, ", ") or "\224\185\132\224\184\161\224\185\136\224\184\161\224\184\181"))
        print("[Diag] \224\184\173\224\184\178\224\184\167\224\184\184\224\184\152 \224\184\160\224\184\178\224\184\162\224\185\131\224\184\153: " .. (#kids > 0 and table.concat(kids, ", ") or "\224\185\132\224\184\161\224\185\136\224\184\161\224\184\181"))
    end
end

local function circleAndAttack(enemy, maxTime, mobFilter, heightOverride, onCombatTick, isRunning)
    maxTime = maxTime or CONFIG.MaxAttackTime
    local t0 = tick()
    local angle = 0
    local lastDebug = 0
    local lastGather = 0
    local group = { enemy }

    isRunning = isRunning or function() return State.autoFarm end
    if not isRunning() then return end

    local hrp = getHRP()
    if not hrp then return end
    hrp.Anchored = false

    cleanupFly()

    local att = Instance.new("Attachment")
    att.Parent = hrp
    State.flyAtt = att

    local lv = Instance.new("LinearVelocity")
    lv.Attachment0 = att
    lv.MaxForce    = math.huge
    lv.VectorVelocity = Vector3.zero
    lv.Parent = hrp
    State.flyLV = lv

    --  (HP )  SafeHitHeight
    local lowered = not heightOverride and (State.loweredAll or (State.loweredFor == enemy)) or false
    local diagDone = false
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if not isRunning() then
            if lv then lv.VectorVelocity = Vector3.zero end
            return
        end

        local h = getHRP()
        if not h then return end
        local t = getEnemyPart(enemy)
        if not t then return end

        angle = angle + CONFIG.CircleSpeed * dt
        local hAbove = heightOverride or CONFIG.HeightAbove
        if not heightOverride and lowered then hAbove = math.min(hAbove, CONFIG.SafeHitHeight or 5) end
        local center = t.Position + Vector3.new(0, hAbove, 0)
        local goal = center + Vector3.new(
            math.cos(angle) * CONFIG.CircleRadius, 0,
            math.sin(angle) * CONFIG.CircleRadius
        )

        local dir = goal - h.Position
        local dist = dir.Magnitude
        if dist > 0.3 then
            local speed = math.min(State.speed * CONFIG.FlySpeedMul * 0.6, dist * 8)
            lv.VectorVelocity = dir.Unit * speed
        else
            lv.VectorVelocity = Vector3.zero
        end

        pcall(function()
            h.CFrame = CFrame.lookAt(h.Position, t.Position)
        end)
    end)

    while isRunning() and (tick() - t0) < maxTime do
        if isEnemyDead(enemy) then break end
        local target = getEnemyPart(enemy)
        if not target then break end

        --  HP  (/)
        do
            local eh = enemy:FindFirstChildOfClass("Humanoid")
            if eh then
                local tr = State.hitTrack
                if not tr or tr.enemy ~= enemy then
                    State.hitTrack = { enemy = enemy, hp = eh.Health, since = tick() }
                elseif eh.Health < tr.hp - 0.5 then
                    tr.hp, tr.since = eh.Health, tick()
                elseif not heightOverride and not lowered
                    and CONFIG.HeightAbove > (CONFIG.SafeHitHeight or 5) + 1
                    and tick() - tr.since > 1.5
                then
                    lowered = true
                    State.loweredFor = enemy
                    --
                    -- ()  Auto Farm
                    if CONFIG.PersistLowered ~= false then State.loweredAll = true end
                    tr.since = tick() --
                    if CONFIG.Debug then
                        print(("[Hit] \224\184\149\224\184\181\224\185\132\224\184\161\224\185\136\224\185\128\224\184\130\224\185\137\224\184\178\224\184\151\224\184\181\224\185\136\224\184\132\224\184\167\224\184\178\224\184\161\224\184\170\224\184\185\224\184\135 %d \226\128\148 \224\184\165\224\184\148\224\185\128\224\184\171\224\184\165\224\184\183\224\184\173 %d \224\184\170\224\184\179\224\184\171\224\184\163\224\184\177\224\184\154\224\184\149\224\184\177\224\184\167\224\184\153\224\184\181\224\185\137"):format(
                            CONFIG.HeightAbove, CONFIG.SafeHitHeight or 5
                        ))
                    end
                elseif not diagDone and tick() - tr.since > 2.5 then
                    diagDone = true
                    if CONFIG.Debug then hitDiag(enemy, #group) end
                elseif tick() - tr.since > (CONFIG.NoDamageTimeout or 5) then
                    State.ignore = State.ignore or {}
                    State.ignore[enemy] = tick() + (CONFIG.IgnoreMobTime or 8)
                    State.hitTrack = nil
                    if CONFIG.Debug then
                        print(("[Hit] %s HP \224\185\132\224\184\161\224\185\136\224\184\165\224\184\148 %ds \226\128\148 \224\184\130\224\185\137\224\184\178\224\184\161\224\185\132\224\184\155\224\184\171\224\184\178\224\184\149\224\184\177\224\184\167\224\184\173\224\184\183\224\185\136\224\184\153"):format(
                            enemy.Name, CONFIG.NoDamageTimeout or 5
                        ))
                    end
                    break
                end
            end
        end

        local h = getHRP()
        if CONFIG.Debug and h and tick() - lastDebug > 0.5 then
            lastDebug = tick()
            local dist = (h.Position - target.Position).Magnitude
            local hp   = enemy:FindFirstChildOfClass("Humanoid")
            print(("[Hit] %s | \224\184\163\224\184\176\224\184\162\224\184\176 %.1f | HP %s"):format(
                enemy.Name, dist, hp and math.floor(hp.Health) or "?"
            ))
        end

        if CONFIG.GatherMobs and mobFilter
           and tick() - lastGather > (CONFIG.GatherInterval or 0.5)
        then
            lastGather = tick()
            group = gatherNearby(enemy, mobFilter)
        end

        --
        --
        --
        local skipped = 0
        local others = {}
        for _, m in ipairs(group) do
            if m ~= enemy and not isEnemyDead(m) then
                local mp = getEnemyPart(m)
                local hh = getHRP()
                if mp and hh
                    and (mp.Position - hh.Position).Magnitude <= (CONFIG.GatherHitRange or 60)
                then
                    others[#others + 1] = { m, hitPart(m) or mp }
                else
                    skipped += 1
                end
            end
        end
        if isRunning() then
            --  +  RegisterHit
            if onCombatTick then pcall(onCombatTick) end
            fireHit(hitPart(enemy) or target, enemy, others)
        end
        if CONFIG.Debug and skipped > 0 and tick() - lastDebug > 0.4 then
            print(("[Gather] \224\184\130\224\185\137\224\184\178\224\184\161 %d \224\184\149\224\184\177\224\184\167\224\184\151\224\184\181\224\185\136\224\185\132\224\184\161\224\185\136\224\185\132\224\184\148\224\185\137\224\184\161\224\184\178\224\184\173\224\184\162\224\184\185\224\185\136\224\185\131\224\184\129\224\184\165\224\185\137"):format(skipped))
        end

        if not isRunning() then break end
    end

    if conn then conn:Disconnect() end
    cleanupFly()
end

------------------------------------------------------------
-- Auto Farm Bone:  ()  CONFIG.Bone.areas
------------------------------------------------------------
--    Enemies
local function getNearestMobNear(center, radius, filter)
    local en = workspace:FindFirstChild("Enemies")
        or workspace:FindFirstChild("enemies")
        or workspace:FindFirstChild("Monsters")
    if not en then return nil end
    local nearest, nearestDist = nil, radius
    for _, obj in ipairs(en:GetChildren()) do
        local ign = State.ignore and State.ignore[obj]
        if ign and tick() >= ign then
            State.ignore[obj] = nil
            ign = nil
        end
        if obj:IsA("Model")
           and obj ~= lp.Character
           and not ign
           and not Players:GetPlayerFromCharacter(obj)
           and isMobWanted(obj, filter)
        then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local part = getEnemyPart(obj)
                if part then
                    local d = (part.Position - center).Magnitude
                    if d < nearestDist then
                        nearest, nearestDist = obj, d
                    end
                end
            end
        end
    end
    return nearest
end

--  Enemies : ,  ()  studs
local function describeEnemies(center)
    local en = workspace:FindFirstChild("Enemies")
        or workspace:FindFirstChild("enemies")
        or workspace:FindFirstChild("Monsters")
    if not en then return nil end
    local count, alive, bestName, bestDist = 0, 0, nil, math.huge
    for _, obj in ipairs(en:GetChildren()) do
        if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
            count = count + 1
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                alive = alive + 1
                local part = getEnemyPart(obj)
                if part then
                    local d = (part.Position - center).Magnitude
                    if d < bestDist then bestName, bestDist = obj.Name, d end
                end
            end
        end
    end
    return count, alive, bestName, bestDist
end

local loopThread

local function startLoop()
    if loopThread then return end
    if not HitEvent then
        warn("[Bone] \224\185\132\224\184\161\224\185\136\224\184\158\224\184\154 HitEvent \224\185\128\224\184\163\224\184\180\224\185\136\224\184\161\224\184\159\224\184\178\224\184\163\224\185\140\224\184\161\224\185\132\224\184\161\224\185\136\224\185\132\224\184\148\224\185\137")
        State.autoFarm = false
        return
    end
    loopThread = task.spawn(function()
        local ok, err = pcall(function()
            local areas = CONFIG.Bone.areas
            local areaIdx, arrived, noEnemyCount = 1, false, 0
            print("[Bone] \224\185\128\224\184\163\224\184\180\224\185\136\224\184\161\224\184\159\224\184\178\224\184\163\224\185\140\224\184\161\224\185\130\224\184\154\224\184\153 | " .. #areas .. " \224\184\136\224\184\184\224\184\148")

            while State.autoFarm do
                -- :   CharacterAdded
                local liveChar = lp.Character
                local liveHum = liveChar and liveChar:FindFirstChildOfClass("Humanoid")
                local liveRoot = liveChar and liveChar:FindFirstChild("HumanoidRootPart")
                if not liveChar or not liveHum or liveHum.Health <= 0 or not liveRoot then
                    print("[Bone] \224\184\149\224\184\177\224\184\167\224\184\165\224\184\176\224\184\132\224\184\163\224\184\149\224\184\178\224\184\162/\224\184\129\224\184\179\224\184\165\224\184\177\224\184\135\224\185\128\224\184\129\224\184\180\224\184\148\224\185\131\224\184\171\224\184\161\224\185\136 \226\128\148 \224\184\158\224\184\177\224\184\129\224\185\129\224\184\165\224\185\137\224\184\167\224\184\163\224\184\173\224\185\128\224\184\163\224\184\180\224\185\136\224\184\161\224\185\131\224\184\171\224\184\161\224\185\136")
                    break
                end

                ensureBuso()
                equipWeapon()
                State.quest = string.format("%d/%d", areaIdx, #areas)
                local area = areas[areaIdx]
                local areaMobs = (CONFIG.Bone.mobs and CONFIG.Bone.mobs[areaIdx]) or {}

                if not arrived then
                    --
                    State.mob, State.dist = "-", "-"
                    if requeststreamaroundasync then
                        pcall(requeststreamaroundasync, area)
                        task.wait(0.3)
                    end
                    print("[Bone] \224\184\154\224\184\180\224\184\153\224\185\132\224\184\155\224\184\136\224\184\184\224\184\148 " .. areaIdx .. ": " .. tostring(area))
                    local reached = flyToPoint(
                        area + Vector3.new(0, CONFIG.WaitHeight or 30, 0),
                        5, CONFIG.FarmAreaTimeout
                    )
                    if not State.autoFarm then break end
                    if reached then
                        arrived, noEnemyCount = true, 0
                        lockHRP(getHRP())
                    else
                        warn("[Bone] \224\184\154\224\184\180\224\184\153\224\185\132\224\184\161\224\185\136\224\184\150\224\184\182\224\184\135\224\184\136\224\184\184\224\184\148 " .. areaIdx .. " \226\128\148 \224\184\130\224\185\137\224\184\178\224\184\161\224\185\132\224\184\155\224\184\136\224\184\184\224\184\148\224\184\150\224\184\177\224\184\148\224\185\132\224\184\155")
                        areaIdx = areaIdx % #areas + 1
                    end
                else
                    local enemy = getNearestMobNear(area, CONFIG.Bone.radius, areaMobs)
                    if enemy then
                        noEnemyCount = 0
                        local h, part = getHRP(), getEnemyPart(enemy)
                        State.mob = enemy.Name
                        State.dist = (h and part)
                            and string.format("%.0fm", (h.Position - part.Position).Magnitude)
                            or "-"
                        flyToEnemy(enemy)
                        circleAndAttack(enemy, CONFIG.MaxAttackTime, areaMobs) --
                    else
                        State.dist = "-"
                        lockHRP(getHRP()) --
                        noEnemyCount = noEnemyCount + 1
                        if noEnemyCount % 6 == 1 then
                            if requeststreamaroundasync then
                                pcall(requeststreamaroundasync, area)
                            end
                            local count, alive, name, dist = describeEnemies(area)
                            if not count then
                                State.mob = "\224\185\132\224\184\161\224\185\136\224\184\158\224\184\154\224\185\130\224\184\159\224\184\165\224\185\128\224\184\148\224\184\173\224\184\163\224\185\140 Enemies"
                                warn("[Bone] \224\185\132\224\184\161\224\185\136\224\184\158\224\184\154 workspace.Enemies")
                            elseif not name then
                                State.mob = "\224\184\163\224\184\173\224\184\161\224\184\173\224\184\153\224\185\128\224\184\129\224\184\180\224\184\148 (Enemies " .. count .. " \224\184\149\224\184\177\224\184\167)"
                                print(("[Bone] \224\184\136\224\184\184\224\184\148 %d: Enemies %d \224\184\149\224\184\177\224\184\167 \224\185\132\224\184\161\224\185\136\224\184\161\224\184\181\224\184\149\224\184\177\224\184\167\224\184\151\224\184\181\224\185\136\224\184\162\224\184\177\224\184\135\224\184\161\224\184\181\224\184\138\224\184\181\224\184\167\224\184\180\224\184\149"):format(areaIdx, count))
                            else
                                State.mob = "\224\185\132\224\184\161\224\185\136\224\184\173\224\184\162\224\184\185\224\185\136\224\185\131\224\184\153\224\184\163\224\184\177\224\184\168\224\184\161\224\184\181/\224\184\150\224\184\185\224\184\129\224\184\130\224\185\137\224\184\178\224\184\161"
                                print(("[Bone] \224\184\136\224\184\184\224\184\148 %d: Enemies %d \224\184\149\224\184\177\224\184\167 \224\184\161\224\184\181\224\184\138\224\184\181\224\184\167\224\184\180\224\184\149 %d | \224\185\131\224\184\129\224\184\165\224\185\137\224\184\170\224\184\184\224\184\148 %s \224\184\171\224\185\136\224\184\178\224\184\135\224\184\136\224\184\184\224\184\148\224\184\159\224\184\178\224\184\163\224\185\140\224\184\161 %.0f studs (\224\184\163\224\184\177\224\184\168\224\184\161\224\184\181 %d)")
                                    :format(areaIdx, count, alive, name, dist, CONFIG.Bone.radius))
                            end
                        end
                        task.wait(0.5)
                        if noEnemyCount >= CONFIG.Bone.noEnemyThreshold then
                            noEnemyCount = 0
                            areaIdx = areaIdx % #areas + 1
                            arrived = false
                            print("[Bone] \224\185\132\224\184\161\224\185\136\224\185\128\224\184\136\224\184\173\224\184\161\224\184\173\224\184\153 \226\134\146 \224\184\162\224\185\137\224\184\178\224\184\162\224\185\132\224\184\155\224\184\136\224\184\184\224\184\148 " .. areaIdx)
                        end
                    end
                end
                task.wait(0.05)
            end
        end)
        if not ok then warn("[Bone] " .. tostring(err)) end
        cleanupFly()
        loopThread = nil
        print("[Bone] \224\184\171\224\184\162\224\184\184\224\184\148\224\184\151\224\184\179\224\184\135\224\184\178\224\184\153")
    end)
end

local function stopLoop()
    State.autoFarm = false
    disableNoclip()
    cleanupFly()
    if loopThread then
        pcall(task.cancel, loopThread)
        loopThread = nil
    end
    local hrp = getHRP()
    if hrp then
        hrp.Anchored = false
        hrp.AssemblyLinearVelocity  = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        local hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.PlatformStand = false end) end
    end
    print("[Loop] \224\184\171\224\184\162\224\184\184\224\184\148\224\184\151\224\184\179\224\184\135\224\184\178\224\184\153 + cleanup \224\185\129\224\184\165\224\185\137\224\184\167")
end

------------------------------------------------------------
-- Level farm: pick a level-appropriate quest, accept it, then fight only its target.
------------------------------------------------------------
local LevelFarm = { guideData = nil, quests = nil, cachedLevel = nil, cachedTeam = nil, cachedInfo = nil, cachedError = nil }

function LevelFarm.getQuestInfo(level)
    level = tonumber(level) or 1
    if level >= 3000 then return nil, "ถึงเลเวลสูงสุด 3000" end
    local bestLevel, giverCFrame, questName, questIndex = 0, nil, nil, nil
    local teamName = lp.Team and lp.Team.Name or ""
    if LevelFarm.cachedLevel == level and LevelFarm.cachedTeam == teamName then
        return LevelFarm.cachedInfo, LevelFarm.cachedError
    end

    -- Starter quests and the Prison quest use fixed giver points in the game data.
    if level >= 1 and level <= 9 then
        bestLevel = 1
        questIndex = 1
        giverCFrame = teamName == "Marines"
            and CFrame.new(-2709.67944, 24.5206585, 2104.24585)
            or CFrame.new(1059.99731, 16.9222069, 1549.28162)
        questName = teamName == "Marines" and "MarineQuest" or "BanditQuest1"
    elseif level >= 210 and level <= 249 then
        bestLevel, questName, questIndex = 210, "PrisonerQuest", 2
        giverCFrame = CFrame.new(5308.93115, 1.65517521, 475.120514)
    else
        local guide = LevelFarm.guideData
        if not guide then
            local ok, result = pcall(function()
                return require(RS:WaitForChild("GuideModule"))
            end)
            if not ok or type(result) ~= "table" or not result.Data or not result.Data.NPCList then
                return nil, "อ่านรายชื่อ NPC เควสต์ไม่สำเร็จ"
            end
            guide = result
            LevelFarm.guideData = result
        end

        for npc, npcInfo in pairs(guide.Data.NPCList) do
            local levels = npcInfo and npcInfo.Levels
            if levels then
                for index, requiredLevel in ipairs(levels) do
                    requiredLevel = tonumber(requiredLevel)
                    if requiredLevel and level >= requiredLevel and requiredLevel > bestLevel then
                        bestLevel = requiredLevel
                        questIndex = (#levels == 3 and index == 3) and 2 or index
                        if typeof(npc) == "CFrame" then
                            giverCFrame = npc
                        elseif typeof(npc) == "Instance" then
                            if npc:IsA("BasePart") then
                                giverCFrame = npc.CFrame
                            elseif npc:IsA("Model") then
                                giverCFrame = npc:GetPivot()
                            end
                        end
                    end
                end
            end
        end
    end

    if bestLevel <= 0 or not giverCFrame then
        LevelFarm.cachedLevel, LevelFarm.cachedTeam = level, teamName
        LevelFarm.cachedInfo, LevelFarm.cachedError = nil, "ยังไม่พบ NPC เควสต์ที่เหมาะกับเลเวลนี้"
        return LevelFarm.cachedInfo, LevelFarm.cachedError
    end

    local quests = LevelFarm.quests
    if not quests then
        local ok, result = pcall(function()
            return require(RS:WaitForChild("Quests"))
        end)
        if not ok or type(result) ~= "table" then
            return nil, "อ่านข้อมูลเควสต์ไม่สำเร็จ"
        end
        quests = result
        LevelFarm.quests = result
    end

    local targetTask, targetName
    for key, questList in pairs(quests) do
        if key ~= "CitizenQuest" then
            for index, questInfo in pairs(questList) do
                if questInfo and tonumber(questInfo.LevelReq) == bestLevel then
                    questName, questIndex = key, index
                    for taskName in pairs(questInfo.Task or {}) do
                        targetTask = tostring(taskName)
                        targetName = string.split(targetTask, " [Lv. " .. tostring(bestLevel) .. "]")[1]
                        break
                    end
                end
            end
        end
    end

    if level >= 1 and level <= 9 then
        questIndex = 1
        if teamName == "Marines" then
            questName, targetTask, targetName = "MarineQuest", "Trainee", "Trainee"
        else
            questName, targetTask, targetName = "BanditQuest1", "Bandit", "Bandit"
        end
    elseif level >= 210 and level <= 249 then
        questName, questIndex = "PrisonerQuest", 2
        targetTask, targetName = "Dangerous Prisoner", "Dangerous Prisoner"
    end

    -- These quest entries have game-specific aliases in the server remote.
    if questName == "ImpelQuest" then
        questName, questIndex = "PrisonerQuest", 2
        targetTask, targetName = "Dangerous Prisoner", "Dangerous Prisoner"
    elseif questName == "Area2Quest" and questIndex == 2 then
        questIndex, targetTask, targetName = 1, "Swan Pirate", "Swan Pirate"
    end
    if level >= 2500 and level <= 2524 then
        targetTask, targetName = "Sun-kissed Warrior", "Sun-kissed Warrior"
    end
    if not questName or not questIndex or not targetName then
        LevelFarm.cachedLevel, LevelFarm.cachedTeam = level, teamName
        LevelFarm.cachedInfo, LevelFarm.cachedError = nil, "ไม่พบเป้าหมายมอนสเตอร์ของเควสต์เลเวลนี้"
        return LevelFarm.cachedInfo, LevelFarm.cachedError
    end

    LevelFarm.cachedLevel, LevelFarm.cachedTeam = level, teamName
    LevelFarm.cachedInfo = {
        level = bestLevel,
        giverCFrame = giverCFrame,
        questName = questName,
        questIndex = questIndex,
        taskName = targetTask,
        enemyName = targetName,
    }
    LevelFarm.cachedError = nil
    return LevelFarm.cachedInfo
end
function LevelFarm.stop()
    State.levelFarmOn = false
    State.levelFarmStatus = "ปิดระบบฟาร์มเลเวล"
    cleanupFly()
    disableNoclip()
    if State.levelLoopThread then pcall(task.cancel, State.levelLoopThread) State.levelLoopThread = nil end
end

function LevelFarm.start()
    if State.levelFarmOn then return true end
    if State.autoFarm or State.seaFarmOn or State.eliteOn or State.chestOn or State.adminBossOn or State.fruitFinderFlying then
        State.levelFarmStatus = "ปิดโหมดฟาร์มอื่นก่อน"
        return false
    end
    if not CommF or not HitEvent then
        State.levelFarmStatus = "ไม่พบระบบเควสต์/โจมตี"
        return false
    end
    State.levelFarmOn = true
    enableNoclip()
    State.levelLoopThread = task.spawn(function()
        local lastQuestKey
        local alive = function() return State.levelFarmOn end
        local ok, err = pcall(function()
            while alive() do
                enableNoclip()
                local level = tonumber(State.level) or 1
                local questInfo, questError = LevelFarm.getQuestInfo(level)
                if not questInfo then
                    State.levelFarmStatus = level >= 3000 and "ถึงเลเวลสูงสุด 3000" or (questError or "กำลังค้นหา NPC เควสต์")
                    task.wait(2)
                else
                    local questKey = questInfo.questName .. ":" .. tostring(questInfo.questIndex)
                    State.quest, State.mob = questKey, questInfo.enemyName
                    if lastQuestKey ~= questKey or not (playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("Quest") and playerGui.Main.Quest.Visible) then
                        if lastQuestKey then pcall(function() CommF:InvokeServer("AbandonQuest") end) end
                        State.levelFarmStatus = "กำลังไปรับเควสต์: " .. questInfo.enemyName
                        local giverPosition = questInfo.giverCFrame.Position
                        if requeststreamaroundasync then pcall(requeststreamaroundasync, giverPosition) end
                        local from = getHRP()
                        local distance = from and (from.Position - giverPosition).Magnitude or math.huge
                        if distance > 3000 then
                            local entrance
                            if level >= 375 and level <= 449 then
                                entrance = Vector3.new(61163.85, 11.6797, 1819.7842)
                            elseif level >= 450 and level <= 474 then
                                entrance = Vector3.new(-4607.8228, 872.5425, -1667.5569)
                            elseif level >= 475 and level <= 624 then
                                entrance = Vector3.new(-7894.6177, 5547.1416, -380.2912)
                            end
                            if entrance then
                                pcall(function() CommF:InvokeServer("requestEntrance", entrance) end)
                                task.wait(0.5)
                                from = getHRP()
                                distance = from and (from.Position - giverPosition).Magnitude or math.huge
                            end
                        end
                        local arrived = distance < 12 or flyToPoint(giverPosition + Vector3.new(0, 5, 0), 5, math.max(8, distance / math.max(State.speed * CONFIG.FlySpeedMul, 1) + 5), alive)
                        if arrived and alive() then
                                task.wait(0.2)
                                pcall(function() CommF:InvokeServer("StartQuest", questInfo.questName, questInfo.questIndex) end)
                                task.wait(0.8)
                                local main = playerGui:FindFirstChild("Main")
                                local questGui = main and main:FindFirstChild("Quest")
                                if questGui and questGui.Visible then
                                    lastQuestKey = questKey
                                    State.levelFarmStatus = "รับเควสต์แล้ว: " .. questInfo.enemyName
                                else
                                    State.levelFarmStatus = "รับเควสต์ไม่สำเร็จ ลองใหม่"
                                end
                        else
                            State.levelFarmStatus = "ไปยัง NPC รับเควสต์ไม่สำเร็จ"
                        end
                        if State.levelFarmStatus ~= "รับเควสต์แล้ว: " .. questInfo.enemyName then task.wait(2) end
                    else
                        State.levelFarmStatus = "กำลังฟาร์ม: " .. questInfo.enemyName
                        ensureBuso()
                        equipWeapon()
                        local targetNames = { questInfo.taskName, questInfo.enemyName }
                        local enemy = getNearestEnemy(targetNames)
                        if enemy then
                            local hrp, part = getHRP(), getEnemyPart(enemy)
                            State.dist = (hrp and part) and string.format("%.0fm", (hrp.Position - part.Position).Magnitude) or "-"
                            flyToEnemy(enemy, alive)
                            circleAndAttack(enemy, CONFIG.MaxAttackTime, targetNames, nil, nil, alive)
                        else
                            State.dist = "รอมอนเกิด"
                            task.wait(0.7)
                        end
                    end
                end
                task.wait(0.15)
            end
        end)
        if not ok then warn("[LevelFarm] " .. tostring(err)) end
        cleanupFly()
        State.levelFarmOn = false
        disableNoclip()
        State.levelFarmStatus = "หยุดฟาร์มเลเวล"
        State.levelLoopThread = nil
    end)
    return true
end

------------------------------------------------------------
-- Elite Hunter
------------------------------------------------------------
local function requestEliteQuest()
    if not CommF then return nil end
    local ok, res = pcall(function() return CommF:InvokeServer("EliteHunter") end)
    print("[Elite] EliteHunter ->", ok and tostring(res) or ("error: " .. tostring(res)))
    return ok and res or nil
end

-- read GUI texts that mention elite / hunter / boss names (skips our own HUD)
local function readEliteTexts()
    local found, seen = {}, {}
    local keys = { "elite", "hunter" }
    for _, n in ipairs(CONFIG.Elite.bosses) do keys[#keys + 1] = n:lower() end
    pcall(function()
        for _, d in ipairs(playerGui:GetDescendants()) do
            if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Text and d.Text ~= ""
               and not d:FindFirstAncestor("RbotHud") then
                local low = d.Text:lower()
                for _, k in ipairs(keys) do
                    if low:find(k, 1, true) then
                        local clean = (d.Text:gsub("<[^>]+>", ""))
                        clean = (clean:gsub("%s+", " "))
                        if not seen[clean] then
                            seen[clean] = true
                            found[#found + 1] = clean
                        end
                        break
                    end
                end
            end
        end
    end)
    return found
end

-- pull a boss name and a known island out of a text line
local function parseEliteHint(text)
    local low = text:lower()
    local boss, island
    for _, n in ipairs(CONFIG.Elite.bosses) do
        if low:find(n:lower(), 1, true) then boss = n break end
    end
    for name, pos in pairs(CONFIG.Elite.islands) do
        if low:find(name:lower(), 1, true) then island = { name = name, pos = pos } break end
    end
    return boss, island
end

-- find a living elite boss: (1) loaded in workspace, else (2) the server copy in
-- ReplicatedStorage (spawned but not streamed in on this client yet)
-- returns: model, distance, source ("ws" or "rs")
local function findEliteAny()
    local wants = {}
    for _, n in ipairs(CONFIG.Elite.bosses) do wants[#wants + 1] = n:lower() end
    local function matches(name)
        local low = name:lower()
        for _, w in ipairs(wants) do
            if low == w or low:find(w, 1, true) then return true end
        end
        return false
    end

    local hrp = getHRP()
    local pos = hrp and hrp.Position
    local best, bestD
    local containers = {}
    local en = workspace:FindFirstChild("Enemies")
    if en then containers[#containers + 1] = en end
    containers[#containers + 1] = workspace
    for _, c in ipairs(containers) do
        for _, obj in ipairs(c:GetChildren()) do
            if obj:IsA("Model") and obj ~= lp.Character and matches(obj.Name) then
                local ign = State.ignore and State.ignore[obj]
                if not (ign and tick() < ign) then
                    local hum  = obj:FindFirstChildOfClass("Humanoid")
                    local part = getEnemyPart(obj)
                    if hum and hum.Health > 0 and part then
                        local d = pos and (pos - part.Position).Magnitude or 0
                        if not bestD or d < bestD then best, bestD = obj, d end
                    end
                end
            end
        end
        if best and c ~= workspace then break end
    end
    if best then return best, bestD, "ws" end

    for _, obj in ipairs(RS:GetChildren()) do
        if obj:IsA("Model") and matches(obj.Name) then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if (not hum or hum.Health > 0) and getEnemyPart(obj) then
                return obj, 0, "rs"
            end
        end
    end
    return nil
end

local function stopElite()
    State.eliteOn  = false
    State.autoFarm = false
    disableNoclip()
    cleanupFly()
    local hrp = getHRP()
    if hrp then
        hrp.Anchored = false
        hrp.AssemblyLinearVelocity  = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
end

local function runElite(onStatus)
    onStatus = onStatus or function() end
    if State.eliteOn then return end
    if State.autoFarm or State.levelFarmOn then
        onStatus("\224\184\155\224\184\180\224\184\148\224\184\159\224\184\178\224\184\163\224\185\140\224\184\161\224\184\129\224\185\136\224\184\173\224\184\153")
        return
    end
    if not CommF or not HitEvent then
        onStatus("\224\185\132\224\184\161\224\185\136\224\184\158\224\184\154\224\184\163\224\184\181\224\185\130\224\184\161\224\184\149")
        return
    end

    local cfg = CONFIG.Elite
    State.eliteOn  = true
    State.autoFarm = true -- lets the existing fly/attack helpers run (cleared when done)
    enableNoclip()
    local function alive() return State.eliteOn and State.autoFarm end

    local ok, err = pcall(function()
        onStatus("\224\184\163\224\184\177\224\184\154\224\185\128\224\184\132\224\184\167\224\184\170...")
        requestEliteQuest()
        local lastQuest, lastText = tick(), 0
        local seenTexts, hint = {}, nil
        State.quest = "Elite"

        while alive() do
            local char = lp.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if not char or not hum or hum.Health <= 0 or not getHRP() then
                onStatus("\224\184\163\224\184\173\224\185\128\224\184\129\224\184\180\224\184\148\224\185\131\224\184\171\224\184\161\224\185\136...")
                task.wait(1)
            else
                ensureBuso()
                local now = tick()

                -- read the on-screen message about where the elite spawned
                if now - lastText >= cfg.textInterval then
                    lastText = now
                    for _, t in ipairs(readEliteTexts()) do
                        if not seenTexts[t] then
                            seenTexts[t] = true
                            print("[Elite] text: " .. t)
                            local boss, island = parseEliteHint(t)
                            if boss or island then hint = { boss = boss, island = island, text = t } end
                        end
                    end
                end

                local elite, _, src = findEliteAny()
                if elite and src == "rs" then
                    -- spawned, but not loaded on this client yet: go to the server copy's position
                    local part = getEnemyPart(elite)
                    local pos = part and part.Position
                    State.mob = elite.Name
                    if pos then
                        local h = getHRP()
                        if h and (h.Position - pos).Magnitude > 60 then
                            onStatus("\224\184\154\224\184\180\224\184\153\224\185\132\224\184\155\224\184\171\224\184\178 " .. elite.Name)
                            print("[Elite] spawned (server copy): " .. elite.Name .. " at " .. tostring(pos))
                            if requeststreamaroundasync then
                                pcall(requeststreamaroundasync, pos)
                                task.wait(0.3)
                            end
                            flyToPoint(pos + Vector3.new(0, cfg.hoverHeight, 0), 10, 240, alive)
                        else
                            onStatus("\224\184\163\224\184\173\224\185\130\224\184\171\224\184\165\224\184\148\224\184\154\224\184\173\224\184\170...")
                            if requeststreamaroundasync then pcall(requeststreamaroundasync, pos) end
                        end
                        lockHRP(getHRP())
                    end
                    task.wait(1)
                elseif elite then
                    State.mob = elite.Name
                    onStatus("\224\184\149\224\184\181 " .. elite.Name)
                    local part = getEnemyPart(elite)
                    if part and requeststreamaroundasync then
                        pcall(requeststreamaroundasync, part.Position)
                    end
                    local t0 = tick()
                    while alive() and not isEnemyDead(elite) and tick() - t0 < cfg.killTimeout do
                        local h, p = getHRP(), getEnemyPart(elite)
                        State.dist = (h and p) and string.format("%.0fm", (h.Position - p.Position).Magnitude) or "-"
                        flyToEnemy(elite)
                        if not alive() then break end
                        circleAndAttack(elite, CONFIG.MaxAttackTime, { elite.Name })
                        local c2 = lp.Character
                        local h2 = c2 and c2:FindFirstChildOfClass("Humanoid")
                        if not h2 or h2.Health <= 0 then break end
                    end
                    if alive() and isEnemyDead(elite) then
                        print("[Elite] defeated: " .. elite.Name)
                        onStatus("\224\184\149\224\184\178\224\184\162\224\185\129\224\184\165\224\185\137\224\184\167 \224\184\163\224\184\177\224\184\154\224\185\128\224\184\132\224\184\167\224\184\170\224\184\149\224\185\136\224\184\173...")
                        State.mob, State.dist = "-", "-"
                        task.wait(2)
                        requestEliteQuest()
                        lastQuest, hint = tick(), nil
                    end
                else
                    -- not spawned (or not loaded yet): do NOT attack anything
                    State.mob, State.dist = "-", "-"
                    if hint and hint.island and hint.flownTo ~= hint.island.name then
                        hint.flownTo = hint.island.name
                        onStatus("\224\184\154\224\184\180\224\184\153\224\185\132\224\184\155 " .. hint.island.name)
                        if requeststreamaroundasync then
                            pcall(requeststreamaroundasync, hint.island.pos)
                            task.wait(0.3)
                        end
                        flyToPoint(hint.island.pos + Vector3.new(0, cfg.hoverHeight, 0), 8, 120)
                    else
                        onStatus(hint and hint.boss and ("\224\184\163\224\184\173 " .. hint.boss .. " \224\185\128\224\184\129\224\184\180\224\184\148...") or "\224\184\162\224\184\177\224\184\135\224\185\132\224\184\161\224\185\136\224\185\128\224\184\129\224\184\180\224\184\148 \224\184\163\224\184\173...")
                    end
                    lockHRP(getHRP())
                    if now - lastQuest >= cfg.questInterval then
                        requestEliteQuest()
                        lastQuest = now
                    end
                    task.wait(cfg.pollInterval)
                end
            end
        end
    end)

    local cancelled = not State.eliteOn
    stopElite()
    if not ok then
        warn("[Elite] " .. tostring(err))
        onStatus("\224\185\128\224\184\129\224\184\180\224\184\148\224\184\130\224\185\137\224\184\173\224\184\156\224\184\180\224\184\148\224\184\158\224\184\165\224\184\178\224\184\148")
    elseif cancelled then
        onStatus("\224\184\162\224\184\129\224\185\128\224\184\165\224\184\180\224\184\129\224\185\129\224\184\165\224\185\137\224\184\167")
    end
end

------------------------------------------------------------
-- Admin Boss: rip_indra; attack only when alive at its spawn location
------------------------------------------------------------
local ADMIN_BOSS_SPAWN = Vector3.new(-5380.8798828125, 343.8699951171875, -2554.006103515625)
local ADMIN_BOSS_SPAWN_RADIUS = 600

local function findRipIndraAtSpawn()
    local containers = {}
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then containers[#containers + 1] = enemies end
    containers[#containers + 1] = workspace
    local seen = {}
    for _, container in ipairs(containers) do
        for _, obj in ipairs(container:GetChildren()) do
            if not seen[obj] and obj:IsA("Model") and obj.Name:lower() == "rip_indra" then
                seen[obj] = true
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local part = getEnemyPart(obj)
                if hum and hum.Health > 0 and part
                    and (part.Position - ADMIN_BOSS_SPAWN).Magnitude <= ADMIN_BOSS_SPAWN_RADIUS then
                    return obj
                end
            end
        end
    end
    return nil
end

local function stopAdminBoss()
    State.adminBossOn = false
    State.autoFarm = false
    disableNoclip()
    cleanupFly()
    local hrp = getHRP()
    if hrp then
        hrp.Anchored = false
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
end

local function runAdminBoss(onStatus)
    onStatus = onStatus or function() end
    if State.adminBossOn then return end
    if State.autoFarm or State.levelFarmOn or State.eliteOn or State.chestOn then
        onStatus("หยุดโหมดฟาร์มอื่นก่อน")
        return
    end
    if not HitEvent then
        onStatus("ไม่พบระบบโจมตี")
        return
    end
    State.adminBossOn = true
    State.autoFarm = true
    enableNoclip()
    local function alive() return State.adminBossOn and State.autoFarm end
    local ok, err = pcall(function()
        while alive() do
            local char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not char or not hum or hum.Health <= 0 or not getHRP() then
                onStatus("รอตัวละครพร้อม...")
                task.wait(1)
            else
                ensureBuso()
                local boss = findRipIndraAtSpawn()
                if not boss then
                    State.mob, State.dist = "-", "-"
                    onStatus("รอ rip_indra เกิด...")
                    task.wait(1)
                else
                    State.mob = boss.Name
                    onStatus("กำลังตี " .. boss.Name)
                    local t0 = tick()
                    while alive() and not isEnemyDead(boss) and tick() - t0 < 240 do
                        if findRipIndraAtSpawn() ~= boss then break end
                        local h, part = getHRP(), getEnemyPart(boss)
                        if not h or not part then break end
                        State.dist = string.format("%.0fm", (h.Position - part.Position).Magnitude)
                        flyToEnemy(boss)
                        if not alive() or findRipIndraAtSpawn() ~= boss then break end
                        circleAndAttack(boss, CONFIG.MaxAttackTime, { "rip_indra" })
                    end
                    State.mob, State.dist = "-", "-"
                    if alive() then task.wait(1) end
                end
            end
        end
    end)
    stopAdminBoss()
    if not ok then
        warn("[AdminBoss] " .. tostring(err))
        onStatus("เกิดข้อผิดพลาด")
    end
end
------------------------------------------------------------
-- Auto Farm Chest
------------------------------------------------------------
local CollectionService = game:GetService("CollectionService")

local function getBeli()
    local d = lp:FindFirstChild("Data")
    local b = d and d:FindFirstChild("Beli")
    return b and tonumber(b.Value)
end

-- list chests: tagged "_ChestTagged" first, then workspace.ChestModels, then a name scan
local lastChestScan = 0
local function listChests()
    local out, seen = {}, {}
    local function add(obj)
        if seen[obj] or not obj:IsDescendantOf(workspace) then return end
        local part = obj
        if obj:IsA("Model") then
            part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        end
        if part and part:IsA("BasePart") then
            seen[obj] = true
            out[#out + 1] = { inst = obj, part = part, tagged = CollectionService:HasTag(obj, "_ChestTagged") }
        end
    end
    pcall(function()
        for _, v in ipairs(CollectionService:GetTagged("_ChestTagged")) do add(v) end
    end)
    if #out == 0 then
        local models = workspace:FindFirstChild("ChestModels")
        if models then
            for _, v in ipairs(models:GetChildren()) do add(v) end
        end
    end
    if #out == 0 and tick() - lastChestScan > 10 then
        lastChestScan = tick()
        pcall(function()
            for _, v in ipairs(workspace:GetDescendants()) do
                if (v:IsA("BasePart") or v:IsA("Model")) and v.Name:match("^Chest%d$") then
                    add(v)
                end
            end
        end)
    end
    return out
end

-- island points: workspace._WorldOrigin.Locations (+ CONFIG.Chest.extraIslands)
local function getIslands()
    local list = {}
    local extra = CONFIG.Chest.extraIslands or {}
    if #extra > 0 and not CONFIG.Chest.mergeLocations then
        for _, e in ipairs(extra) do list[#list + 1] = e end
        return list
    end
    pcall(function()
        local wo  = workspace:FindFirstChild("_WorldOrigin")
        local loc = wo and wo:FindFirstChild("Locations")
        if loc then
            for _, v in ipairs(loc:GetChildren()) do
                local pos
                if v:IsA("BasePart") then
                    pos = v.Position
                elseif v:IsA("Model") then
                    pos = v:GetPivot().Position
                end
                if pos then list[#list + 1] = { name = v.Name, pos = pos } end
            end
        end
    end)
    for _, e in ipairs(CONFIG.Chest.extraIslands or {}) do list[#list + 1] = e end
    return list
end

local function stopChest()
    State.chestOn  = false
    State.autoFarm = false
    disableNoclip()
    cleanupFly()
    local hrp = getHRP()
    if hrp then
        hrp.Anchored = false
        hrp.AssemblyLinearVelocity  = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
end

local function runChest(onStatus)
    onStatus = onStatus or function() end
    if State.chestOn then return end
    if State.autoFarm or State.levelFarmOn or State.eliteOn then
        onStatus("\224\184\155\224\184\180\224\184\148\224\185\130\224\184\171\224\184\161\224\184\148\224\184\173\224\184\183\224\185\136\224\184\153\224\184\129\224\185\136\224\184\173\224\184\153")
        return
    end

    local cfgC = CONFIG.Chest
    local islands = getIslands()
    if #islands == 0 then
        onStatus("\224\185\132\224\184\161\224\185\136\224\184\158\224\184\154\224\184\163\224\184\178\224\184\162\224\184\138\224\184\183\224\185\136\224\184\173\224\185\128\224\184\129\224\184\178\224\184\176")
        print("[Chest] no island list - fill CONFIG.Chest.extraIslands")
        return
    end

    State.chestOn  = true
    State.autoFarm = true -- lets the existing fly/noclip helpers run (cleared when done)
    State.chestIgnore = {}
    enableNoclip()
    local count = 0
    local function alive() return State.chestOn and State.autoFarm end
    local function gone(inst) return not inst.Parent or not inst:IsDescendantOf(workspace) end

    local ok, err = pcall(function()
        -- tour: start at the island nearest to us, then follow the list order, wrap to the first
        local idx = 1
        do
            local h = getHRP()
            if h then
                local bestD
                for i, isl in ipairs(islands) do
                    local d = (isl.pos - h.Position).Magnitude
                    if not bestD or d < bestD then idx, bestD = i, d end
                end
            end
        end
        local arrived, emptyScans = false, 0

        while alive() do
            local char = lp.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local hrp  = getHRP()
            if not char or not hum or hum.Health <= 0 or not hrp then
                onStatus("\224\184\163\224\184\173\224\185\128\224\184\129\224\184\180\224\184\148\224\185\131\224\184\171\224\184\161\224\185\136...")
                arrived = false -- respawn point is elsewhere: fly back to the island
                task.wait(1)
            else
                local isl = islands[idx]
                if not arrived then
                    onStatus("\224\185\132\224\184\155 " .. isl.name)
                    print("[Chest] going to island " .. idx .. "/" .. #islands .. ": " .. isl.name)
                    if requeststreamaroundasync then
                        pcall(requeststreamaroundasync, isl.pos)
                        task.wait(0.3)
                    end
                    flyToPoint(isl.pos + Vector3.new(0, cfgC.islandHeight, 0), 25, 240, alive)
                    if not alive() then break end
                    lockHRP(getHRP())
                    task.wait(3) -- let the chests on this island load in
                    arrived, emptyScans = true, 0
                else
                    -- nearest chest that belongs to THIS island
                    local best, bestD
                    for _, c in ipairs(listChests()) do
                        local ign = State.chestIgnore[c.inst]
                        if not (ign and tick() < ign)
                           and (c.part.Position - isl.pos).Magnitude <= cfgC.islandRadius then
                            local d = (hrp.Position - c.part.Position).Magnitude
                            if not bestD or d < bestD then best, bestD = c, d end
                        end
                    end

                    if not best then
                        -- nothing left here (two empty scans): next island in the list
                        emptyScans = emptyScans + 1
                        onStatus("\224\185\128\224\184\129\224\184\178\224\184\176\224\184\153\224\184\181\224\185\137\224\184\171\224\184\161\224\184\148\224\184\171\224\184\181\224\184\154 " .. count)
                        lockHRP(hrp)
                        task.wait(2)
                        if emptyScans >= 2 then
                            idx = idx % #islands + 1
                            arrived = false
                            print("[Chest] island done -> next: " .. islands[idx].name .. " (collected " .. count .. ")")
                        end
                    else
                        emptyScans = 0
                        onStatus("\224\185\128\224\184\129\224\185\135\224\184\154\224\184\171\224\184\181\224\184\154 " .. count .. " | " .. isl.name)
                        print(("[Chest] target %s | dist %.0f | pos %s"):format(
                            best.inst.Name, bestD or -1, tostring(best.part.Position)
                        ))
                        flyToPoint(best.part.Position, 3, 90, alive)
                        if not alive() then break end

                        -- collected = chest removed, OR its tag removed, OR Beli went up
                        local beli0 = getBeli()
                        local function collected()
                            if gone(best.inst) then return true end
                            if best.tagged and not CollectionService:HasTag(best.inst, "_ChestTagged") then
                                return true
                            end
                            local b = getBeli()
                            if b and beli0 and b > beli0 then return true end
                            return false
                        end

                        local done = false
                        for attempt = 1, 3 do
                            if not alive() then break end
                            local h = getHRP()
                            if not h then break end
                            -- sit right inside the chest so the touch registers
                            pcall(function() h.CFrame = best.part.CFrame end)
                            if firetouchinterest then
                                pcall(function()
                                    firetouchinterest(h, best.part, 0)
                                    task.wait()
                                    firetouchinterest(h, best.part, 1)
                                end)
                            end
                            local t0 = tick()
                            while alive() and tick() - t0 < 1.2 do
                                if collected() then
                                    done = true
                                    break
                                end
                                task.wait(0.1)
                            end
                            print(("[Chest] attempt %d -> %s"):format(attempt, tostring(done)))
                            if done then break end
                        end
                        if not alive() then break end

                        if done then
                            count = count + 1
                            -- never come back to a chest we already took (even if its model stays)
                            State.chestIgnore[best.inst] = tick() + 600
                        else
                            State.chestIgnore[best.inst] = tick() + 60
                            print("[Chest] could not collect " .. best.inst.Name .. " - skipping for 60s")
                        end
                    end
                end
            end
        end
    end)

    local cancelled = not State.chestOn
    stopChest()
    if not ok then
        warn("[Chest] " .. tostring(err))
        onStatus("\224\185\128\224\184\129\224\184\180\224\184\148\224\184\130\224\185\137\224\184\173\224\184\156\224\184\180\224\184\148\224\184\158\224\184\165\224\184\178\224\184\148")
    elseif cancelled then
        onStatus("\224\184\171\224\184\162\224\184\184\224\184\148\224\185\129\224\184\165\224\185\137\224\184\167 \224\185\128\224\184\129\224\185\135\224\184\154\224\185\132\224\184\148\224\185\137 " .. count)
    end
end

local SEA_BOAT_DEALER = Vector3.new(-16204.908203125, 8.499295234680176, 473.990234375)
local SeaBoatRuntime = { collisionState = {}, noclipConnection = nil, noclipModel = nil, seatOriginals = {} }
local function applySeaBoatSpeed(seat)
    if not seat or not seat:IsA("VehicleSeat") then return end
    local original = SeaBoatRuntime.seatOriginals[seat]
    if not original then
        local ok, values = pcall(function()
            return { MaxSpeed = seat.MaxSpeed, Torque = seat.Torque }
        end)
        if not ok then return end
        original = values
        SeaBoatRuntime.seatOriginals[seat] = original
    end
    local speed = math.clamp(tonumber(State.seaBoatSpeed) or 250, 1, 400)
    pcall(function()
        seat.MaxSpeed = speed
        seat.Torque = math.max(1, original.Torque * speed / 100)
    end)
end
local function restoreSeaBoatSpeed()
    for seat, original in pairs(SeaBoatRuntime.seatOriginals) do
        if seat and seat.Parent then
            pcall(function()
                seat.MaxSpeed = original.MaxSpeed
                seat.Torque = original.Torque
            end)
        end
        SeaBoatRuntime.seatOriginals[seat] = nil
    end
end
local function setSeaBoatNoclip(boat, enabled)
    if enabled and (not boat or not boat.Parent) then return end
    if enabled and SeaBoatRuntime.noclipModel ~= boat then
        setSeaBoatNoclip(SeaBoatRuntime.noclipModel, false)
        SeaBoatRuntime.noclipModel = boat
    end
    if enabled then
        local function disablePartCollision(obj)
            if not obj:IsA("BasePart") then return end
            if SeaBoatRuntime.collisionState[obj] == nil then
                SeaBoatRuntime.collisionState[obj] = obj.CanCollide
            end
            if obj.CanCollide then obj.CanCollide = false end
        end
        for _, obj in ipairs(boat:GetDescendants()) do disablePartCollision(obj) end
        if not SeaBoatRuntime.noclipConnection then
            SeaBoatRuntime.noclipConnection = RunService.Stepped:Connect(function()
                if not SeaBoatRuntime.noclipModel or not SeaBoatRuntime.noclipModel.Parent then
                    setSeaBoatNoclip(SeaBoatRuntime.noclipModel, false)
                    return
                end
                for _, obj in ipairs(SeaBoatRuntime.noclipModel:GetDescendants()) do disablePartCollision(obj) end
            end)
        end
        return
    end

    if SeaBoatRuntime.noclipConnection then
        SeaBoatRuntime.noclipConnection:Disconnect()
        SeaBoatRuntime.noclipConnection = nil
    end
    for obj, canCollide in pairs(SeaBoatRuntime.collisionState) do
        if obj and obj.Parent then pcall(function() obj.CanCollide = canCollide end) end
        SeaBoatRuntime.collisionState[obj] = nil
    end
    if not boat or SeaBoatRuntime.noclipModel == boat then SeaBoatRuntime.noclipModel = nil end
end
local SEA_DANGER6_TARGET = Vector3.new(-32545.03125, 0, 30189.060546875)

local function readSeaBoatOptions()
    local dialog = playerGui:FindFirstChild("DialogueGui")
    if not dialog then return State.seaBoatOptions end
    local optionsList
    for _, obj in ipairs(dialog:GetDescendants()) do
        if obj.Name:lower() == "optionslist" then optionsList = obj break end
    end
    if not optionsList then return State.seaBoatOptions end
    local out, seen = {}, {}
    for _, obj in ipairs(optionsList:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("TextLabel") then
            local text = obj.Text:gsub("^%s+", ""):gsub("%s+$", "")
            local low = text:lower()
            local isAction = low == "cancel" or low == "close" or low == "buy" or low == "buy boat"
                or low == "never mind" or low == "nevermind" or low == "back" or low == "purchase"
                or low:find("price", 1, true) or low:find(" beli", 1, true)
                or low:find("$", 1, true) or low:find("฿", 1, true)
            if text ~= "" and not isAction and not seen[low] then
                seen[low] = true
                table.insert(out, text)
            end
        end
    end
    if #out > 0 then State.seaBoatOptions = out end
    return State.seaBoatOptions
end

local function isSelectedSeaTarget(name)
    local normalized = name:lower():gsub("%W", "")
    local isSeaBeast = normalized == "seabeast" or normalized == "seabeast1"
        or normalized == "seaking" or normalized == "kingofthesea"
    local isGhostShip = normalized == "ghostship"
        or normalized == "pirategrandbrigade"
        or normalized == "piratebrigade"
        or normalized == "fishboat"
    return (State.seaTargets.SeaBeast and isSeaBeast)
        or (State.seaTargets.Terrorshark and normalized == "terrorshark")
        or (State.seaTargets.Piranha and normalized == "piranha")
        or (State.seaTargets.Shark and normalized == "shark")
        or (State.seaTargets.FishCrewMember and normalized == "fishcrewmember")
        or (State.seaTargets.GhostShip and isGhostShip)
end

local seaTargetScanAt, seaTargetScanResult = 0, nil
local function findSelectedSeaTarget()
    local now = tick()
    local function isUsableTarget(obj)
        if not obj or not obj.Parent or not obj:IsA("Model") or not isSelectedSeaTarget(obj.Name) then return false end
        local hum = obj:FindFirstChildOfClass("Humanoid")
        return (hum and hum.Health > 0) or (not hum and getEnemyPart(obj) ~= nil)
    end

    -- Keep repeated combat checks cheap, but invalidate immediately when the target
    -- dies, despawns, or becomes unavailable.
    if now - seaTargetScanAt < 0.25 and isUsableTarget(seaTargetScanResult) then
        return seaTargetScanResult
    end
    if not isUsableTarget(seaTargetScanResult) then seaTargetScanResult = nil end
    if now - seaTargetScanAt < 0.25 then return nil end
    seaTargetScanAt = now

    local hrp, best, bestDist = getHRP(), nil, math.huge
    -- Sea events can be parented under folders/models inside Workspace, so search
    -- descendants instead of only direct children of Workspace and Enemies. Keep
    -- enemy event boats eligible while excluding only our own selected boat.
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= lp.Character and isSelectedSeaTarget(obj.Name)
            and obj ~= State.seaBoatModel
        then
            local shadowedByMatchingModel = false
            local ancestor = obj.Parent
            while ancestor and ancestor ~= workspace do
                if ancestor:IsA("Model") and isSelectedSeaTarget(ancestor.Name) then
                    shadowedByMatchingModel = true
                    break
                end
                ancestor = ancestor.Parent
            end
            if not shadowedByMatchingModel then
                local hum, part = obj:FindFirstChildOfClass("Humanoid"), getEnemyPart(obj)
                -- Some sea event models have no Humanoid; their live model and
                -- target part are the available signals that they can be attacked.
                if part and ((hum and hum.Health > 0) or not hum) then
                    local d = hrp and (hrp.Position - part.Position).Magnitude or 0
                    -- During the attack batch, include every selected sea target
                    -- currently spawned, regardless of distance. This prevents the
                    -- controller from returning to the boat between distant targets.
                    if d < bestDist then best, bestDist = obj, d end
                end
            end
        end
    end
    seaTargetScanResult = best
    return best
end

local function getActiveBoat()
    local boats = workspace:FindFirstChild("Boats")
    if not boats then return nil end
    local best, bestDist
    for _, boat in ipairs(boats:GetChildren()) do
        if boat:IsA("Model") and (not State.seaSelectedBoat or boat.Name:lower():find(State.seaSelectedBoat:lower(), 1, true)) then
            local seat = boat:FindFirstChildWhichIsA("VehicleSeat", true) or boat:FindFirstChildWhichIsA("Seat", true)
            local part = boat.PrimaryPart or seat or boat:FindFirstChildWhichIsA("BasePart", true)
            if seat and part then
                local d = (part.Position - SEA_BOAT_DEALER).Magnitude
                if not bestDist or d < bestDist then best, bestDist = boat, d end
            end
        end
    end
    return best
end

local function isAtSeaZoneTarget(boat)
    if not boat or not boat.Parent then return false end
    local part = boat.PrimaryPart or boat:FindFirstChildWhichIsA("VehicleSeat", true) or boat:FindFirstChildWhichIsA("BasePart", true)
    return part and (Vector3.new(part.Position.X, 0, part.Position.Z) - Vector3.new(SEA_DANGER6_TARGET.X, 0, SEA_DANGER6_TARGET.Z)).Magnitude <= 180 or false
end

local function reseatOnSeaBoat(boat, isRunning)
    if not boat or not boat.Parent or (isRunning and not isRunning()) then return false end
    local seat = boat:FindFirstChildWhichIsA("VehicleSeat", true) or boat:FindFirstChildWhichIsA("Seat", true)
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not seat or not hum or hum.Health <= 0 or not root then return false end
    if seat.Occupant == hum then return true end
    pcall(function()
        hum.Sit = false
        root.CFrame = seat.CFrame * CFrame.new(0, 2.5, 0)
        seat:Sit(hum)
    end)
    return true
end

local function buyAndSailToSeaSix(isRunning, onStatus)
    local boat = State.seaBoatModel
    if not boat or not boat.Parent then boat = getActiveBoat() end
    if not boat then
        local reached = flyToPoint(SEA_BOAT_DEALER, 12, 120, isRunning)
        if not reached or not isRunning() then return false end
        if not CommF then onStatus("ไม่พบระบบซื้อเรือ") return false end
        onStatus("กำลังซื้อ " .. State.seaSelectedBoat)
        local ok, result = pcall(function() return CommF:InvokeServer("BuyBoat", State.seaSelectedBoat) end)
        if not ok or result == false then onStatus("ซื้อเรือไม่สำเร็จ") return false end
        local deadline = tick() + 20
        repeat
            task.wait(0.5)
            boat = getActiveBoat()
        until boat or tick() >= deadline or not isRunning()
    end
    if not boat or not boat.Parent or not isRunning() then onStatus("หาเรือไม่พบ") return false end
    State.seaBoatModel = boat
    if isAtSeaZoneTarget(boat) then
        setSeaBoatNoclip(boat, true)
        return true
    end

    local seat = boat:FindFirstChildWhichIsA("VehicleSeat", true) or boat:FindFirstChildWhichIsA("Seat", true)
    local char, hum = lp.Character, lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if not seat or not hum then onStatus("รอที่นั่งเรือ") return false end
    applySeaBoatSpeed(seat)
    pcall(function() seat:Sit(hum) end)
    task.wait(1)
    setSeaBoatNoclip(boat, true)
    onStatus("กำลังเคลื่อนเรือไปพิกัดอีเว้นทะเล...")
    local nextTargetScan = 0
    local nextSeatCheck = 0
    while isRunning() and boat.Parent and seat.Parent do
        -- Stop sailing as soon as a selected sea event appears; the main loop
        -- will leave the boat and fight it, even when it spawned in Sea 1-5.
        if tick() >= nextTargetScan then
            nextTargetScan = tick() + 0.5
            local boatPart = boat.PrimaryPart or seat
            local horizontalFromDealer = Vector3.new(boatPart.Position.X - SEA_BOAT_DEALER.X, 0, boatPart.Position.Z - SEA_BOAT_DEALER.Z).Magnitude
            -- Leave the dealer area first; a nearby spawn must not cancel launch
            -- and make the character start fighting before the boat sets out.
            if findSelectedSeaTarget() and (horizontalFromDealer > 3000 or isAtSeaZoneTarget(boat)) then
                return false
            end
        end
        if tick() >= nextSeatCheck then
            nextSeatCheck = tick() + 0.75
            reseatOnSeaBoat(boat, isRunning)
        end
        local part = boat.PrimaryPart or seat
        local pos = part.Position
        local toGoal = Vector3.new(SEA_DANGER6_TARGET.X - pos.X, 0, SEA_DANGER6_TARGET.Z - pos.Z)
        if toGoal.Magnitude <= 180 then
            return true
        end

        applySeaBoatSpeed(seat)
        local step = math.min(math.clamp(State.seaBoatSpeed, 1, 400) * 0.05, toGoal.Magnitude)
        local displacement = toGoal.Unit * step
        pcall(function() boat:PivotTo(boat:GetPivot() + displacement) end)
        task.wait(0.05)
    end
    setSeaBoatNoclip(boat, false)
    return false
end

local function stopSeaFarm()
    setSeaBoatNoclip(State.seaBoatModel, false)
    restoreSeaBoatSpeed()
    State.seaFarmOn = false
    State.autoFarm = false
    disableNoclip()
    cleanupFly()
    local vim
    pcall(function() vim = game:GetService("VirtualInputManager") end)
    if vim then
        pcall(function() vim:SendKeyEvent(false, Enum.KeyCode.W, false, game) end)
        pcall(function() vim:SendKeyEvent(false, Enum.KeyCode.A, false, game) end)
        pcall(function() vim:SendKeyEvent(false, Enum.KeyCode.D, false, game) end)
    end
    local hrp = getHRP()
    if hrp then hrp.Anchored = false end
end

local function runSeaFarm(onStatus)
    onStatus = onStatus or function() end
    if State.autoFarm or State.levelFarmOn or State.eliteOn or State.chestOn or State.adminBossOn then
        State.seaFarmOn = false
        onStatus("หยุดโหมดฟาร์มอื่นก่อน")
        return
    end
    if not State.seaSelectedBoat then State.seaFarmOn = false onStatus("เลือกเรือก่อน") return end
    if not HitEvent then State.seaFarmOn = false onStatus("ไม่พบระบบโจมตี") return end
    State.seaFarmOn, State.autoFarm = true, true
    enableNoclip()
    local function alive() return State.seaFarmOn and State.autoFarm end
    local function returnToSeaBoat()
        local boat = State.seaBoatModel
        if not boat or not boat.Parent then
            boat = getActiveBoat()
            State.seaBoatModel = boat
        end
        local seat = boat and boat.Parent and (boat:FindFirstChildWhichIsA("VehicleSeat", true) or boat:FindFirstChildWhichIsA("Seat", true))
        if not alive() or not seat or not seat.Parent then return false end
        onStatus("กลับไปขับเรือ...")
        local root = getHRP()
        if root then
            local goal = seat.Position + Vector3.new(0, 2.5, 0)
            local distance = (root.Position - goal).Magnitude
            flyToPoint(goal, 3, math.max(10, distance / math.max(State.speed * CONFIG.FlySpeedMul, 1) + 8), alive)
        end
        for _ = 1, 12 do
            if not alive() or not seat.Parent then return false end
            local char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local currentRoot = getHRP()
            if not hum or not currentRoot then
                task.wait(0.25)
            elseif seat.Occupant == hum or hum.Sit then
                onStatus("ขึ้นเรือแล้ว")
                return true
            else
                local seatGoal = seat.Position + Vector3.new(0, 2.5, 0)
                if (currentRoot.Position - seatGoal).Magnitude > 8 then
                    flyToPoint(seatGoal, 3, 10, alive)
                else
                    pcall(function() currentRoot.CFrame = seat.CFrame * CFrame.new(0, 2.5, 0) end)
                end
                hum.Sit = false
                pcall(function() seat:Sit(hum) end)
                task.wait(0.3)
            end
        end
        onStatus("ยังขึ้นเรือไม่สำเร็จ กำลังลองใหม่")
        return false
    end
    local function pressSeaSkills()
        local vim
        pcall(function() vim = game:GetService("VirtualInputManager") end)
        if not vim then return end
        local weaponOrder = { "Melee", "Fruit", "Sword", "Gun" }
        local skillOrder = { "Z", "X", "C", "V" }
        -- Cycle each enabled weapon for each enabled skill (e.g. Melee Z, Gun Z,
        -- Melee X, Gun X). Basic hits still run in circleAndAttack every tick,
        -- including while a skill is cooling down.
        for _, skillName in ipairs(skillOrder) do
            if State.seaSkills[skillName] then
                for _, category in ipairs(weaponOrder) do
                    local cooldownKey = category .. ":" .. skillName
                    if State.seaWeaponTypes[category]
                        and tick() - (State.seaSkillLast[cooldownKey] or 0) >= 0.75
                        and equipWeapon(category)
                    then
                        local code = Enum.KeyCode[skillName]
                        FruitFinder.pressFarmSkill(vim, code)
                        State.seaSkillLast[cooldownKey] = tick()
                    end
                end
            end
        end
    end
    local ok, err = pcall(function()
        while alive() do
            local target = findSelectedSeaTarget()
            if target then
                local boat = State.seaBoatModel
                if not boat or not boat.Parent then
                    boat = getActiveBoat()
                    State.seaBoatModel = boat
                end
                local boatPart = boat and (boat.PrimaryPart or boat:FindFirstChildWhichIsA("VehicleSeat", true) or boat:FindFirstChildWhichIsA("BasePart", true))
                local nearDealer = boatPart and (Vector3.new(boatPart.Position.X - SEA_BOAT_DEALER.X, 0, boatPart.Position.Z - SEA_BOAT_DEALER.Z).Magnitude <= 3000)
                if not boat or (nearDealer and not isAtSeaZoneTarget(boat)) then
                    -- Do not engage a sea target on foot. Purchase/find the selected
                    -- boat first and leave the dealer area before pausing to fight.
                    onStatus("กำลังออกเรือก่อนเริ่มตี...")
                    buyAndSailToSeaSix(alive, onStatus)
                    task.wait(0.25)
                else
                local seat = boat:FindFirstChildWhichIsA("VehicleSeat", true) or boat:FindFirstChildWhichIsA("Seat", true)
                local seatedHumanoid = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
                if not seat or not seatedHumanoid then
                    onStatus("รอที่นั่งเรือก่อนเริ่มตี...")
                    task.wait(0.25)
                elseif seat.Occupant ~= seatedHumanoid then
                    onStatus("กลับไปขึ้นเรือก่อนเริ่มตี...")
                    reseatOnSeaBoat(boat, alive)
                    task.wait(0.25)
                else
                ensureBuso()
                do
                    if seatedHumanoid and seatedHumanoid.Sit then
                        seatedHumanoid.Sit = false
                        seatedHumanoid.Jump = true
                        pcall(function() seatedHumanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        task.wait(0.35)
                    end
                end
                State.mob = target.Name
                onStatus("กำลังตี " .. target.Name)
                local t0 = tick()
                while alive() and not isEnemyDead(target) and tick() - t0 < 240 do
                    if findSelectedSeaTarget() ~= target then break end
                    local h, part = getHRP(), getEnemyPart(target)
                    if not h or not part then break end
                    local seaAttackHeight = 45
                    local normalizedTargetName = target.Name:lower():gsub("%W", "")
                    if normalizedTargetName == "seabeast" or normalizedTargetName == "seabeast1"
                        or normalizedTargetName == "seaking" or normalizedTargetName == "kingofthesea"
                    then
                        local boundsOk, boundsCFrame, boundsSize = pcall(function()
                            return target:GetBoundingBox()
                        end)
                        if boundsOk and boundsCFrame and boundsSize then
                            local topY = boundsCFrame.Position.Y + boundsSize.Y * 0.5
                            seaAttackHeight = math.clamp(topY - part.Position.Y + 35, 80, 600)
                        else
                            seaAttackHeight = 160
                        end
                    end
                    do
                        local playerHum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
                        if playerHum and playerHum.Health <= 4000 then
                            onStatus("เลือดเหลือ " .. math.floor(playerHum.Health) .. " — ขึ้นเหนือมอนรอจนถึง 9000")
                            local waitPosition = part.Position + Vector3.new(0, seaAttackHeight + 100, 0)
                            local waitTime = math.max(8, (h.Position - waitPosition).Magnitude / math.max(State.speed * CONFIG.FlySpeedMul, 1) + 6)
                            flyToPoint(waitPosition, 8, waitTime, alive)
                            local waitRoot = getHRP()
                            if waitRoot then
                                pcall(function() waitRoot.Anchored = true end)
                                while alive() and not isEnemyDead(target) do
                                    playerHum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
                                    if not playerHum or playerHum.Health >= math.min(9000, playerHum.MaxHealth) then break end
                                    local currentPart = getEnemyPart(target)
                                    if not currentPart then break end
                                    pcall(function()
                                        waitRoot.CFrame = CFrame.lookAt(currentPart.Position + Vector3.new(0, 120, 0), currentPart.Position)
                                    end)
                                    task.wait(0.5)
                                end
                                pcall(function() waitRoot.Anchored = false end)
                            end
                            if not alive() or isEnemyDead(target) or findSelectedSeaTarget() ~= target then break end
                            onStatus("เลือดถึงเกณฑ์แล้ว — กลับไปตี " .. target.Name)
                        end
                    end
                    State.dist = string.format("%.0fm", (h.Position - part.Position).Magnitude)
                    local seaGoal = part.Position + Vector3.new(0, seaAttackHeight, 0)
                    local travelTime = math.max(8, (h.Position - seaGoal).Magnitude / math.max(State.speed * CONFIG.FlySpeedMul, 1) + 6)
                    flyToPoint(seaGoal, 12, travelTime, alive)
                    if not alive() or findSelectedSeaTarget() ~= target then break end
                    circleAndAttack(target, CONFIG.MaxAttackTime, { target.Name }, seaAttackHeight, pressSeaSkills)
                end
                State.mob, State.dist = "-", "-"
                -- Keep fighting selected targets already present in the sea area;
                -- only make the trip back to the seat once the batch is clear.
                if not findSelectedSeaTarget() then
                    returnToSeaBoat()
                else
                    onStatus("ยังมีมอนที่เลือกอยู่ — ตีต่อก่อนกลับเรือ")
                end
                end
                end
            elseif not isAtSeaZoneTarget(State.seaBoatModel) then
                if not buyAndSailToSeaSix(alive, onStatus) then task.wait(1) end
            else
                State.mob, State.dist = "-", "-"
                reseatOnSeaBoat(State.seaBoatModel, alive)
                onStatus("อยู่ Danger Level 6 — รอมอนสเตอร์ที่เลือก")
                task.wait(1)
            end
        end
    end)
    stopSeaFarm()
    if not ok then warn("[SeaFarm] " .. tostring(err)) onStatus("ออโต้ฟาร์มทะเลผิดพลาด") end
end
------------------------------------------------------------
-- UI
------------------------------------------------------------
local C = {
    bg   = Color3.fromRGB(28, 28, 30),
    head = Color3.fromRGB(36, 36, 38),
    row  = Color3.fromRGB(38, 38, 40),
    line = Color3.fromRGB(48, 48, 51),
    chip = Color3.fromRGB(46, 46, 49),
    chipOn = Color3.fromRGB(27, 58, 85),
    blue = Color3.fromRGB(26, 143, 224),
    text = Color3.fromRGB(236, 236, 238),
    soft = Color3.fromRGB(200, 200, 204),
    green = Color3.fromRGB(74, 222, 128),
    off  = Color3.fromRGB(95, 95, 101),
    red  = Color3.fromRGB(255, 138, 122),
}

local function make(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    o.Parent = parent
    return o
end
local function round(o, r)
    return make("UICorner", { CornerRadius = UDim.new(0, r) }, o)
end
local function outline(o, color)
    return make("UIStroke", {
        Color = color, Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, o)
end

local gui = make("ScreenGui", {
    Name = "RbotHud", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local main = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(440, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, gui)
round(main, 10)
outline(main, C.line)
make("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, main)

local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = C.head,
    BorderSizePixel = 0,
    LayoutOrder = 1,
}, main)

make("TextLabel", {
    Text = "Rbot Hud ",
    Font = Enum.Font.GothamBold, TextSize = 16,
    TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(14, 0),
    Size = UDim2.new(1, -90, 1, 0),
}, header)

local dot = make("Frame", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -46, 0.5, 0),
    Size = UDim2.fromOffset(10, 10),
    BackgroundColor3 = C.off,
    BorderSizePixel = 0,
}, header)
round(dot, 5)

local closeBtn = make("TextButton", {
    Text = "X", Font = Enum.Font.GothamBold, TextSize = 16,
    TextColor3 = C.red, BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -10, 0.5, 0),
    Size = UDim2.fromOffset(28, 28),
}, header)

------------------------------------------------------------
--  (Sidebar) +
------------------------------------------------------------
local SIDEBAR_W = 88
local body = make("Frame", {
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    LayoutOrder = 2,
}, main)
make("UISizeConstraint", { MinSize = Vector2.new(0, 230) }, body)

--  (  body)
--  Scale  AutomaticSize
local sidebarBg = make("Frame", {
    Size = UDim2.new(0, SIDEBAR_W, 1, 0),
    BackgroundColor3 = C.head,
    BorderSizePixel = 0,
    ZIndex = 1,
}, body)
make("Frame", { --
    Position = UDim2.new(1, -1, 0, 0),
    Size = UDim2.new(0, 1, 1, 0),
    BackgroundColor3 = C.line,
    BorderSizePixel = 0,
}, sidebarBg)

local sidebar = make("Frame", {
    Size = UDim2.new(0, SIDEBAR_W, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 2,
}, body)
make("UISizeConstraint", { MinSize = Vector2.new(SIDEBAR_W, 230) }, sidebar)
make("UIPadding", {
    PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 9),
}, sidebar)
make("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, sidebar)

local holder = make("Frame", {
    Position = UDim2.fromOffset(SIDEBAR_W, 0),
    Size = UDim2.new(1, -SIDEBAR_W, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
}, body)
make("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, holder)

--  =   curPage = pages.<key>
local TABS = {
    { key = "farm",     text = "\224\184\159\224\184\178\224\184\163\224\185\140\224\184\161"   },
    { key = "seaevent", text = "ล่าอีเว้นทะเล" },
    { key = "fruit",    text = "หาผล" },
    { key = "settings", text = "\224\184\149\224\184\177\224\185\137\224\184\135\224\184\132\224\185\136\224\184\178"  },
}
local pages, tabBtns, tabStrokes = {}, {}, {}
local closeAllPopups = {} --  dropdown ()

local function selectTab(key)
    for _, t in ipairs(TABS) do
        local on = (t.key == key)
        pages[t.key].Visible = on
        local b = tabBtns[t.key]
        b.BackgroundColor3 = on and C.chipOn or C.head
        b.BackgroundTransparency = on and 0 or 1
        b.TextColor3 = on and C.blue or C.soft
        tabStrokes[t.key].Transparency = on and 0 or 1
    end
    for _, f in ipairs(closeAllPopups) do pcall(f) end
end

for i, t in ipairs(TABS) do
    local pg = make("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Visible = (i == 1),
        LayoutOrder = i,
    }, holder)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
    }, pg)
    make("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, pg)
    pages[t.key] = pg

    local b = make("TextButton", {
        Text = t.text, AutoButtonColor = false,
        Font = Enum.Font.GothamMedium, TextSize = 13,
        TextColor3 = C.soft,
        BackgroundColor3 = C.head, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        LayoutOrder = i,
        ZIndex = 3,
    }, sidebar)
    round(b, 6)
    local st = outline(b, C.blue)
    st.Transparency = 1
    tabStrokes[t.key] = st
    b.Activated:Connect(function() selectTab(t.key) end)
    tabBtns[t.key] = b
end
selectTab("farm")

local curPage = pages.farm --  newRow()

local rowOrder = 0
local function newRow(gap)
    rowOrder += 1
    local f = make("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = C.row,
        BorderSizePixel = 0,
        LayoutOrder = rowOrder,
    }, curPage)
    round(f, 8)
    outline(f, C.line)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14),
    }, f)
    make("UIListLayout", {
        Padding = UDim.new(0, gap or 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, f)
    return f
end

local function label(parent, text, order)
    return make("TextLabel", {
        Text = text, Font = Enum.Font.GothamMedium, TextSize = 14,
        TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        LayoutOrder = order or 1,
    }, parent)
end

local function titleLine(parent, text, order)
    local line = make("Frame", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        LayoutOrder = order or 1,
    }, parent)
    local lbl = make("TextLabel", {
        Text = text, Font = Enum.Font.GothamMedium, TextSize = 14,
        TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true, BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 1, 0),
    }, line)
    return line, lbl
end

local function switch(parent, initial, onChange)
    local btn = make("TextButton", {
        Text = "", AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(44, 24),
        BackgroundColor3 = C.chip,
    }, parent)
    round(btn, 12)
    outline(btn, Color3.fromRGB(74, 74, 80))
    local knob = make("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = C.soft,
        BorderSizePixel = 0,
    }, btn)
    round(knob, 9)

    local on = initial
    local info = TweenInfo.new(0.15)
    local function render()
        TweenService:Create(knob, info, {
            Position = on and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3),
            BackgroundColor3 = on and C.blue or C.soft,
        }):Play()
        TweenService:Create(btn, info, {
            BackgroundColor3 = on and C.chipOn or C.chip,
        }):Play()
    end
    btn.Activated:Connect(function()
        on = not on
        render()
        onChange(on, function(value)
            on = value and true or false
            render()
        end)
        State.scheduleSave()
    end)
    render()
    return btn
end

local statusRow = newRow(6)
local lines = {}
for i = 1, 4 do
    lines[i] = label(statusRow, "", i)
end

local function refreshStatus()
    local on = State.autoFarm
    if on then
        lines[1].Text = string.format('<font color="#6dff9f">\224\184\170\224\184\150\224\184\178\224\184\153\224\184\176: \224\185\128\224\184\155\224\184\180\224\184\148 \226\128\162 Level %s</font>', State.level)
    else
        lines[1].Text = '<font color="#9a9a9f">\224\184\170\224\184\150\224\184\178\224\184\153\224\184\176: \224\184\155\224\184\180\224\184\148</font>'
    end
    lines[2].Text = '\224\184\136\224\184\184\224\184\148\224\184\159\224\184\178\224\184\163\224\185\140\224\184\161: <font color="#b8c8f0">' .. (on and State.quest or "-") .. "</font>"
    lines[3].Text = '\224\184\161\224\184\173\224\184\153: <font color="#ffd2a8">'  .. (on and State.mob   or "-") .. "</font>"
    lines[4].Text = '\224\184\163\224\184\176\224\184\162\224\184\176: <font color="#ffe08a">'  .. (on and State.dist  or "-") .. "</font>"
    dot.BackgroundColor3 = on and C.green or C.off
end

local farmRow = newRow()
local farmLine = titleLine(farmRow, "AUTO FARM BONE")
switch(farmLine, State.autoFarm, function(on, setOn)
    if on then
        if State.levelFarmOn then setOn(false) return end
        if State.autoFarm then return end
        State.autoFarm = true
        enableNoclip()
        refreshStatus()
        startLoop()
    else
        stopLoop()
        refreshStatus()
    end
end)

do
    curPage = pages.farm
    local row = newRow()
    local line = titleLine(row, "ฟาร์มเลเวล + รับเควสต์อัตโนมัติ")
    switch(line, State.levelFarmOn, function(on, setOn)
        if on then
            if not LevelFarm.start() then setOn(false) end
        else
            LevelFarm.stop()
        end
    end)
    local statusLabel = label(row, State.levelFarmStatus, 2)
    statusLabel.TextWrapped = true
    task.spawn(function()
        while gui.Parent do
            statusLabel.Text = State.levelFarmStatus
            task.wait(0.25)
        end
    end)
end
curPage = pages.farm

curPage = pages.farm
local eliteRow = newRow(8)
local eliteLine = make("Frame", {
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundTransparency = 1,
    LayoutOrder = 1,
}, eliteRow)
make("TextLabel", {
    Text = "\224\184\165\224\185\136\224\184\178 Elite", Font = Enum.Font.GothamMedium, TextSize = 14,
    TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -150, 1, 0),
}, eliteLine)
local eliteBtn = make("TextButton", {
    Text = "\224\185\128\224\184\163\224\184\180\224\185\136\224\184\161", AutoButtonColor = false,
    Font = Enum.Font.GothamMedium, TextSize = 12,
    TextColor3 = C.text,
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, 0, 0.5, 0),
    Size = UDim2.fromOffset(140, 28),
    BackgroundColor3 = C.chipOn,
    TextTruncate = Enum.TextTruncate.AtEnd,
}, eliteLine)
round(eliteBtn, 6)
outline(eliteBtn, C.blue)
eliteBtn.Activated:Connect(function()
    if State.eliteOn then
        stopElite() -- press again while running = cancel
        return
    end
    task.spawn(function()
        runElite(function(msg) eliteBtn.Text = msg end)
        task.wait(2)
        if not State.eliteOn then eliteBtn.Text = "\224\185\128\224\184\163\224\184\180\224\185\136\224\184\161" end
    end)
end)

curPage = pages.seaevent
local seaEventPageRow = newRow()
titleLine(seaEventPageRow, "ตั้งค่าออโต้ฟาร์มทะเล", 1)

local seaBoatRow = newRow(8)
local seaBoatLine = make("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = 1 }, seaBoatRow)
make("TextLabel", { Text = "เลือกเรือ", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, -130, 1, 0) }, seaBoatLine)
local seaBoatButton = make("TextButton", { Text = State.seaSelectedBoat and (State.seaSelectedBoat .. " ▼") or "เลือกเรือ ▼", AutoButtonColor = false, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.text, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(120, 28), BackgroundColor3 = C.chip, TextTruncate = Enum.TextTruncate.AtEnd }, seaBoatLine)
round(seaBoatButton, 6)
outline(seaBoatButton, C.line)
local seaBoatPopup = make("Frame", { Visible = false, Size = UDim2.fromOffset(160, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.row, BorderSizePixel = 0, ZIndex = 20 }, gui)
round(seaBoatPopup, 6)
outline(seaBoatPopup, C.blue)
make("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4) }, seaBoatPopup)
make("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, seaBoatPopup)
local function openSeaBoatPopup()
    if seaBoatPopup.Visible then
        seaBoatPopup.Visible = false
        return
    end
    for _, child in ipairs(seaBoatPopup:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local options = readSeaBoatOptions()
    if #options == 0 then
        seaBoatButton.Text = "โหลดรายชื่อเรือ ▼"
        seaBoatPopup.Visible = false
        return
    end
    for i, boatName in ipairs(options) do
        local item = make("TextButton", { Text = boatName, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28), LayoutOrder = i, ZIndex = 21 }, seaBoatPopup)
        item.Activated:Connect(function()
            State.seaSelectedBoat = boatName
            State.scheduleSave()
            seaBoatButton.Text = boatName .. " ▼"
            seaBoatPopup.Visible = false
        end)
    end
    local pos = seaBoatButton.AbsolutePosition - gui.AbsolutePosition
    seaBoatPopup.Position = UDim2.fromOffset(pos.X, pos.Y + seaBoatButton.AbsoluteSize.Y + 2)
    seaBoatPopup.Size = UDim2.fromOffset(seaBoatButton.AbsoluteSize.X, #options * 28 + 8)
    seaBoatPopup.Visible = true
end
seaBoatButton.Activated:Connect(openSeaBoatPopup)
table.insert(closeAllPopups, function() seaBoatPopup.Visible = false end)

local SeaSpeedUI = {}
SeaSpeedUI.row = newRow(8)
SeaSpeedUI.line = make("Frame", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = 1 }, SeaSpeedUI.row)
make("TextLabel", { Text = "ความเร็วเรือ (1–400)", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, -60, 1, 0) }, SeaSpeedUI.line)
SeaSpeedUI.value = make("TextLabel", { Text = tostring(State.seaBoatSpeed), Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.blue, TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(52, 24) }, SeaSpeedUI.line)
SeaSpeedUI.track = make("TextButton", { Text = "", AutoButtonColor = false, BackgroundColor3 = C.chip, Size = UDim2.new(1, 0, 0, 8), LayoutOrder = 2 }, SeaSpeedUI.row)
round(SeaSpeedUI.track, 4)
SeaSpeedUI.fill = make("Frame", { BackgroundColor3 = C.blue, BorderSizePixel = 0, Size = UDim2.new((State.seaBoatSpeed - 1) / 399, 0, 1, 0) }, SeaSpeedUI.track)
round(SeaSpeedUI.fill, 4)
SeaSpeedUI.knob = make("Frame", { BackgroundColor3 = C.text, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new((State.seaBoatSpeed - 1) / 399, 0, 0.5, 0), Size = UDim2.fromOffset(14, 14) }, SeaSpeedUI.track)
round(SeaSpeedUI.knob, 7)
SeaSpeedUI.dragging = false
SeaSpeedUI.setFromX = function(x)
    local width = math.max(SeaSpeedUI.track.AbsoluteSize.X, 1)
    local alpha = math.clamp((x - SeaSpeedUI.track.AbsolutePosition.X) / width, 0, 1)
    State.seaBoatSpeed = math.clamp(math.floor(1 + alpha * 399 + 0.5), 1, 400)
    SeaSpeedUI.value.Text = tostring(State.seaBoatSpeed)
    local fraction = (State.seaBoatSpeed - 1) / 399
    SeaSpeedUI.fill.Size = UDim2.new(fraction, 0, 1, 0)
    SeaSpeedUI.knob.Position = UDim2.new(fraction, 0, 0.5, 0)
    State.scheduleSave()
end
SeaSpeedUI.track.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        SeaSpeedUI.dragging = true
        SeaSpeedUI.setFromX(input.Position.X)
    end
end)
UIS.InputChanged:Connect(function(input)
    if SeaSpeedUI.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        SeaSpeedUI.setFromX(input.Position.X)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        SeaSpeedUI.dragging = false
    end
end)

do
    local function makeMultiSelect(title, entries, values)
        local row = newRow(6)
        local line = make("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = 1 }, row)
        make("TextLabel", { Text = title, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, -186, 1, 0) }, line)
        local button = make("TextButton", { Text = "เลือก 0/" .. #entries .. " ▼", AutoButtonColor = false, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.text, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(176, 28), BackgroundColor3 = C.chip, TextTruncate = Enum.TextTruncate.AtEnd }, line)
        round(button, 6)
        outline(button, C.line)
        local popup = make("Frame", { Visible = false, Size = UDim2.fromOffset(176, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.row, BorderSizePixel = 0, ZIndex = 30 }, gui)
        round(popup, 6)
        outline(popup, C.blue)
        make("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4) }, popup)
        make("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, popup)
        local function refresh()
            local selected = 0
            for _, entry in ipairs(entries) do
                if values[entry[1]] then selected += 1 end
            end
            button.Text = string.format("เลือก %d/%d ▼", selected, #entries)
        end
        local function populate()
            for _, child in ipairs(popup:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            for i, entry in ipairs(entries) do
                local optionKey, optionLabel = entry[1], entry[2]
                local item = make("TextButton", { Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28), LayoutOrder = i, ZIndex = 31 }, popup)
                item.Activated:Connect(function()
                    values[optionKey] = not values[optionKey]
                    State.scheduleSave()
                    refresh()
                    populate()
                end)
                item.Text = (values[optionKey] and "✓  " or "□  ") .. optionLabel
            end
        end
        button.Activated:Connect(function()
            if popup.Visible then popup.Visible = false return end
            populate()
            local pos = button.AbsolutePosition - gui.AbsolutePosition
            local popupHeight = #entries * 28 + 8
            local belowY = pos.Y + button.AbsoluteSize.Y + 2
            local y = belowY + popupHeight > gui.AbsoluteSize.Y and math.max(0, pos.Y - popupHeight - 2) or belowY
            popup.Position = UDim2.fromOffset(pos.X, y)
            popup.Size = UDim2.fromOffset(button.AbsoluteSize.X, popupHeight)
            popup.Visible = true
        end)
        table.insert(closeAllPopups, function() popup.Visible = false end)
        refresh()
    end

    makeMultiSelect("ประเภทอาวุธ", { { "Melee", "หมัด" }, { "Fruit", "ผล" }, { "Sword", "ดาบ" }, { "Gun", "ปืน" } }, State.seaWeaponTypes)
    makeMultiSelect("เลือกมอนสเตอร์ที่จะตี", {
        { "Terrorshark", "Terrorshark" },
        { "SeaBeast", "Sea Beast / Sea King" },
        { "GhostShip", "Ghost Ship" },
        { "Piranha", "Piranha" },
        { "Shark", "Shark" },
        { "FishCrewMember", "Fish Crew Member" },
    }, State.seaTargets)
    State.makeMultiSelect = makeMultiSelect
end

local seaFarmRow = newRow(8)
local seaFarmLine = titleLine(seaFarmRow, "ออโต้ฟาร์มทะเล", 1)
local seaFarmStatus = label(seaFarmRow, "พร้อม", 2)
switch(seaFarmLine, State.seaFarmOn, function(on)
    if on then
        State.seaFarmOn = true
        task.spawn(function() runSeaFarm(function(msg) seaFarmStatus.Text = msg end) end)
    else
        stopSeaFarm()
    end
end)
curPage = pages.farm

local adminBossRow = newRow(8)
local adminBossLine = make("Frame", {
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundTransparency = 1,
    LayoutOrder = 1,
}, adminBossRow)
make("TextLabel", {
    Text = "ตีบอสแอดมิน rip_indra", Font = Enum.Font.GothamMedium, TextSize = 14,
    TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -150, 1, 0),
}, adminBossLine)
local adminBossBtn = make("TextButton", {
    Text = "เริ่มฟาร์ม", AutoButtonColor = false,
    Font = Enum.Font.GothamMedium, TextSize = 12,
    TextColor3 = C.text,
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, 0, 0.5, 0),
    Size = UDim2.fromOffset(140, 28),
    BackgroundColor3 = C.chipOn,
    TextTruncate = Enum.TextTruncate.AtEnd,
}, adminBossLine)
round(adminBossBtn, 6)
outline(adminBossBtn, C.blue)
adminBossBtn.Activated:Connect(function()
    if State.adminBossOn then
        stopAdminBoss()
        adminBossBtn.Text = "เริ่มฟาร์ม"
        return
    end
    task.spawn(function()
        runAdminBoss(function(msg) adminBossBtn.Text = msg end)
        task.wait(2)
        if not State.adminBossOn then adminBossBtn.Text = "เริ่มฟาร์ม" end
    end)
end)
local chestRow = newRow(8)
local chestLine = make("Frame", {
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundTransparency = 1,
    LayoutOrder = 1,
}, chestRow)
make("TextLabel", {
    Text = "\224\184\159\224\184\178\224\184\163\224\185\140\224\184\161\224\184\171\224\184\181\224\184\154", Font = Enum.Font.GothamMedium, TextSize = 14,
    TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -150, 1, 0),
}, chestLine)
local chestBtn = make("TextButton", {
    Text = "\224\185\128\224\184\163\224\184\180\224\185\136\224\184\161", AutoButtonColor = false,
    Font = Enum.Font.GothamMedium, TextSize = 12,
    TextColor3 = C.text,
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, 0, 0.5, 0),
    Size = UDim2.fromOffset(140, 28),
    BackgroundColor3 = C.chipOn,
    TextTruncate = Enum.TextTruncate.AtEnd,
}, chestLine)
round(chestBtn, 6)
outline(chestBtn, C.blue)
chestBtn.Activated:Connect(function()
    if State.chestOn then
        stopChest() -- press again while running = stop
        return
    end
    task.spawn(function()
        runChest(function(msg) chestBtn.Text = msg end)
        task.wait(2)
        if not State.chestOn then chestBtn.Text = "\224\185\128\224\184\163\224\184\180\224\185\136\224\184\161" end
    end)
end)

curPage = pages.settings
local speedRow = newRow()
local _, speedTitle = titleLine(speedRow, "Speed", 1)
local speedValue = make("TextLabel", {
    Font = Enum.Font.GothamMedium, TextSize = 14, RichText = true,
    TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Right,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    Size = UDim2.new(0, 120, 1, 0),
}, speedTitle.Parent)

local sliderHit = make("Frame", {
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    LayoutOrder = 2,
}, speedRow)
local track = make("Frame", {
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 0, 0.5, 0),
    Size = UDim2.new(1, 0, 0, 4),
    BackgroundColor3 = Color3.fromRGB(70, 70, 76),
    BorderSizePixel = 0,
}, sliderHit)
round(track, 2)
local fill = make("Frame", {
    Size = UDim2.fromScale(0, 1),
    BackgroundColor3 = C.blue,
    BorderSizePixel = 0,
}, track)
round(fill, 2)
local knob2 = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0, 0.5),
    Size = UDim2.fromOffset(18, 18),
    BackgroundColor3 = C.blue,
    BorderSizePixel = 0,
}, track)
round(knob2, 9)

local function setSpeed(v)
    v = math.clamp(math.floor(v + 0.5), 1, MAX_SPEED)
    State.speed = v
    State.scheduleSave()
    local a = (v - 1) / (MAX_SPEED - 1)
    fill.Size = UDim2.fromScale(a, 1)
    knob2.Position = UDim2.fromScale(a, 0.5)
    speedValue.Text = string.format(
        '<font color="#1a8fe0">%d</font><font color="#7d7d82"> / %d</font>',
        v, MAX_SPEED
    )
end

------------------------------------------------------------
-- Auto Stats ()
------------------------------------------------------------
local STAT_LIST  = { "Melee", "Defense", "Sword", "Gun", "Demon Fruit" }
local STAT_LABEL = { Melee = "Melee", Defense = "Def", Sword = "Sword", Gun = "Gun", ["Demon Fruit"] = "Fruit" }
local statSel    = State.statSelection   -- :  1  = ,  =
local statsThread = nil

-- :  Data.Points   GUI Stats
local function getStatPoints()
    local data = lp:FindFirstChild("Data")
    local p = data and data:FindFirstChild("Points")
    if p and p:IsA("ValueBase") then return tonumber(p.Value) or 0 end

    local ok, result = pcall(function()
        local root = playerGui.StatsRoot.Frame.Menu.Content.Stats
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("TextLabel") then
                local n = d.Text:match("[Pp]oints?%s*[:%-]?%s*(%d+)")
                    or d.Text:match("(%d+)%s*[Pp]oints?")
                if n then return tonumber(n) end
            end
        end
        return nil
    end)
    if ok then return result end
    return nil
end

local function addStatPoint(stat, amount)
    if not CommF then return false end
    local ok = pcall(function()
        CommF:InvokeServer("AddPoint", stat, amount)
    end)
    return ok
end

local function runAutoStats()
    if statsThread then return end
    statsThread = task.spawn(function()
        while gui.Parent do
            local pts = getStatPoints()
            if pts and pts > 0 then
                local sel = {}
                for _, s in ipairs(STAT_LIST) do
                    if statSel[s] then table.insert(sel, s) end
                end
                if #sel > 0 then
                    local per = math.floor(pts / #sel)
                    local rem = pts - per * #sel
                    for i, s in ipairs(sel) do
                        if not statSel[s] then break end
                        local amt = per + (i == 1 and rem or 0)
                        if amt > 0 then
                            addStatPoint(s, amt)
                            print("[Stats] \224\185\128\224\184\158\224\184\180\224\185\136\224\184\161 " .. s .. " +" .. amt)
                            task.wait(0.2)
                        end
                    end
                end
            end
            task.wait(1)
        end
        statsThread = nil
    end)
end

------------------------------------------------------------
--  ( Backpack/ =  Hotbar)
-- State.weapon = nil   (Combat/Sword/Melee/)
------------------------------------------------------------
do
    local wRow = newRow(8)
    local wLine = make("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
    }, wRow)
    make("TextLabel", {
        Text = "\224\184\173\224\184\178\224\184\167\224\184\184\224\184\152\224\185\130\224\184\136\224\184\161\224\184\149\224\184\181", Font = Enum.Font.GothamMedium, TextSize = 14,
        TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -150, 1, 0),
    }, wLine)

    local wBtn = make("TextButton", {
        Text = "", AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(140, 28),
        BackgroundColor3 = C.chip,
    }, wLine)
    round(wBtn, 6)
    outline(wBtn, C.line)
    local wText = make("TextLabel", {
        Text = "Auto",
        Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(8, 0),
        Size = UDim2.new(1, -26, 1, 0),
    }, wBtn)
    make("TextLabel", {
        Text = "\226\150\190", Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = C.blue, BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -6, 0.5, 0),
        Size = UDim2.fromOffset(16, 16),
    }, wBtn)

    local wPopup = make("Frame", {
        Visible = false,
        BackgroundColor3 = C.row,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, gui)
    round(wPopup, 6)
    outline(wPopup, C.blue)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
    }, wPopup)
    make("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, wPopup)

    local wItems = {}
    local wOpen = false

    local categoryLabels = { Melee = "หมัด", Gun = "ปืน", Fruit = "ผล", Sword = "ดาบ" }

    local function refreshText()
        wText.Text = categoryLabels[State.weapon] or "Auto"
    end

    local function placeW()
        local p = wBtn.AbsolutePosition - gui.AbsolutePosition
        local sc = wBtn.AbsoluteSize.Y / 28
        wPopup.Size = UDim2.fromOffset(wBtn.AbsoluteSize.X, (#wItems * 28 + 8) * sc)
        wPopup.Position = UDim2.fromOffset(p.X, p.Y + wBtn.AbsoluteSize.Y + 2)
        for _, it in ipairs(wItems) do
            it.Size = UDim2.new(1, 0, 0, 28 * sc)
            it.TextSize = math.max(math.floor(13 * sc), 8)
        end
    end

    local function setW(v)
        wOpen = v
        if v then
            --
            for _, it in ipairs(wItems) do it:Destroy() end
            table.clear(wItems)
            local options = { false, "Melee", "Gun", "Fruit", "Sword" } -- false = Auto
            for i, opt in ipairs(options) do
                local name = opt or nil
                local item = make("TextButton", {
                    Font = Enum.Font.GothamMedium, TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 28),
                    LayoutOrder = i, ZIndex = 11,
                }, wPopup)
                make("UIPadding", { PaddingLeft = UDim.new(0, 6) }, item)
                local selected = (State.weapon == name)
                item.Text = (selected and "\226\151\143  " or "\226\151\139  ") .. (categoryLabels[name] or "Auto")
                item.TextColor3 = selected and C.blue or C.soft
                item.Activated:Connect(function()
                    State.weapon = name
                    State.scheduleSave()
                    refreshText()
                    print("[Weapon] \224\185\128\224\184\165\224\184\183\224\184\173\224\184\129: " .. (name or "Auto"))
                    setW(false)
                end)
                wItems[i] = item
            end
            placeW()
        end
        wPopup.Visible = v and main.Visible
    end

    wBtn.Activated:Connect(function() setW(not wOpen) end)
    wBtn:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        if wOpen then placeW() end
    end)
    wBtn:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if wOpen then placeW() end
    end)
    main:GetPropertyChangedSignal("Visible"):Connect(function()
        if not main.Visible then setW(false) end
    end)
    refreshText()
    table.insert(closeAllPopups, function() setW(false) end)
end

curPage = pages.settings
local statsRow = newRow(8)
titleLine(statsRow, "AUTO STATS", 1)
runAutoStats() --  dropdown

-- :  () +  dropdown  ()
local selRow = make("Frame", {
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundTransparency = 1,
    LayoutOrder = 2,
}, statsRow)

local pointsLabel = make("TextLabel", {
    Text = "", Font = Enum.Font.GothamMedium, TextSize = 13,
    TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
    RichText = true, BackgroundTransparency = 1,
    Size = UDim2.new(1, -150, 1, 0),
}, selRow)
task.spawn(function()
    while gui.Parent do
        local pts = getStatPoints()
        pointsLabel.Text = '\224\185\129\224\184\149\224\185\137\224\184\161: <font color="#ffe08a">'
            .. (pts and tostring(pts) or "\224\184\173\224\185\136\224\184\178\224\184\153\224\185\132\224\184\161\224\185\136\224\185\132\224\184\148\224\185\137") .. "</font>"
        task.wait(0.5)
    end
end)

local function selectedText()
    local names = {}
    for _, s in ipairs(STAT_LIST) do
        if statSel[s] then table.insert(names, STAT_LABEL[s]) end
    end
    if #names == 0 then return "\224\184\155\224\184\180\224\184\148 (\224\185\132\224\184\161\224\185\136\224\185\132\224\184\148\224\185\137\224\185\128\224\184\165\224\184\183\224\184\173\224\184\129)" end
    return table.concat(names, ", ")
end

local ddBtn = make("TextButton", {
    Text = "", AutoButtonColor = false,
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, 0, 0.5, 0),
    Size = UDim2.fromOffset(140, 28),
    BackgroundColor3 = C.chip,
}, selRow)
round(ddBtn, 6)
outline(ddBtn, C.line)

local ddText = make("TextLabel", {
    Text = selectedText(),
    Font = Enum.Font.GothamMedium, TextSize = 12,
    TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(8, 0),
    Size = UDim2.new(1, -26, 1, 0),
}, ddBtn)
make("TextLabel", {
    Text = "\226\150\190", Font = Enum.Font.GothamBold, TextSize = 14,
    TextColor3 = C.blue, BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -6, 0.5, 0),
    Size = UDim2.fromOffset(16, 16),
}, ddBtn)

--  dropdown   UI
local popup = make("Frame", {
    Visible = false,
    BackgroundColor3 = C.row,
    BorderSizePixel = 0,
    ZIndex = 10,
}, gui)
round(popup, 6)
outline(popup, C.blue)
make("UIPadding", {
    PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4),
    PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
}, popup)
make("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, popup)

local ddItems = {}
for i, stat in ipairs(STAT_LIST) do
    local item = make("TextButton", {
        Font = Enum.Font.GothamMedium, TextSize = 13,
        TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 28),
        LayoutOrder = i, ZIndex = 11,
    }, popup)
    make("UIPadding", { PaddingLeft = UDim.new(0, 6) }, item)
    local function render()
        item.Text = (statSel[stat] and "\226\152\145  " or "\226\152\144  ") .. stat
        item.TextColor3 = statSel[stat] and C.blue or C.soft
    end
    render()
    item.Activated:Connect(function()
        statSel[stat] = not statSel[stat]
        State.scheduleSave()
        render()
        ddText.Text = selectedText()
    end)
    ddItems[i] = item
end

local ddOpen = false
local function placePopup()
    local p = ddBtn.AbsolutePosition - gui.AbsolutePosition
    local sc = ddBtn.AbsoluteSize.Y / 28
    popup.Size = UDim2.fromOffset(ddBtn.AbsoluteSize.X, (#STAT_LIST * 28 + 8) * sc)
    for _, it in ipairs(ddItems) do
        it.Size = UDim2.new(1, 0, 0, 28 * sc)
        it.TextSize = math.max(math.floor(13 * sc), 8)
    end
    popup.Position = UDim2.fromOffset(p.X, p.Y + ddBtn.AbsoluteSize.Y + 2)
end
local function setDD(v)
    ddOpen = v
    popup.Visible = v and main.Visible
    if v then placePopup() end
end
table.insert(closeAllPopups, function() setDD(false) end)
ddBtn.Activated:Connect(function() setDD(not ddOpen) end)
ddBtn:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
    if ddOpen then placePopup() end
end)
ddBtn:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    if ddOpen then placePopup() end
end)
main:GetPropertyChangedSignal("Visible"):Connect(function()
    if not main.Visible then setDD(false) end
end)

local sliding = false
local function slideTo(x)
    local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
    setSpeed(1 + rel * (MAX_SPEED - 1))
end

sliderHit.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true; slideTo(input.Position.X)
    end
end)

local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    local moving = input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    if not moving then return end
    if sliding then
        slideTo(input.Position.X)
    elseif dragging then
        local d = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliding, dragging = false, false
    end
end)

-- ======  +  R / +  ======
local setVisible
do
--
local MIN_SCALE, MAX_SCALE = 0.35, 2
local uiScale = make("UIScale", { Scale = State.uiScale }, main)
local userResized = State.uiScaleSaved
local IS_TOUCH = UIS.TouchEnabled and not UIS.MouseEnabled
local LOGO_SIZE = IS_TOUCH and 32 or 56
local TOUCH_SHRINK = 1.0 --  ใช้ความกว้างหน้าจอเป็นตัวจำกัด ส่วนความสูงให้เลื่อนใน ScrollFrame

-- มุมขวาล่างมุมเดียว: ลากซ้าย-ขวา = ปรับ "ความกว้าง" | ลากขึ้น-ลง = ย่อ/ขยายทั้งหน้าต่าง
-- (มุมซ้ายบนอยู่กับที่) ความสูงปรับตามเนื้อหาอัตโนมัติ
local GRIP = IS_TOUCH and 34 or 28
local MIN_W, MAX_W = 300, 720

local grip = make("TextButton", {
	Name = "ResizeGrip",
	Text = "\226\151\162", -- ◢
	Font = Enum.Font.SourceSansBold,
	TextSize = 22,
	TextColor3 = C.blue,
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(1, 1),
	Size = UDim2.fromOffset(GRIP, GRIP),
	ZIndex = 5,
}, gui)

local function placeGrip()
	grip.Visible = main.Visible
	local p = main.AbsolutePosition - gui.AbsolutePosition
	grip.Position = UDim2.fromOffset(p.X + main.AbsoluteSize.X - 2, p.Y + main.AbsoluteSize.Y - 2)
end
main:GetPropertyChangedSignal("AbsolutePosition"):Connect(placeGrip)
main:GetPropertyChangedSignal("AbsoluteSize"):Connect(placeGrip)
main:GetPropertyChangedSignal("Visible"):Connect(placeGrip)

local resizing -- { tl, w0, h0u, s0, pos0, center0 }
grip.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		local p = main.AbsolutePosition
		local sz = main.AbsoluteSize
		resizing = {
			tl = p,                              -- มุมซ้ายบน (ต้องไม่ขยับ)
			s0 = uiScale.Scale,
			h0 = math.max(sz.Y, 1),              -- ความสูงตอนเริ่มลาก (หน่วยหน้าจอ)
			hu = sz.Y / uiScale.Scale,           -- ความสูงก่อนสเกล
			pos0 = main.Position,
			center0 = p + sz / 2,
			dy0 = math.max(input.Position.Y + gui.AbsolutePosition.Y - p.Y, 1), -- ระยะแนวตั้งตอนเริ่มจับ
			gx = input.Position.X + gui.AbsolutePosition.X - (p.X + sz.X),     -- จุดที่จับห่างขอบขวากี่ px
		}
	end
end)
UIS.InputChanged:Connect(function(input)
	if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		local ptr = Vector2.new(input.Position.X, input.Position.Y) + gui.AbsolutePosition
		-- ขึ้น-ลง → สเกล
		local newScale = math.clamp(
			resizing.s0 * (ptr.Y - resizing.tl.Y) / resizing.dy0, MIN_SCALE, MAX_SCALE
		)
		-- ซ้าย-ขวา → ความกว้างก่อนสเกล
		local newW = math.clamp((ptr.X - resizing.gx - resizing.tl.X) / newScale, MIN_W, MAX_W)
		userResized = true
		uiScale.Scale = newScale
		State.uiScale = newScale
		State.uiScaleSaved = true
		State.scheduleSave()
		main.Size = UDim2.new(0, newW, main.Size.Y.Scale, main.Size.Y.Offset)
		-- ให้มุมซ้ายบนอยู่ที่เดิม: จุดกึ่งกลางใหม่ = tl + ครึ่งหนึ่งของขนาดใหม่
		local newCenter = resizing.tl + Vector2.new(newW, resizing.hu) * newScale / 2
		local delta = newCenter - resizing.center0
		main.Position = UDim2.new(
			resizing.pos0.X.Scale, resizing.pos0.X.Offset + delta.X,
			resizing.pos0.Y.Scale, resizing.pos0.Y.Offset + delta.Y
		)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		resizing = nil
	end
end)
task.defer(placeGrip)

-- ======  (ScrollingFrame) ======
--
--
local HEADER_H = 42
local scroll = make("ScrollingFrame", {
	Name = "ContentScroll",
	Size = UDim2.new(1, 0, 0, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = C.blue,
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollingDirection = Enum.ScrollingDirection.Y,
	LayoutOrder = 2,
}, main)
body.Parent = scroll

local function updateScrollHeight()
	local sc = math.max(uiScale.Scale, 0.01)
	local area = gui.AbsoluteSize
	if area.Y <= 0 then
		local cam = workspace.CurrentCamera
		area = cam and cam.ViewportSize or Vector2.new(1280, 720)
	end
	local maxH = (area.Y * 0.9) / sc - HEADER_H
	local want = body.AbsoluteSize.Y / sc
	if want <= 0 then want = 400 end
	scroll.Size = UDim2.new(1, 0, 0, math.floor(math.max(math.min(want, maxH), 80)))
end
body:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScrollHeight)
uiScale:GetPropertyChangedSignal("Scale"):Connect(updateScrollHeight)
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScrollHeight)
task.defer(updateScrollHeight)

--
-- :  TOUCH_SHRINK  ()
-- :   Scale = 1
--
local fitting = false
local function autoFit()
	if userResized or fitting then return end
	local area = gui.AbsoluteSize
	if area.X <= 0 or area.Y <= 0 then
		local cam = workspace.CurrentCamera
		area = cam and cam.ViewportSize or Vector2.new(1280, 720)
	end
	local natW = 440
	local widthFit = (area.X * 0.9) / natW
	local fit
	if IS_TOUCH then
		fit = math.min(TOUCH_SHRINK, widthFit)
	else
		fit = math.min(1, widthFit)
	end
	fit = math.clamp(fit, MIN_SCALE, MAX_SCALE)
	if math.abs(fit - uiScale.Scale) > 0.01 then
		fitting = true
		uiScale.Scale = fit
		fitting = false
	end
end
--
for _, t in ipairs({ 0.2, 0.6, 1.2, 2.5 }) do
	task.delay(t, autoFit)
end
-- /   (   Scale)
main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	task.defer(autoFit)
end)
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	task.delay(0.2, autoFit)
end)

--
local function sizeBtn(txt, xOff, delta)
	local b = make("TextButton", {
		Text = txt, Font = Enum.Font.GothamBold, TextSize = 20,
		TextColor3 = C.blue, BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, xOff, 0.5, 0),
		Size = UDim2.fromOffset(28, 28),
	}, header)
	b.Activated:Connect(function()
		userResized = true
		uiScale.Scale = math.clamp(uiScale.Scale + delta, MIN_SCALE, MAX_SCALE)
		State.uiScale = uiScale.Scale
		State.uiScaleSaved = true
		State.scheduleSave()
	end)
end
sizeBtn("+", -112, 0.08)
sizeBtn("-", -80, -0.08)

-- ======  / UI ======
--  create.roblox.com > Creator Hub > Decals/Images
--  ID   "rbxassetid://1234567890"
--   R
local LOGO_ID = ""

local logo = make(LOGO_ID ~= "" and "ImageButton" or "TextButton", {
	Name = "RbotLogo",
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.new(0, 16, 0.2, 0),
	Size = UDim2.fromOffset(LOGO_SIZE, LOGO_SIZE),
	BackgroundColor3 = Color3.fromRGB(10, 10, 12),
	BackgroundTransparency = LOGO_ID ~= "" and 1 or 0,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	ZIndex = 5,
}, gui)

if LOGO_ID ~= "" then
	logo.Image = LOGO_ID
	logo.ScaleType = Enum.ScaleType.Fit
else
	logo.Text = "R"
	logo.Font = Enum.Font.GothamBlack
	logo.TextSize = IS_TOUCH and 20 or 34
	logo.TextColor3 = Color3.fromRGB(255, 140, 20)
	round(logo, 12)
	outline(logo, Color3.fromRGB(255, 100, 20))
end

State.infoPanel = make("Frame", {
    Name = "RbotEnabledInfo",
    Visible = false,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.fromOffset(310, 300),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    ZIndex = 80,
}, gui)
round(State.infoPanel, 10)
outline(State.infoPanel, C.blue)
State.infoTitle = make("TextLabel", {
    Text = "สถานะและค่าที่เปิดไว้",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = C.text,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(14, 10),
    Size = UDim2.new(1, -60, 0, 24),
    ZIndex = 81,
}, State.infoPanel)
State.infoClose = make("TextButton", {
    Text = "×",
    Font = Enum.Font.GothamBold,
    TextSize = 21,
    TextColor3 = C.text,
    BackgroundColor3 = C.chip,
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -8, 0, 7),
    Size = UDim2.fromOffset(30, 28),
    ZIndex = 82,
}, State.infoPanel)
round(State.infoClose, 6)
State.infoBody = make("TextLabel", {
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 13,
    TextColor3 = C.soft,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(14, 42),
    Size = UDim2.new(1, -28, 1, -54),
    ZIndex = 81,
}, State.infoPanel)
State.infoClose.Activated:Connect(function() State.infoPanel.Visible = false end)
task.spawn(function()
    while gui.Parent do
        if State.infoPanel.Visible then State.refreshInfoPanel() end
        task.wait(0.4)
    end
end)

function State.refreshInfoPanel()
    local lines = {}
    if State.autoFarm then table.insert(lines, "เปิด: Auto Farm") end
    if State.levelFarmOn then table.insert(lines, "เปิด: ฟาร์มเลเวล — " .. tostring(State.mob or "กำลังเลือกเควสต์")) end
    if State.eliteOn then table.insert(lines, "เปิด: ล่า Elite") end
    if State.adminBossOn then table.insert(lines, "เปิด: ตีบอสแอดมิน") end
    if State.chestOn then table.insert(lines, "เปิด: ฟาร์มหีบ") end
    if State.seaFarmOn then table.insert(lines, "เปิด: ออโต้ฟาร์มทะเล") end
    if State.fruitFinderOn then table.insert(lines, "เปิด: หาผล") end
    if State.seaGunAutoFire then table.insert(lines, "เปิด: ยิงปืนอัตโนมัติ") end
    if State.v4Enabled then table.insert(lines, "เปิด: AUTO V4") end
    table.insert(lines, "ความเร็วบิน: " .. tostring(State.speed))
    table.insert(lines, "ความเร็วเรือ: " .. tostring(State.seaBoatSpeed))
    if State.seaSelectedBoat then table.insert(lines, "เรือ: " .. State.seaSelectedBoat) end
    if State.weapon then table.insert(lines, "อาวุธโจมตี: " .. State.weapon) end
    local seaWeapons = {}
    for key, enabled in pairs(State.seaWeaponTypes) do
        if enabled then table.insert(seaWeapons, key) end
    end
    if #seaWeapons > 0 then table.insert(lines, "ประเภทอาวุธทะเล: " .. table.concat(seaWeapons, ", ")) end
    local seaSkills = {}
    for key, enabled in pairs(State.seaSkills) do
        if enabled then table.insert(seaSkills, key) end
    end
    if #seaSkills > 0 then table.insert(lines, "สกิลที่เลือก: " .. table.concat(seaSkills, ", ")) end
    local seaTargets = {}
    for key, enabled in pairs(State.seaTargets) do
        if enabled then table.insert(seaTargets, key) end
    end
    if #seaTargets > 0 then table.insert(lines, "มอนสเตอร์ทะเล: " .. table.concat(seaTargets, ", ")) end
    State.infoBody.Text = #lines > 0 and table.concat(lines, "\n") or "ไม่มีระบบที่เปิดอยู่"
end

setVisible = function(v)
	main.Visible = v
	gui.Enabled = true
	if v then logo.Visible = true end
	TweenService:Create(logo, TweenInfo.new(0.15), {
		Size = v and UDim2.fromOffset(LOGO_SIZE, LOGO_SIZE) or UDim2.fromOffset(LOGO_SIZE - 6, LOGO_SIZE - 6),
	}):Play()
end

-- /  ( 6px  )
--  v3:  Draggable  Roblox  (  InputChanged)
--  Draggable
logo.Active = true
pcall(function() logo.Draggable = true end)

local LogoGesture = { down = false, input = nil, startAbs = nil, startPtr = nil, pos = nil, moved = false, manual = false, startedAt = 0, infoOpened = false }

local function lPoint()
	if LogoGesture.input and LogoGesture.input.UserInputType == Enum.UserInputType.Touch then
		return Vector2.new(LogoGesture.input.Position.X, LogoGesture.input.Position.Y)
	end
	return UIS:GetMouseLocation()
end

logo.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		LogoGesture.down, LogoGesture.input = true, input
		LogoGesture.moved, LogoGesture.manual, LogoGesture.infoOpened = false, false, false
		LogoGesture.startedAt = tick()
		LogoGesture.startAbs = logo.AbsolutePosition
		LogoGesture.startPtr = lPoint()
		LogoGesture.pos = logo.Position
	end
end)

RunService.RenderStepped:Connect(function()
	if not LogoGesture.down then
		return
	end
	local d = lPoint() - LogoGesture.startPtr
	if d.Magnitude > 6 then
		LogoGesture.moved = true
	end
	if not LogoGesture.moved and not LogoGesture.infoOpened and tick() - LogoGesture.startedAt >= 0.65 then
		LogoGesture.infoOpened = true
		State.refreshInfoPanel()
		State.infoPanel.Visible = true
	end
	local engineMoved = (logo.AbsolutePosition - LogoGesture.startAbs).Magnitude
	--  = Draggable
	if d.Magnitude > 12 and engineMoved < 1 then
		LogoGesture.manual = true
	end
	if LogoGesture.manual then
		logo.Position = UDim2.new(
			LogoGesture.pos.X.Scale, LogoGesture.pos.X.Offset + d.X,
			LogoGesture.pos.Y.Scale, LogoGesture.pos.Y.Offset + d.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if LogoGesture.down and (input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch) then
		LogoGesture.down, LogoGesture.input = false, nil
		task.wait()
		local engineMoved = (logo.AbsolutePosition - LogoGesture.startAbs).Magnitude
		if not LogoGesture.moved and not LogoGesture.infoOpened and engineMoved < 6 then
			setVisible(not main.Visible)
		end
	end
end)
end

closeBtn.Activated:Connect(function()
    -- Closing the HUD only hides the interface; it must not stop Auto Farm.
    setVisible(false)
    logo.Visible = false
    grip.Visible = false
    gui.Enabled = false
end)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        setVisible(not main.Visible)
    end
end)



------------------------------------------------------------
-- Auto Race V4:  V4 ( Y)
--  Character.RaceEnergy (  PlayerGui.RaceEnergyUI.RaceEnergy)
--   Y  5  ()
------------------------------------------------------------
local V4 = { enabled = true, lastTry = 0, dumped = false }
local VIM = nil
pcall(function() VIM = game:GetService("VirtualInputManager") end)

local function getRaceEnergyUI()
    local pg = lp:FindFirstChild("PlayerGui")
    local ui = pg and pg:FindFirstChild("RaceEnergyUI")
    return ui and ui:FindFirstChild("RaceEnergy")
end

--  0..1  nil
local function readRaceEnergy()
    local char = lp.Character
    if char then
        local v = char:FindFirstChild("RaceEnergy")
        if v and (v:IsA("NumberValue") or v:IsA("IntValue")) then
            return v.Value > 1.5 and v.Value / 100 or v.Value
        end
        local a = char:GetAttribute("RaceEnergy")
        if type(a) == "number" then return a > 1.5 and a / 100 or a end
    end
    local root = getRaceEnergyUI()
    if root then
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("GuiObject") then
                local n = d.Name:lower()
                if n:find("fill") or n:find("bar") or n:find("progress") or n:find("energy") then
                    if d.Size.X.Scale > 0 and d.Size.X.Scale <= 1.01 and d ~= root then
                        return d.Size.X.Scale
                    end
                end
            end
        end
    end
    return nil
end

local function isV4On()
    local char = lp.Character
    local t = char and char:FindFirstChild("RaceTransformed")
    return t and t:IsA("BoolValue") and t.Value or false
end

local function pressY()
    if not VIM then return end
    pcall(function()
        VIM:SendKeyEvent(true, Enum.KeyCode.Y, false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, Enum.KeyCode.Y, false, game)
    end)
end

task.spawn(function()
    while gui.Parent do
        task.wait(1)
        if V4.enabled and lp.Character and not isV4On() then
            local e = readRaceEnergy()
            local gap = e and 3 or 5
            if (not e or e >= 0.99) and tick() - V4.lastTry >= gap then
                V4.lastTry = tick()
                if CONFIG.Debug then
                    print(("[V4] \224\184\158\224\184\165\224\184\177\224\184\135 %s \226\128\148 \224\184\129\224\184\148 Y"):format(e and string.format("%.0f%%", e * 100) or "\224\184\173\224\185\136\224\184\178\224\184\153\224\185\132\224\184\161\224\185\136\224\185\132\224\184\148\224\185\137"))
                    if not e and not V4.dumped then
                        V4.dumped = true
                        local root = getRaceEnergyUI()
                        print("[V4] RaceEnergyUI.RaceEnergy = " .. (root and root:GetFullName() or "\224\185\132\224\184\161\224\185\136\224\184\158\224\184\154"))
                        if root then
                            for _, d in ipairs(root:GetDescendants()) do
                                print("[V4]   " .. d.ClassName .. " " .. d.Name)
                            end
                        end
                    end
                end
                pressY()
            end
        end
    end
end)

curPage = pages.settings
local v4Row = newRow()
local v4Line = titleLine(v4Row, "AUTO V4")
V4.enabled = State.v4Enabled
switch(v4Line, V4.enabled, function(on)
    V4.enabled = on
    State.v4Enabled = on
end)

local seaGunAutoRow = newRow()
local seaGunAutoLine = titleLine(seaGunAutoRow, "ยิงปืนอัตโนมัติ")
switch(seaGunAutoLine, State.seaGunAutoFire, function(on)
    State.seaGunAutoFire = on
end)
State.makeMultiSelect("เลือกสกิล Z/X/C/V", {
    { "Z", "สกิล Z" }, { "X", "สกิล X" }, { "C", "สกิล C" }, { "V", "สกิล V" },
}, State.seaSkills)

curPage = pages.fruit
local fruitFinderRow = newRow()
switch(titleLine(fruitFinderRow, "ค้นหาผลที่ตกอยู่"), State.fruitFinderOn, function(on)
    State.fruitFinderOn = on
    if on then
        FruitFinder.seedCache()
    else
        FruitFinder.scanToken += 1
        FruitFinder.scanning = false
        FruitFinder.update()
    end
end)
if State.fruitFinderOn then FruitFinder.seedCache() end
FruitFinder.statusLabel = label(newRow(), "ปิดระบบหาผล")
FruitFinder.statusLabel.Size = UDim2.new(1, 0, 0, 0)
FruitFinder.statusLabel.AutomaticSize = Enum.AutomaticSize.Y
FruitFinder.statusLabel.TextWrapped = true
titleLine(newRow(), "ไฮไลต์ผลที่อยู่ใกล้ที่สุดและแสดงระยะ", 1)
task.spawn(function()
    while gui.Parent do
        FruitFinder.update()
        task.wait(0.2)
    end
end)

curPage = pages.settings

setSpeed(State.speed)
refreshStatus()

task.spawn(function()
    while gui.Parent do
        refreshStatus()
        task.wait(0.4)
    end
end)

task.spawn(function()
    local data = lp:WaitForChild("Data", 30)
    if not data then return end
    local levelValue = data:WaitForChild("Level", 30)
    if not levelValue then return end

    State.level = tostring(levelValue.Value)
    print("[Level] \224\185\128\224\184\163\224\184\180\224\185\136\224\184\161\224\184\149\224\185\137\224\184\153 = " .. State.level)

    levelValue:GetPropertyChangedSignal("Value"):Connect(function()
        State.level = tostring(levelValue.Value)
        print("[Level] \224\185\128\224\184\155\224\184\165\224\184\181\224\185\136\224\184\162\224\184\153\224\185\128\224\184\155\224\185\135\224\184\153 = " .. State.level)
    end)
end)

-- Keep Auto Farm enabled through death and restart it after respawn.
lp.CharacterRemoving:Connect(function(char)
    -- Do not clear State.autoFarm here; the user's toggle should stay ON.
    disableNoclip()
    cleanupFly()
end)

lp.CharacterAdded:Connect(function(char)
    task.spawn(function()
        local hum = char:WaitForChild("Humanoid", 15)
        local root = char:WaitForChild("HumanoidRootPart", 15)
        if not hum or not root then
            warn("[Respawn] \224\184\149\224\184\177\224\184\167\224\184\165\224\184\176\224\184\132\224\184\163\224\185\128\224\184\129\224\184\180\224\184\148\224\185\132\224\184\161\224\185\136\224\184\132\224\184\163\224\184\154\224\184\160\224\184\178\224\184\162\224\185\131\224\184\153\224\185\128\224\184\167\224\184\165\224\184\178\224\184\151\224\184\181\224\185\136\224\184\129\224\184\179\224\184\171\224\184\153\224\184\148")
            return
        end
        -- Let Roblox finish initializing the new character before restarting movement.
        task.wait(1)
        if not State.autoFarm then return end
        if hum.Health <= 0 then return end
        -- Re-enable character noclip after respawn for every active farm mode.
        enableNoclip()
        -- Sea Farm owns its own respawn recovery; never restart the Bone loop here.
        if State.seaFarmOn then
            print("[Respawn] Sea Farm is active; skipping Bone Auto Farm restart")
            return
        end

        if State.eliteOn or State.chestOn then return end -- these modes run their own loop
        -- The previous loop exits on death; wait for its cleanup before starting another.
        local deadline = tick() + 8
        while loopThread and tick() < deadline do
            task.wait(0.1)
        end
        if State.autoFarm and not loopThread then
            print("[Respawn] \224\184\159\224\184\183\224\185\137\224\184\153\224\185\129\224\184\165\224\185\137\224\184\167 \226\128\148 \224\185\128\224\184\163\224\184\180\224\185\136\224\184\161 Auto Farm \224\184\149\224\185\136\224\184\173")
            startLoop()
        end
    end)
end)

print("[RbotHud ] \224\185\130\224\184\171\224\184\165\224\184\148\224\185\128\224\184\170\224\184\163\224\185\135\224\184\136 \226\128\148 \224\184\129\224\184\148 AUTO FARM BONE \224\185\128\224\184\158\224\184\183\224\185\136\224\184\173\224\185\128\224\184\163\224\184\180\224\185\136\224\184\161")

