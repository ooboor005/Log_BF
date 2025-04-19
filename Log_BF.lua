repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
repeat task.wait() until (game.Players.LocalPlayer.Neutral == false) == true
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local MeleeRequestList = {
    ["Death Step"] = "BuyDeathStep",
    ["Sharkman Karate"] = "BuySharkmanKarate",
    ["Electric Claw"] = "BuyElectricClaw",
    ["Dragon Talon"] = "BuyDragonTalon",
    ["Godhuman"] = "BuyGodhuman",
    ["Super human"] = "BuySuperhuman",
    ["Sanguine Art"] = "BuySanguineArt"
}
function getLevel()
    return LocalPlayer.Data.Level.Value
end
function getWorld() 
	local placeId = game.PlaceId
	if placeId == 2753915549 then
		return 1
	elseif placeId == 4442272183 then
		return 2
	elseif placeId == 7449423635 then
		return 3
	end
end

function getItem(itemName) 
    for i,v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
        if type(v) == "table" then
            if v.Type == "Material" then
                if v.Name == itemName then
                    return true
                end
            end
        end
    end
    return false
end

function getFruitMastery()
    if game:GetService("Players").LocalPlayer.Data.DevilFruit.Value == '' then return 0 end
    if LocalPlayer:FindFirstChild("Backpack") then 
        for i,v in pairs(LocalPlayer:FindFirstChild("Backpack"):GetChildren()) do 
            if v.ToolTip == "Blox Fruit" then 
                if v:FindFirstChild("Level") then 
                    return v.Level.Value
                end
            end
        end
    end
    repeat wait() until LocalPlayer.Character
    if LocalPlayer.Character:FindFirstChildOfClass("Tool") then 
        local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if Tool.ToolTip == "Blox Fruit" then
            if Tool:FindFirstChild("Level") then 
				
                return Tool.Level.Value
            end
        end
    end
    return 0
end

function getFruitName()
    return string.split(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value,"-")[2] or "None"
end

function getAwakend()
    Awakened = {}
    Skill = 0
    if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AwakeningChanger", "Check") then
        Remote_Awaken = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getAwakenedAbilities")
        for i, v in pairs(Remote_Awaken) do
            Skill = Skill + 1
            if v["Key"] then
                if v["Awakened"] then
                    if i ~= "X" then
                        table.insert(Awakened, v["Key"])
                    else
                        table.insert(Awakened, v["Key"])
                    end
                end
            end
        end
    end
    if tonumber(#Awakened) == tonumber(Skill) and tonumber(Skill) ~= 0 then
        return {"Awakened"}
    end
    return Awakened
end

function getMeele()
    local MeleeName, RequestMeleeName = {}, nil;
    for i, v in pairs(MeleeRequestList) do 
        RequestMeleeName =  game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(v, true)
        if tonumber(RequestMeleeName) == 1 then 
            table.insert(MeleeName, i)
        end
    end
    return MeleeName
end

function getSword()
    local SwordList, RequestGetInvertory = {}, nil
    RequestGetInvertory = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
    for _, v in pairs(RequestGetInvertory) do 
        if v['Type'] == "Sword" then 
            if v['Rarity'] >= 3 then
                table.insert(SwordList, v['Name'].." ["..v.Mastery.."]")
            end
        end
    end
    return SwordList
end

function GetFruitInU()
    local ReturnText = {}
    for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventory")) do
        if type(v) == "table" then
            if v ~= nil and v.Type == "Blox Fruit" then
                if v.Value >= 100000  then
                    table.insert(ReturnText,string.split(v.Name,"-")[2])
                end
            end
        end
    end
    return ReturnText
end

function len(x)
    local q = 0
    for i, v in pairs(x) do
        q = q + 1
    end
    return q
end

function findItem(item) 
    local RequestgetInventory;
    RequestgetInventory = game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventory")
    for i, __ in pairs(RequestgetInventory) do
        if __["Name"] == item then
            return true
        end
    end
    return false
end

function getType()
    local ReturnText = {}
    local GodHumanLevel = 0
    local GodHuman = tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman", true))
    
    if findItem("Cursed Dual Katana") then 
        table.insert(ReturnText, "CDK")
    end
    if findItem("Shark Anchor") then 
        table.insert(ReturnText, "SA")
    end
    if findItem("Soul Guitar") then
        table.insert(ReturnText, "SG")
    end
    if findItem("Leviathan Heart") then
        table.insert(ReturnText, "Heart")
    end
	
    if GodHuman == 1 then
        local tool = LocalPlayer.Character:FindFirstChild('Godhuman') or LocalPlayer.Backpack:FindFirstChild('Godhuman') 
        if tool then
            local level = tool:FindFirstChild("Level")
            if level and level:IsA("IntValue") then
                GodHumanLevel = level.Value
            end
        end
        table.insert(ReturnText, "GOD".." ["..GodHumanLevel.."]")
    end
    return table.concat(ReturnText, " ")
end

function getVK()
	for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryWeapons")) do -- เช็คในกระเป๋า
            for i1,v1 in pairs(v) do
                if v1 == 'Valkyrie Helm' then
                    return true
                end
            end
        end
     if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild('Valkyrie Helm') or game:GetService("Players").LocalPlayer.Character:FindFirstChild('Valkyrie Helm') then
           return true
        end
    return false
end

function getEvoTier()
    local CheckAlchemist = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1")
    if CheckAlchemist == -2 then
        local CheckWenlocktoad = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
        if CheckWenlocktoad == -2 then
            if game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
                return 4
            end
            return 3
        end
        return 2
    end
    return 1
end


function getAwakendTier()
    local q, _ = pcall(function()
        return tonumber(game:GetService("Players").LocalPlayer.Data.Race.C.Value)
    end)
    if q then return _ end 
    return 0
end

function checkDoor()
    return game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("CheckTempleDoor")
end

function sendRequest()
    local res = request({
        Url = __script__host,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = __script__token,
        },
        Body = HttpService:JSONEncode({
            ["account"] = LocalPlayer.DisplayName,
            ["type"] = getType(),
            ["level"] = getLevel(),
            ["world"] = getWorld(),
            ["mirror"] = getItem("Mirror Fractal"),
            ["valk"] = getVK(),
            ["fruitMas"] = getFruitMastery(),
            ["fruit"] = getFruitName() or "None",
            ["awaken"] = getAwakend(),
            ["melee"] = getMeele(),
            ["beli"] = LocalPlayer.Data.Beli.Value,
            ["fragment"] = LocalPlayer.Data.Fragments.Value,
            ["machine"] = __script__machine,
            ["inventory"] = getSword(),
            ["fruitInv"] = GetFruitInU(),
            ["race"] = game:GetService("Players").LocalPlayer.Data.Race.Value,
            ["raceV"] = getEvoTier(),
            ["tier"] = getAwakendTier(),
            ["unlockDoor"] = checkDoor()
        })
    })
   warn(res.Body)
end

task.spawn(function()
    while true do
        local x, p = pcall(function()
            sendRequest()
        end)
        if not x then warn(p) end
        task.wait(10)
    end
end)
