require("strict")
require("fileOps")
require("declare")
require("string_utils")
require("serializeTbl")

local dbg       = require("Dbg"):dbg()
local load      = (_VERSION == "Lua 5.1") and loadstring or load
local configDir = ".config/SyncMeTool"
local configFn  = "config.lua"
local getenv    = os.getenv
local max       = math.max

local M = {}

function M.new(self)
   local o = {}
   setmetatable(o,self)
   o.__size = 4

   local homeDir = getenv("HOME") or ""

   local fn = pathJoin(homeDir,configDir,configFn)
   local f  = io.open(fn)
   if (not f) then
      return o
   end

   local whole = f:read("*all")
   f:close()
   declare("SyncMeTool")
   assert(load(whole))()

   o.__size = SyncMeTool.size
   return o
end

function M.get_size(self)
   return self.__size
end
function M.set_size_max(self, size)
   
   self.__size = max(self.__size, size)
   
end

function M.save(self)
   local SyncMeTool = {}
   SyncMeTool.size = self.__size

   local homeDir = getenv("HOME")
   if (not homeDir) then return end
   mkdir_recursive(pathJoin(homeDir,configDir))

   local fn      = pathJoin(homeDir,configDir,configFn)
   local f       = io.open(fn,"w")
   if (f) then
      local s0 = "-- Date: " .. os.date("%c",os.time()) .. "\n"
      local s1 = serializeTbl{name="SyncMeTool", value = SyncMeTool, indent = true}
      f:write(s0,s1)
      f:close()
   end
end

return M
