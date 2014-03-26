PLUGIN.Title = "PlayerUtility"
PLUGIN.Description = " Help script for playerdata"
PLUGIN.Version = "3.0"
PLUGIN.Author = "Xevoxe"

local Player = {}
local Crafting = {}

function PLUGIN:Init()
  
  print("Loading Player Utility Realism++ Version 3.0")

        if( not api.Exists( "PlayerUtil" )) then print("PlayerUtil needs PlayerMeta")
        end
        Player = plugins.Find("PlayerMeta")
        
        if( not api.Exists( "CraftingMeta" )) then print("PlayerUtil needs CraftingMeta")
        end
        Crafting = plugins.Find("CraftingMeta")

   local b , res = config.Read("playerData")
    self.Config = res or {}
  if( not b ) then 
   -- self:LoadDefaultConfig()
   if ( res ) then config.Save("playerData") end
 end
 
 --self.saveTimer = timer.Repeat( 600 , function() self:SaveServer() end )
end

--***************************************
--On Player Connect HOOK
--***************************************
function PLUGIN:OnUserConnect(netuser)
  local userID = rust.GetUserID(netuser)
  --Check if player table already exists
  if(self.Config[userID]) then
    print("Load player")
    --exists
    --Set Player as a metatable to data
    local loadplayer = self.Config[userID]
    setmetatable(loadplayer , Player:New())
    setmetatable(loadplayer.Crafting , Crafting:New())
    self.Config[userID] = loadplayer
else
  --does not exist
  --create new data and set player as a metatable
  local newplayer = {}
  setmetatable(newplayer , Player:New())
  newplayer.Name = netuser.displayName
  newplayer.Creation = System.DateTime.Now:ToString("M/dd/yyyy")
  newplayer.LastLogin = util.GetTime()
  newplayer.Deaths = 0 
  newplayer.Kills = 0 
  local crafting = {}
  setmetatable( crafting , Crafting:New())
  newplayer.Crafting = crafting
  newplayer.Skills = skills
  self.Config[userID] = newplayer
  config.Save("playerData") --Remove this line for release version
  end 
end

--*************************************
--Get player data using userID
--*************************************
function PLUGIN:GetPlayerData( userID )
  if(userID ~= nil) then
  return selfConfig[userID]
else
  print("Error: FUNC:GetPlayerData - expected userID got nil")
  return
end
end


api.Bind(PLUGIN, "PlayerUtil")


