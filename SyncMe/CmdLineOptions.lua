require("strict")
local arg          = arg
local format       = string.format
local masterTbl    = masterTbl
local next         = next
local pairs        = pairs
local require      = require
local setmetatable = setmetatable
local dbg          = require("Dbg"):dbg()

local Version      = require("Version")
local version      = Version.name
local M            = {}
   

local s_CmdLineOptions = {}

local function new(self)
   local o = {}

   setmetatable(o,self)
   self.__index = self

   return o
end

function M.options(self)
   if ( next(s_CmdLineOptions) ) then return s_CmdLineOptions end

   dbg.start{"CmdLineOptions:options"}

   s_CmdLineOptions = new(self)

   local Optiks = require("Optiks")

   local masterTbl     = masterTbl()
   local usage         = "Usage: syncMe [options] cmd dir1 dir2 ..."
   local cmdlineParser = Optiks:new{usage=usage, version=format("syncMe %s",version())}

   cmdlineParser:add_option{ 
      name   = {'-v','--version'},
      dest   = 'version',
      action = 'store_true',
   }

   cmdlineParser:add_option{ 
      name   = {'-D','--debug'},
      dest   = 'verbosityLevel',
      action = 'count',
   }

   cmdlineParser:add_option{ 
      name   = {'-c','--command'},
      dest   = 'vc_cmd',
      action = 'store',
   }

   cmdlineParser:add_option{ 
      name    = {'-l','--list'},
      dest    = 'dirlist',
      action  = 'store',
      type    = 'string',
      default = ""
   }

   

   local optionTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optionTbl) do
      masterTbl[v] = optionTbl[v]
   end
   masterTbl.pargs = pargs
   
   dbg.fini()
   return s_CmdLineOptions
end

return M
